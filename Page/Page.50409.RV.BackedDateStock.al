page 50409 "RV BackedDate Stock"
{
    ApplicationArea = All;
    Caption = 'Inventory Monitoring';
    PageType = Card;
    //UsageCategory = tasks;
    SourceTable = "RV Invy. Available Name";
    Permissions = tabledata "Warehouse Entry" = m;


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
                    Location: Record Location;
                    ItemNo: Code[20];
                    LocationCode: Code[10];
                    LotNo: Code[50];
                    SITECODE: Code[20];
                    OwnerCode: Code[20];
                    ProcessedInventoryGroups: Dictionary of [Text, Boolean];
                    ProcessedBinGroups: Dictionary of [Text, Boolean];
                    GroupKey: Text;
                    BinGroupKey: Text;
                    //Bin: Record Bin;
                    BinCode: Code[20];
                begin
                    Rec.TestField("Inventory Valuation Date");
                    GlobalRIKEVITASetup.Get();
                    //Inventory Quantity and Amount Information
                    StandardCostPeriod.reset;
                    StandardCostPeriod.Setfilter("Effective Start Date", '<=%1', Rec."Inventory Valuation Date");
                    StandardCostPeriod.Setfilter("Effective End Date", '>=%1', Rec."Inventory Valuation Date");
                    IF NOT StandardCostPeriod.FindLast() then begin
                        if NOT Dialog.Confirm('No found effective standart cost with the valuation date, Do you continute ?') then
                            Error('');
                        StandardCostPeriod.Init();
                    end;

                    UpdateSITECODE;//update the SITE Dim. Code in Warehouse Entry table
                    AvailableInvyLine.Reset();
                    AvailableInvyLine.SetRange("Available Invy. Name", Rec.Name);
                    AvailableInvyLine.DeleteAll();
                    AvailableInvyLine."Available Invy. Name" := Rec.Name;
                    EntryNo := 1;
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Posting Date", 0D, Rec."Inventory Valuation Date");
                    if Rec."Item Filter" <> '' then
                        ItemLedgerEntry.SetFilter("Item No.", Rec."Item Filter");
                    ValidateConfiguredDimensions();

                    if ItemLedgerEntry.FindSet() then begin
                        repeat
                            GroupKey := StrSubstNo('%1:%2%3:%4%5:%6%7:%8',
                                StrLen(ItemLedgerEntry."Item No."), ItemLedgerEntry."Item No.",
                                StrLen(ItemLedgerEntry."Location Code"), ItemLedgerEntry."Location Code",
                                StrLen(ItemLedgerEntry."Lot No."), ItemLedgerEntry."Lot No.",
                                StrLen(ItemLedgerEntry."Variant Code"), ItemLedgerEntry."Variant Code");
                            if not ProcessedInventoryGroups.ContainsKey(GroupKey) then begin
                                ProcessedInventoryGroups.Add(GroupKey, true);
                                ItemNo := ItemLedgerEntry."Item No.";
                                LocationCode := ItemLedgerEntry."Location Code";
                                LotNo := ItemLedgerEntry."Lot No.";
                                IF Location.Get(LocationCode) then begin
                                    if Location."Bin Mandatory" = true Then begin
                                        WarehouseEntry.Reset();
                                        WarehouseEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        WarehouseEntry.SetRange("Location Code", ItemLedgerEntry."Location Code");
                                        WarehouseEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                        WarehouseEntry.SetRange("Variant Code", ItemLedgerEntry."Variant Code");
                                        WarehouseEntry.SetRange("Registering Date", 0D, Rec."Inventory Valuation Date");
                                        if WarehouseEntry.FindSet() then begin
                                            repeat
                                                BinCode := WarehouseEntry."Bin Code";
                                                SITECODE := WarehouseEntry."RV_Inventory Owner Code";
                                                OwnerCode := WarehouseEntry."RV Owner Code";
                                                BinGroupKey := StrSubstNo('%1|%2:%3%4:%5%6:%7',
                                                    GroupKey,
                                                    StrLen(BinCode), BinCode,
                                                    StrLen(SITECODE), SITECODE,
                                                    StrLen(OwnerCode), OwnerCode);
                                                if not ProcessedBinGroups.ContainsKey(BinGroupKey) then begin
                                                    ProcessedBinGroups.Add(BinGroupKey, true);
                                                    WarehouseEntry1.Reset();
                                                    WarehouseEntry1.CopyFilters(WarehouseEntry);
                                                    WarehouseEntry1.SetRange("Bin Code", BinCode);
                                                    WarehouseEntry1.SetRange("RV_Inventory Owner Code", SITECODE);
                                                    WarehouseEntry1.SetRange("RV Owner Code", OwnerCode);
                                                    WarehouseEntry1.CalcSums("Qty. (Base)");
                                                    WarehouseEntry1."Bin Code" := BinCode;
                                                    if WarehouseEntry1."Qty. (Base)" <> 0 then
                                                        InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1, SITECODE, OwnerCode);
                                                end;
                                            until WarehouseEntry.Next() = 0;
                                        end;
                                    end else begin
                                        CollectNonBinInventory(ItemLedgerEntry);
                                    end;
                                end else begin
                                    CollectNonBinInventory(ItemLedgerEntry);
                                end;
                            end;
                        until ItemLedgerEntry.next = 0;
                    end;
                end;
            }
        }
    }
    procedure InsertInvyAvailableLine(ILE: Record "Item Ledger Entry"; WE: Record "Warehouse Entry"; SiteCode: Code[20]; OwnerCode: Code[20])
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
        GLSetup.Get();
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
        DefaultDim.SetRange("Dimension Code", GlobalRIKEVITASetup."Item Type Dim. Code");
        if DefaultDim.FindFirst() then
            AvailableInvyLine."Item Type" := DefaultDim."Dimension Value Code";
        DefaultDim.SetRange("Dimension Code", GlobalRIKEVITASetup."Segment Dim. Code");
        if DefaultDim.FindFirst() then
            AvailableInvyLine.Segment := DefaultDim."Dimension Value Code";

        //Inventory Information
        AvailableInvyLine.Site := SiteCode;
        AvailableInvyLine."Owner Code" := OwnerCode;
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
            //AvailableInvyLine."Sub Lot No." := LotInfo."RV_Sub Lot No.";
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

    local procedure UpdateSITECODE()
    var
        WarehouseEntry: Record "Warehouse Entry";
        WarehouseEntry1: Record "Warehouse Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        LastProcessedEntryNo: Integer;
        AllEntriesResolved: Boolean;
        SiteCode: Code[20];
        OwnerCode: Code[20];
        FoundItemLedgerEntry: Boolean;
    begin
        GlobalRIKEVITASetup.Get();
        ValidateConfiguredDimensions();

        AllEntriesResolved := true;
        WarehouseEntry.SetFilter("Entry No.", '>%1', GlobalRIKEVITASetup."Updated Warehouse Entry No.");
        if WarehouseEntry.FindSet(true) then begin
            repeat
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Document No.", WarehouseEntry."Whse. Document No.");
                ItemLedgerEntry.SetRange("Item No.", WarehouseEntry."Item No.");
                ItemLedgerEntry.SetRange("Location Code", WarehouseEntry."Location Code");
                ItemLedgerEntry.SetRange("Variant Code", WarehouseEntry."Variant Code");
                ItemLedgerEntry.SetRange("Lot No.", WarehouseEntry."Lot No.");
                SiteCode := '';
                OwnerCode := '';
                FoundItemLedgerEntry := false;
                if ItemLedgerEntry.FindSet() then
                    repeat
                        SiteCode := GetDimensionValue(ItemLedgerEntry, GlobalRIKEVITASetup."SITE Dim. Code");
                        OwnerCode := GetDimensionValue(ItemLedgerEntry, GlobalRIKEVITASetup."Owner Dim. Code");
                        FoundItemLedgerEntry := (SiteCode <> '') and (OwnerCode <> '');
                    until (ItemLedgerEntry.Next() = 0) or FoundItemLedgerEntry;
                if not FoundItemLedgerEntry then begin
                    WarehouseEntry1.reset;
                    WarehouseEntry1.setRange("Lot No.", WarehouseEntry."Lot No.");
                    warehouseEntry1.setRange("Item No.", WarehouseEntry."Item No.");
                    warehouseEntry1.setRange("Location Code", WarehouseEntry."Location Code");
                    warehouseEntry1.SetRange("Variant Code", WarehouseEntry."Variant Code");
                    warehouseEntry1.SetFilter("Entry No.", '<%1', WarehouseEntry."Entry No.");
                    warehouseEntry1.SetFilter("RV_Inventory Owner Code", '<>%1', '');
                    warehouseEntry1.SetFilter("RV Owner Code", '<>%1', '');
                    if WarehouseEntry1.FindLast() then begin
                        SiteCode := WarehouseEntry1."RV_Inventory Owner Code";
                        OwnerCode := WarehouseEntry1."RV Owner Code";
                    end;
                end;

                if (SiteCode <> '') and (OwnerCode <> '') then begin
                    WarehouseEntry.Validate("RV_Inventory Owner Code", SiteCode);
                    WarehouseEntry.Validate("RV Owner Code", OwnerCode);
                    if (WarehouseEntry."RV_Inventory Owner Code" <> SiteCode) or
                       (WarehouseEntry."RV Owner Code" <> OwnerCode)
                    then
                        WarehouseEntry.Modify(true);
                end else
                    AllEntriesResolved := false;
                LastProcessedEntryNo := WarehouseEntry."Entry No.";
            until WarehouseEntry.Next() = 0;

            GlobalRIKEVITASetup."Updated Warehouse Entry No." := LastProcessedEntryNo;
            GlobalRIKEVITASetup.Modify(true);
            COMMIT;
        end;
    end;

    local procedure ValidateConfiguredDimensions()
    begin
        GlobalRIKEVITASetup.TestField("SITE Dim. Code");
        GlobalRIKEVITASetup.TestField("Owner Dim. Code");
        GlobalGLSetup.Get();
        if (GlobalRIKEVITASetup."SITE Dim. Code" <> GlobalGLSetup."Global Dimension 1 Code") and
           (GlobalRIKEVITASetup."SITE Dim. Code" <> GlobalGLSetup."Global Dimension 2 Code")
        then
            Error('SITE Dimension Code must be configured as Global Dimension 1 or Global Dimension 2.');
        if (GlobalRIKEVITASetup."Owner Dim. Code" <> GlobalGLSetup."Global Dimension 1 Code") and
           (GlobalRIKEVITASetup."Owner Dim. Code" <> GlobalGLSetup."Global Dimension 2 Code")
        then
            Error('Owner Dimension Code must be configured as Global Dimension 1 or Global Dimension 2.');
        if GlobalRIKEVITASetup."Owner Dim. Code" = GlobalRIKEVITASetup."SITE Dim. Code" then
            Error('Owner Dimension Code and SITE Dimension Code must be different.');
    end;

    local procedure GetDimensionValue(ILE: Record "Item Ledger Entry"; DimensionCode: Code[20]): Code[20]
    begin
        if DimensionCode = GlobalGLSetup."Global Dimension 1 Code" then
            exit(ILE."Global Dimension 1 Code");
        if DimensionCode = GlobalGLSetup."Global Dimension 2 Code" then
            exit(ILE."Global Dimension 2 Code");
        Error('Dimension %1 is not configured as a global dimension.', DimensionCode);
    end;

    local procedure CollectNonBinInventory(ILE: Record "Item Ledger Entry")
    var
        ItemLedgerEntry2: Record "Item Ledger Entry";
        ItemLedgerEntry3: Record "Item Ledger Entry";
        WarehouseEntry: Record "Warehouse Entry";
        SiteCode: Code[20];
        OwnerCode: Code[20];
        AggregatedQuantity: Decimal;
        ProcessedDimensionPairs: Dictionary of [Text, Boolean];
        DimensionPairKey: Text;
    begin
        ItemLedgerEntry2.CopyFilters(ILE);
        ItemLedgerEntry2.SetRange("Item No.", ILE."Item No.");
        ItemLedgerEntry2.SetRange("Location Code", ILE."Location Code");
        ItemLedgerEntry2.SetRange("Lot No.", ILE."Lot No.");
        ItemLedgerEntry2.SetRange("Variant Code", ILE."Variant Code");
        if ItemLedgerEntry2.FindSet() then begin
            repeat
                SiteCode := GetDimensionValue(ItemLedgerEntry2, GlobalRIKEVITASetup."SITE Dim. Code");
                OwnerCode := GetDimensionValue(ItemLedgerEntry2, GlobalRIKEVITASetup."Owner Dim. Code");
                DimensionPairKey := StrSubstNo('%1:%2%3:%4',
                    StrLen(SiteCode), SiteCode, StrLen(OwnerCode), OwnerCode);
                if not ProcessedDimensionPairs.ContainsKey(DimensionPairKey) then begin
                    ProcessedDimensionPairs.Add(DimensionPairKey, true);
                    ItemLedgerEntry3.Reset();
                    ItemLedgerEntry3.CopyFilters(ILE);
                    ItemLedgerEntry3.SetRange("Item No.", ILE."Item No.");
                    ItemLedgerEntry3.SetRange("Location Code", ILE."Location Code");
                    ItemLedgerEntry3.SetRange("Lot No.", ILE."Lot No.");
                    ItemLedgerEntry3.SetRange("Variant Code", ILE."Variant Code");
                    if GlobalRIKEVITASetup."SITE Dim. Code" = GlobalGLSetup."Global Dimension 1 Code" then
                        ItemLedgerEntry3.SetRange("Global Dimension 1 Code", SiteCode)
                    else
                        ItemLedgerEntry3.SetRange("Global Dimension 2 Code", SiteCode);
                    if GlobalRIKEVITASetup."Owner Dim. Code" = GlobalGLSetup."Global Dimension 1 Code" then
                        ItemLedgerEntry3.SetRange("Global Dimension 1 Code", OwnerCode)
                    else
                        ItemLedgerEntry3.SetRange("Global Dimension 2 Code", OwnerCode);
                    ItemLedgerEntry3.CalcSums(Quantity);
                    AggregatedQuantity := ItemLedgerEntry3.Quantity;
                    if (AggregatedQuantity <> 0) and ItemLedgerEntry3.FindFirst() then begin
                        ItemLedgerEntry3.Quantity := AggregatedQuantity;
                        Clear(WarehouseEntry);
                        InsertInvyAvailableLine(ItemLedgerEntry3, WarehouseEntry, SiteCode, OwnerCode);
                    end;
                end;
            until ItemLedgerEntry2.Next() = 0;
        end;
    end;


    var
        AvailableInvyLine: record "RV.Available Invy. Line";
        GlobalRIKEVITASetup: Record "RV RIKEVITA Setup";
        StandardCostElent: Record "Standard Cost Element Details";
        StandardCostPeriod: Record "Standard Cost Element Period";
        GlobalGLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
}