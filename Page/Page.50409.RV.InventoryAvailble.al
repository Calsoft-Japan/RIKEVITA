page 50409 "RV Inventory Availble Name"
{
    ApplicationArea = All;
    Caption = 'Inventory Availble Name';
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
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Starting Date"; Rec."Inventory Valuation Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }

            }
            Part(DeliverySchedulingLines; "RV.Available Invy. Lines")
            {
                ApplicationArea = All;
                Caption = 'Delivery Scheduling Lines';
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
                    AvailableInvyLine."Available Invy. Name" := Rec.Name;
                    EntryNo := 1;
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Posting Date", 0D, Rec."Inventory Valuation Date");
                    if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                        if SITECODE <> '' then
                            ItemLedgerEntry.SetRange("Global Dimension 1 Code", SITECODE);
                    end else begin
                        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                        if SITECODE <> '' then
                            ItemLedgerEntry.SetRange("Global Dimension 2 Code", SITECODE);
                    end;
                    if ItemLedgerEntry.FindSet() then begin
                        ItemLedgerEntry2.CopyFilters(ItemLedgerEntry);
                        repeat
                            if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then
                                NewSITECODE := ItemLedgerEntry."Global Dimension 1 Code"
                            else
                                NewSITECODE := ItemLedgerEntry."Global Dimension 2 Code";
                            If (ItemNo <> ItemLedgerEntry."Item No.") OR
                            (LocationCode <> ItemLedgerEntry."Location Code") OR
                            (LotNo <> ItemLedgerEntry."Lot No.") OR
                            (SITECODE <> NewSITECODE) then begin
                                ItemNo := ItemLedgerEntry."Item No.";
                                LocationCode := ItemLedgerEntry."Location Code";
                                LotNo := ItemLedgerEntry."Lot No.";
                                SITECODE := NewSITECODE;
                                IF Location.Get(LocationCode) then begin
                                    BinCode := '-';
                                    if Location."Bin Mandatory" = true Then begin
                                        repeat
                                            WarehouseEntry.Reset();
                                            WarehouseEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Zone Code", "Bin Code");
                                            WarehouseEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                            WarehouseEntry.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                            WarehouseEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                            WarehouseEntry.SetRange("RV_SITE Dim. Code", SITECODE);
                                            WarehouseEntry1.CopyFilters(WarehouseEntry);
                                            if WarehouseEntry.FindSet() then
                                                repeat
                                                    IF BinCode <> WarehouseEntry."Bin Code" then begin
                                                        BinCode := WarehouseEntry."Bin Code";
                                                        //Bin.Get(WarehouseEntry."Bin Code");
                                                        //WarehouseEntry1.Reset();
                                                        //WarehouseEntry1.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Zone Code", "Bin Code");
                                                        //WarehouseEntry1.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                                        //WarehouseEntry1.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                                        //WarehouseEntry1.SetRange("Lot No.", ItemLedgerEntry."Lot No.");                                                        
                                                        WarehouseEntry1.SetRange("Bin Code", BinCode);
                                                        WarehouseEntry1.CalcSums("Qty. (Base)");
                                                        InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1, SITECODE);
                                                    end;
                                                until WarehouseEntry.Next() = 0;
                                        until ItemLedgerEntry.Next() = 0;
                                    end else begin
                                        ItemLedgerEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                        ItemLedgerEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                        if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                                            ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                                        end else begin
                                            ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                                        end;
                                        ItemLedgerEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        ItemLedgerEntry2.CalcSums(Quantity);
                                        Clear(WarehouseEntry1);
                                        InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1, SITECODE);
                                    end;
                                end else begin
                                    ItemLedgerEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                    ItemLedgerEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                    if gLsetup."Global Dimension 1 Code" = RIKEVITASetup."SITE Dim. Code" then begin
                                        ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 1 Code");
                                    end else begin
                                        ItemLedgerEntry2.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Global Dimension 2 Code");
                                    end;
                                    ItemLedgerEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                    ItemLedgerEntry2.CalcSums(Quantity);
                                    Clear(WarehouseEntry1);
                                    InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1, SITECODE);
                                end;
                            end;
                        until ItemLedgerEntry.next = 0;
                    end;
                end;
            }

        }
    }
    procedure InsertInvyAvailableLine(ILE: Record "Item Ledger Entry"; WE: Record "Warehouse Entry"; SITECODE: Code[20])
    var
        Item: Record Item;
        LotInfo: Record "Lot No. Information";
        ItemCategory: Record "Item Category";
        StandardCostElent: Record "Standard Cost Element Details";
        GLSetup: Record "General Ledger Setup";
        location: Record Location;
        BinMaster: Record Bin;

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
        //RIKEVITASetup."Item Type Dim. Code";
        //AvailableInvyLine."Item Type"

        //Inventory Information
        AvailableInvyLine.Site := SITECODE;
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
            //AvailableInvyLine."Sub Lot No." := 
            AvailableInvyLine."Mfg. Date" := LotInfo."RV_Manufacture Date";
        end;
        if we."Bin Code" <> '' then
            AvailableInvyLine."Base Unit Invy. Qty." := WE."Qty. (Base)"
        else
            AvailableInvyLine."Base Unit Invy. Qty." := ILE.Quantity;
        //AvailableInvyLine."KG Unit Invy. Qty."
        AvailableInvyLine."Expiration Date" := ILE."Expiration Date";

        //Inventory Quantity and Amount Information
        StandardCostElent.Reset();
        StandardCostElent.SetRange("Item No.", ILE."Item No.");
        //StandardCostElent.SetRange("Period Code");
        If StandardCostElent.FindFirst() then begin

            AvailableInvyLine."Direct Dep. Exp." := StandardCostElent."Direct Dep. Exp.";
            AvailableInvyLine."Direct Dep. Exp. Amt." := Round(AvailableInvyLine."Direct Labor Cost" * AvailableInvyLine."Base Unit Invy. Qty.",
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

            //AvailableInvyLine."Unit Cost 1"
            //AvailableInvyLine."Cost Amount 1"

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
        EntryNo: Integer;
}
