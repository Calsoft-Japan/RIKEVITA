page 50409 "RV BackedDate Stock"
{
    ApplicationArea = All;
    Caption = 'BackedDate Stock';
    PageType = Card;
    //UsageCategory = tasks;
    SourceTable = "RV Invy. Available Name";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                /*field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }*/
                field("Inventory Valuation Date"; Rec."Inventory Valuation Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Item Filter"; Rec."Item Filter")
                {
                    caption = 'Item Filter';
                    ToolTip = 'Specifies the value of the Item Filter field.', Comment = '%';
                    applicationarea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(ItemList);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text := ItemList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }

            }
            Part(DeliverySchedulingLines; "RV.Stock Balance Lines")
            {
                ApplicationArea = All;
                Caption = 'Stock Lines';
                UpdatePropagation = Both;
                SubPageLink = "Available Invy. Name" = field(Name);
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Collect Data")
            {
                Caption = 'Collect Data';
                ApplicationArea = All;
                Image = InventoryCalculation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = false;
                trigger OnAction()
                var
                    WarehouseEntry: Record "Warehouse Entry";
                    WarehouseEntry1: Record "Warehouse Entry";
                    Vendor: Record Vendor;
                    Item: Record Item;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemLedgerEntry2: Record "Item Ledger Entry";
                    gLsetup: Record "General Ledger Setup";
                    Location: Record Location;
                    ItemNo: Code[20];
                    LocationCode: Code[10];
                    LotNo: Code[30];
                    NewSITECODE: Code[20];
                    SITECODE: Code[20];
                    //Bin: Record Bin;
                    BinCode: Code[20];
                begin
                    Rec.TestField("Inventory Valuation Date");
                    AvailableInvyLine.Reset();
                    AvailableInvyLine.SetRange("Available Invy. Name", Rec.Name);
                    AvailableInvyLine.DeleteAll();
                    RIKEVITASetup.Get();
                    //Inventory Quantity and Amount Information
                    StandardCostPeriod.reset;
                    StandardCostPeriod.Setfilter("Effective Start Date", '<=%1', Rec."Inventory Valuation Date");
                    StandardCostPeriod.Setfilter("Effective End Date", '>=%1', Rec."Inventory Valuation Date");
                    IF NOT StandardCostPeriod.FindLast() then begin
                        if NOT Dialog.Confirm('No found effective standart cost with the valuation date, Do you continute ?') then
                            Error('');
                        StandardCostPeriod.Init();
                    end;

                    AvailableInvyLine."Available Invy. Name" := Rec.Name;
                    EntryNo := 1;
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Posting Date", 0D, Rec."Inventory Valuation Date");
                    if Rec."Item Filter" <> '' then
                        ItemLedgerEntry.SetFilter("Item No.", Rec."Item Filter");
                    ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                    /*if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                        if SITECODE <> '' then
                            ItemLedgerEntry.SetRange("Global Dimension 1 Code", SITECODE);
                    end else begin
                        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                        if SITECODE <> '' then
                            ItemLedgerEntry.SetRange("Global Dimension 2 Code", SITECODE);
                    end;*/
                    if ItemLedgerEntry.FindSet() then begin
                        repeat
                            /*if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then
                                NewSITECODE := ItemLedgerEntry."Global Dimension 1 Code"
                            else
                                NewSITECODE := ItemLedgerEntry."Global Dimension 2 Code";*/
                            If (ItemNo <> ItemLedgerEntry."Item No.") OR
                            (LocationCode <> ItemLedgerEntry."Location Code") OR
                            (LotNo <> ItemLedgerEntry."Lot No.") then begin
                                //(SITECODE <> NewSITECODE) then begin
                                ItemNo := ItemLedgerEntry."Item No.";
                                LocationCode := ItemLedgerEntry."Location Code";
                                LotNo := ItemLedgerEntry."Lot No.";
                                //SITECODE := NewSITECODE;
                                IF Location.Get(LocationCode) then begin
                                    if Location."Bin Mandatory" = true Then begin
                                        WarehouseEntry.Reset();
                                        WarehouseEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Bin Code");
                                        WarehouseEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        WarehouseEntry.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                        WarehouseEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                        //WarehouseEntry.SetRange("RV_SITE Dim. Code", SITECODE);                                            
                                        if WarehouseEntry.FindSet() then begin
                                            BinCode := '-';
                                            repeat
                                                IF BinCode <> WarehouseEntry."Bin Code" then begin
                                                    BinCode := WarehouseEntry."Bin Code";
                                                    WarehouseEntry1.Reset();
                                                    WarehouseEntry1.CopyFilters(WarehouseEntry);
                                                    //Bin.Get(WarehouseEntry."Bin Code");
                                                    //WarehouseEntry1.Reset();
                                                    //WarehouseEntry1.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Zone Code", "Bin Code");
                                                    //WarehouseEntry1.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                                    //WarehouseEntry1.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                                    //WarehouseEntry1.SetRange("Lot No.", ItemLedgerEntry."Lot No.");                                                        
                                                    WarehouseEntry1.SetRange("Bin Code", BinCode);
                                                    WarehouseEntry1.CalcSums("Qty. (Base)");
                                                    WarehouseEntry1."Bin Code" := BinCode;
                                                    if WarehouseEntry1."Qty. (Base)" <> 0 then
                                                        InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1);
                                                end;
                                            until WarehouseEntry.Next() = 0;
                                        end;
                                    end else begin
                                        ItemLedgerEntry2.CopyFilters(ItemLedgerEntry);
                                        ItemLedgerEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        ItemLedgerEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                        /*if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                                            ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                                        end else begin
                                            ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                                        end;*/
                                        ItemLedgerEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        ItemLedgerEntry2.CalcSums(Quantity);
                                        Clear(WarehouseEntry1);
                                        if ItemLedgerEntry2.Quantity <> 0 then
                                            InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1);
                                    end;
                                end else begin
                                    ItemLedgerEntry2.CopyFilters(ItemLedgerEntry);
                                    ItemLedgerEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                    ItemLedgerEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                    /*if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                                        ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                                    end else begin
                                        ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                                    end;*/
                                    ItemLedgerEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                    ItemLedgerEntry2.CalcSums(Quantity);
                                    Clear(WarehouseEntry1);
                                    if ItemLedgerEntry2.Quantity <> 0 then
                                        InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1);
                                end;
                            end;
                        until ItemLedgerEntry.next = 0;
                    end;
                end;
            }

        }
    }
    procedure InsertInvyAvailableLine(ILE: Record "Item Ledger Entry"; WE: Record "Warehouse Entry")
    var
        Item: Record Item;
        LotInfo: Record "Lot No. Information";
        ItemCategory: Record "Item Category";
        GLSetup: Record "General Ledger Setup";
        location: Record Location;
        BinMaster: Record Bin;
        ItemUOM: Record "Item Unit of Measure";
        DefaultDim: Record "Default Dimension";
    begin
        AvailableInvyLine.Init();
        //Filter infromation
        AvailableInvyLine."Available Invy. Name" := Rec.Name;
        AvailableInvyLine."Entry No." := EntryNo;
        EntryNo += 1;
        AvailableInvyLine."Calculating Base Date" := rec."Inventory Valuation Date";
        AvailableInvyLine."Item No." := ILE."Item No.";

        //Item master infromation
        Item.get(ILE."Item No.");
        AvailableInvyLine."Item Description" := item.Description;
        AvailableInvyLine."Item Description 2" := item."Description 2";
        AvailableInvyLine.RSPO := item.RV_RSPO;
        AvailableInvyLine."Base Unit of Measure" := Item."Base Unit of Measure";
        AvailableInvyLine.Allergen := item.Allergen;
        //AvailableInvyLine."Derive Unit of Measure" :=
        AvailableInvyLine."KG Unit of Measure" := 'KG';
        AvailableInvyLine."Item Category Code" := Item."Item Category Code";
        DefaultDim.Reset();
        DefaultDim.SetRange("No.", ILE."Item No.");
        DefaultDim.SetRange("Table ID", 27);
        DefaultDim.SetRange("Dimension Code", RIKEVITASetup."Item Type Dim. Code");
        if DefaultDim.FindFirst() then
            AvailableInvyLine."Item Type" := DefaultDim."Dimension Value Code";
        DefaultDim.SetRange("Dimension Code", RIKEVITASetup."Segment Dim. Code");
        if DefaultDim.FindFirst() then
            AvailableInvyLine.Segment := DefaultDim."Dimension Value Code";

        //Inventory Information
        //AvailableInvyLine.Site := SITECODE;
        //AvailableInvyLine.Segment := ILE
        AvailableInvyLine.Location := ILE."Location Code";
        AvailableInvyLine."Lot No." := ILE."Lot No.";
        AvailableInvyLine."Bin Code" := WE."Bin Code";
        IF location.Get(ILE."Location Code") and (location."RV_Invy. Status" <> location."RV_Invy. Status"::Stock) Then
            AvailableInvyLine.Classification := Format(Location."RV_Invy. Status")
        else begin
            if BinMaster.Get(AvailableInvyLine.Location, WE."Bin Code") then
                AvailableInvyLine.Classification := Format(BinMaster."RV_Invy. Status")
        end;
        ;
        If LotInfo.Get(ILE."Item No.", ILE."Variant Code", ILE."Lot No.") then begin
            AvailableInvyLine."Sub Lot No." := LotInfo."RV_Sub Lot No.";
            AvailableInvyLine."Mfg. Date" := LotInfo."RV_Manufacture Date";
        end;
        if we."Bin Code" <> '' then
            AvailableInvyLine."Base Unit Invy. Qty." := WE."Qty. (Base)"
        else
            AvailableInvyLine."Base Unit Invy. Qty." := ILE.Quantity;
        if ItemUOM.Get(ILE."Item No.", 'KG') then begin
            AvailableInvyLine."KG Unit Invy. Qty." := Round(AvailableInvyLine."Base Unit Invy. Qty." / ItemUOM."Qty. per Unit of Measure", 0.00001);
        end;
        //
        AvailableInvyLine."Expiration Date" := ILE."Expiration Date";

        StandardCostElent.Reset();
        StandardCostElent.SetRange("Item No.", ILE."Item No.");
        StandardCostElent.SetRange(StandardCostElent."Period Code", StandardCostPeriod.Code);
        If StandardCostElent.FindFirst() then begin
            AvailableInvyLine."Direct Dep. Exp." := StandardCostElent."Direct Dep. Exp.";
            AvailableInvyLine."Direct Dep. Exp. Amt." := Round(AvailableInvyLine."Direct Dep. Exp." * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Direct Fixed Cost" := StandardCostElent."Direct Fixed Cost";
            AvailableInvyLine."Direct Fixed Cost Amt." := Round(AvailableInvyLine."Direct Fixed Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Direct Labor Cost" := StandardCostElent."Direct Labor Cost";
            AvailableInvyLine."Direct Labor Cost Amt." := Round(AvailableInvyLine."Direct Labor Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Electricity Fee" := StandardCostElent."Electricity Fee";
            AvailableInvyLine."Electricity Fee Amt." := round(AvailableInvyLine."Electricity Fee" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Gas Fee" := StandardCostElent."Gas Fee";
            AvailableInvyLine."Gas Fee Amt." := Round(AvailableInvyLine."Gas Fee" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Indirect Cost" := StandardCostElent."Indirect Cost";
            AvailableInvyLine."Indirect Cost Amt." := Round(AvailableInvyLine."Indirect Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Raw Material Cost" := StandardCostElent."Raw Material Cost";
            AvailableInvyLine."Raw Material Cost Amt." := Round(AvailableInvyLine."Raw Material Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine."Package Material Cost" := StandardCostElent."Package Material Cost";
            AvailableInvyLine."Package Material Cost Amt." := Round(AvailableInvyLine."Package Material Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");
            AvailableInvyLine.Water := StandardCostElent.Water;
            AvailableInvyLine."Water Amt." := Round(AvailableInvyLine.Water * AvailableInvyLine."Base Unit Invy. Qty.",
            GLSetup."Amount Rounding Precision");

            AvailableInvyLine."Unit Cost 1" := AvailableInvyLine."Direct Dep. Exp." +
                                               AvailableInvyLine."Direct Fixed Cost" +
                                               AvailableInvyLine."Direct Labor Cost" +
                                               AvailableInvyLine."Electricity Fee" +
                                               AvailableInvyLine."Gas Fee" +
                                               AvailableInvyLine."Indirect Cost" +
                                               AvailableInvyLine."Raw Material Cost" +
                                               AvailableInvyLine."Package Material Cost" +
                                               AvailableInvyLine.Water;
            AvailableInvyLine."Cost Amount 1" := AvailableInvyLine."Direct Dep. Exp. Amt." +
                                               AvailableInvyLine."Direct Fixed Cost Amt." +
                                               AvailableInvyLine."Direct Labor Cost Amt." +
                                               AvailableInvyLine."Electricity Fee Amt." +
                                               AvailableInvyLine."Gas Fee Amt." +
                                               AvailableInvyLine."Indirect Cost Amt." +
                                               AvailableInvyLine."Raw Material Cost Amt." +
                                               AvailableInvyLine."Package Material Cost Amt." +
                                               AvailableInvyLine."Water Amt.";

            //AvailableInvyLine."Unit Cost 2"
            //AvailableInvyLine."Cost Amount 2"

            //AvailableInvyLine."Unit Cost 3"
            //AvailableInvyLine."Cost Amount 3"

            //AvailableInvyLine."Roll Unit Cost"
            //AvailableInvyLine."Roll Cost Amount"

        end;
        AvailableInvyLine.Insert();
    end;

    var
        AvailableInvyLine: record "RV.Available Invy. Line";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        StandardCostElent: Record "Standard Cost Element Details";
        StandardCostPeriod: Record "Standard Cost Element Period";
        EntryNo: Integer;
}
