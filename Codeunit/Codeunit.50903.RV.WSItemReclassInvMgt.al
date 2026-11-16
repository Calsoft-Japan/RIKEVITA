/// <summary>
/// Codeunit RV WS Item Reclass. Inv. Mgt. (ID 50903)
/// FDD102 2026/11/13: New. (Shawn)
/// </summary>
codeunit 50903 "RV WS Item Reclass. Inv. Mgt."
{
    Permissions = tabledata "Warehouse Entry" = m;

    var
        RVInvAvaName: Record "RV Invy. Available Name" temporary;
        AvailableInvyLine: record "RV.Available Invy. Line" temporary;
        GlobalRIKEVITASetup: Record "RV RIKEVITA Setup";
        StandardCostElent: Record "Standard Cost Element Details";
        StandardCostPeriod: Record "Standard Cost Element Period";
        GlobalGLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
        Cons_Location: Code[10];
        Cons_RVInvAvaName_Name: Code[10];


    procedure GetBinQtyBuffer(
        WhseShptHeader: Record "Warehouse Shipment Header";
        QtyShipto: Decimal;
        ItemNo: Code[20];
        LotNo: Code[50];
        var TempWarehouseEntry: Record "Warehouse Entry" temporary)
    var
        NextEntryNo: Integer;
        QtyApplied: Decimal;
        QtyApply: Decimal;
    begin

        Cons_Location := 'SUPPLY';
        Cons_RVInvAvaName_Name := 'FOR_FDD102';

        RVInvAvaName.DeleteAll();

        RVInvAvaName.Name := Cons_RVInvAvaName_Name;
        RVInvAvaName."Inventory Valuation Date" := WhseShptHeader."Posting Date";
        RVInvAvaName."Location Filter" := Cons_Location;
        RVInvAvaName."Item Filter" := ItemNo;
        RVInvAvaName.Insert();
        CollectInvtData(); // This refers page 50409 "RV Inventory Monitoring".

        // Calculate Qty by Item, Lot, Bin
        TempWarehouseEntry.Reset();
        TempWarehouseEntry.DeleteAll();

        AvailableInvyLine.Reset();
        AvailableInvyLine.SetCurrentKey("Expiration Date", "Bin Code");
        AvailableInvyLine.SetRange("Item No.", ItemNo);
        AvailableInvyLine.SetRange(Location, Cons_Location);
        AvailableInvyLine.SetRange("Lot No.", LotNo);
        if AvailableInvyLine.FindSet() then
            repeat

                if (QtyApplied + AvailableInvyLine."Base Unit Invy. Qty.") <= QtyShipto then begin
                    QtyApply := AvailableInvyLine."Base Unit Invy. Qty.";
                end else begin
                    QtyApply := QtyShipto - QtyApplied;
                end;
                QtyApplied += QtyApply;

                TempWarehouseEntry.Reset();
                NextEntryNo += 1;

                TempWarehouseEntry.Init();
                TempWarehouseEntry."Entry No." := NextEntryNo;
                TempWarehouseEntry."Item No." := ItemNo;
                TempWarehouseEntry."Location Code" := Cons_Location;
                TempWarehouseEntry."Lot No." := LotNo;
                TempWarehouseEntry."Qty. (Base)" := QtyApply;
                TempWarehouseEntry."Bin Code" := AvailableInvyLine."Bin Code";
                TempWarehouseEntry."Expiration Date" := AvailableInvyLine."Expiration Date";
                TempWarehouseEntry.Insert();

            until AvailableInvyLine.Next() = 0;

    end;

    procedure CollectInvtData()
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
        VariantCode: Code[10];
        SITECODE: Code[20];
        OwnerCode: Code[20];
        ProcessedInventoryGroups: Dictionary of [Text, Boolean];
        ProcessedBinGroups: Dictionary of [Text, Boolean];
        GroupKey: Text;
        BinGroupKey: Text;
        //Bin: Record Bin;
        BinCode: Code[20];
    begin
        RVInvAvaName.TestField("Inventory Valuation Date");
        GlobalRIKEVITASetup.Get();
        //Inventory Quantity and Amount Information
        StandardCostPeriod.reset;
        StandardCostPeriod.Setfilter("Effective Start Date", '<=%1', RVInvAvaName."Inventory Valuation Date");
        StandardCostPeriod.Setfilter("Effective End Date", '>=%1', RVInvAvaName."Inventory Valuation Date");
        IF NOT StandardCostPeriod.FindLast() then begin
            //if NOT Dialog.Confirm('No found effective standart cost with the valuation date, Do you continute ?') then
            //    Error('');
            StandardCostPeriod.Init();
        end;

        UpdateSITECODE;//update the SITE Dim. Code in Warehouse Entry table
        AvailableInvyLine.Reset();
        AvailableInvyLine.SetRange("Available Invy. Name", RVInvAvaName.Name);
        AvailableInvyLine.DeleteAll();
        AvailableInvyLine."Available Invy. Name" := RVInvAvaName.Name;
        EntryNo := 1;
        ValidateConfiguredDimensions();
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Posting Date", 0D, RVInvAvaName."Inventory Valuation Date");
        if RVInvAvaName."Location Filter" <> '' then
            ItemLedgerEntry.SetFilter("Location Code", RVInvAvaName."Location Filter");
        if RVInvAvaName."Shortcut Dimension 1 Code" <> '' then begin
            ItemLedgerEntry.SetFilter("Global Dimension 1 Code", RVInvAvaName."Shortcut Dimension 1 Code");
        end;
        if RVInvAvaName."Shortcut Dimension 2 Code" <> '' then begin
            ItemLedgerEntry.SetFilter("Global Dimension 2 Code", RVInvAvaName."Shortcut Dimension 2 Code");
        end;
        if RVInvAvaName."Item Filter" <> '' then
            ItemLedgerEntry.SetFilter("Item No.", RVInvAvaName."Item Filter");
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
                    VariantCode := ItemLedgerEntry."Variant Code";
                    IF Location.Get(LocationCode) then begin
                        if Location."Bin Mandatory" = true Then begin
                            WarehouseEntry.Reset();
                            WarehouseEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                            WarehouseEntry.SetRange("Location Code", ItemLedgerEntry."Location Code");
                            WarehouseEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                            WarehouseEntry.SetRange("Variant Code", ItemLedgerEntry."Variant Code");
                            WarehouseEntry.SetRange("Registering Date", 0D, RVInvAvaName."Inventory Valuation Date");
                            if RVInvAvaName."Shortcut Dimension 1 Code" <> '' then begin
                                //if GlobalRIKEVITASetup."SITE Dim. Code" = GlobalGLSetup."Global Dimension 1 Code" then
                                WarehouseEntry.SetRange(WarehouseEntry."RV_Dimension 1 Code", RVInvAvaName."Shortcut Dimension 1 Code")
                                //else
                                //    WarehouseEntry.SetRange(WarehouseEntry."RV Owner Code", RVInvAvaName."Shortcut Dimension 1 Code");
                            end;
                            if RVInvAvaName."Shortcut Dimension 2 Code" <> '' then begin
                                //if GlobalRIKEVITASetup."SITE Dim. Code" = GlobalGLSetup."Global Dimension 2 Code" then
                                WarehouseEntry.SetRange(WarehouseEntry."RV_Dimension 2 Code", RVInvAvaName."Shortcut Dimension 2 Code")
                                //else
                                //    WarehouseEntry.SetRange(WarehouseEntry."RV Owner Code", RVInvAvaName."Shortcut Dimension 2 Code");
                                //WarehouseEntry.SetFilter("RV Owner Code", RVInvAvaName."Shortcut Dimension 2 Code");
                            end;
                            if WarehouseEntry.FindSet() then begin
                                repeat
                                    BinCode := WarehouseEntry."Bin Code";
                                    SITECODE := WarehouseEntry."RV_Dimension 1 Code";
                                    OwnerCode := WarehouseEntry."RV_Dimension 2 Code";
                                    BinGroupKey := StrSubstNo('%1|%2:%3%4:%5%6:%7|%8:%9%10:%11%12:%13',
                                        GroupKey,
                                        StrLen(BinCode), BinCode,
                                        StrLen(SITECODE), SITECODE,
                                        StrLen(OwnerCode), OwnerCode,
                                        StrLen(WarehouseEntry."Item No."), WarehouseEntry."Item No.",
                                        StrLen(WarehouseEntry."Location Code"), WarehouseEntry."Location Code",
                                        StrLen(WarehouseEntry."Lot No."), WarehouseEntry."Lot No.");
                                    if not ProcessedBinGroups.ContainsKey(BinGroupKey) then begin
                                        ProcessedBinGroups.Add(BinGroupKey, true);
                                        WarehouseEntry1.Reset();
                                        WarehouseEntry1.CopyFilters(WarehouseEntry);
                                        WarehouseEntry1.SetRange("Bin Code", BinCode);
                                        WarehouseEntry1.SetRange("RV_Dimension 1 Code", SITECODE);
                                        WarehouseEntry1.SetRange("RV_Dimension 2 Code", OwnerCode);
                                        WarehouseEntry1.CalcSums("Qty. (Base)");
                                        WarehouseEntry1."Bin Code" := BinCode;
                                        if WarehouseEntry1."Qty. (Base)" <> 0 then
                                            InsertInvyAvailableLine(ItemLedgerEntry, WarehouseEntry1, SITECODE, OwnerCode);
                                    end;
                                until WarehouseEntry.Next() = 0;
                            end;
                        end else begin
                            //CollectNonBinInventory(ItemLedgerEntry);
                        end;
                    end else begin
                        //CollectNonBinInventory(ItemLedgerEntry);
                    end;
                end;
            until ItemLedgerEntry.next = 0;
        end;
    end;

    procedure InsertInvyAvailableLine(ILE: Record "Item Ledger Entry"; WE: Record "Warehouse Entry"; GDM01: Code[20]; GDM02: Code[20])
    var
        Item: Record Item;
        LotInfo: Record "Lot No. Information";
        ItemCategory: Record "Item Category";
        GLSetup: Record "General Ledger Setup";
        location: Record Location;
        BinMaster: Record Bin;
        ItemUOM: Record "Item Unit of Measure";
        DefaultDim: Record "Default Dimension";
        QCHeader: Record "RV QC Header";
    begin
        GLSetup.Get();
        AvailableInvyLine.Init();
        //Filter infromation
        AvailableInvyLine."Available Invy. Name" := RVInvAvaName.Name;
        AvailableInvyLine."Entry No." := EntryNo;
        EntryNo += 1;
        AvailableInvyLine."Calculating Base Date" := RVInvAvaName."Inventory Valuation Date";
        AvailableInvyLine."Item No." := ILE."Item No.";

        //Item master infromation
        Item.get(ILE."Item No.");
        AvailableInvyLine."Item Description" := item.Description;
        AvailableInvyLine."Item Description 2" := item."Description 2";
        AvailableInvyLine.RSPO := item.RV_RSPO;
        AvailableInvyLine."Base Unit of Measure" := Item."Base Unit of Measure";
        AvailableInvyLine.Allergen := item.Allergen;
        //AvailableInvyLine."Derive Unit of Measure" :=
        AvailableInvyLine."Supp. Unit of Measure" := item."RV_Supp. Unit of Measure Code";
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
        AvailableInvyLine."Shortcut Dimension 1 Code" := GDM01;
        AvailableInvyLine."Shortcut Dimension 2 Code" := GDM02;
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
        QCHeader.Reset();
        QCHeader.SetRange("Item No.", ILE."Item No.");
        QCHeader.SetRange("lot No.", ILE."Lot No.");
        //ItemLedgEntry.SetFilter(Quantity, '>%1', 0);
        if QCHeader.FindFirst() then begin
            AvailableInvyLine."Mfg. Date" := QCHeader."Manufacturing Date";
        end else begin
            If LotInfo.Get(ILE."Item No.", ILE."Variant Code", ILE."Lot No.") then begin
                if LotInfo."RV_Manufacture Date" <> 0D then
                    AvailableInvyLine."Mfg. Date" := LotInfo."RV_Manufacture Date"
                else
                    AvailableInvyLine."Mfg. Date" := ILE."Posting Date";
            end;
        end;
        //for PM material, the manufacturing date is not required, so set it to 0D
        if CopyStr(AvailableInvyLine."Item No.", 1, 2) = 'PM' then
            AvailableInvyLine."Mfg. Date" := 0D;

        if we."Bin Code" <> '' then
            AvailableInvyLine."Base Unit Invy. Qty." := WE."Qty. (Base)"
        else
            AvailableInvyLine."Base Unit Invy. Qty." := ILE.Quantity;
        if ItemUOM.Get(ILE."Item No.", AvailableInvyLine."Supp. Unit of Measure") then begin
            AvailableInvyLine."Supp. Unit Qty." := Round(AvailableInvyLine."Base Unit Invy. Qty." / ItemUOM."Qty. per Unit of Measure", 0.00001);
        end;
        AvailableInvyLine."Expiration Date" := ILE."Expiration Date";
        //Cost Information
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
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
        LastProcessedEntryNo: Integer;
        DimensionValue1: Code[20];
        DimensionValue2: Code[20];
        FoundItemLedgerEntry: Boolean;
    begin
        GlobalRIKEVITASetup.Get();
        ValidateConfiguredDimensions();

        WarehouseEntry.SetFilter("Entry No.", '>%1', GlobalRIKEVITASetup."Updated Warehouse Entry No.");
        if WarehouseEntry.FindSet(true) then begin
            repeat
                DimensionValue1 := '';
                DimensionValue2 := '';
                FoundItemLedgerEntry := false;
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Document No.", warehouseentry."Reference No.");
                ItemLedgerEntry.SetRange("Item No.", WarehouseEntry."Item No.");
                ItemLedgerEntry.SetRange("Location Code", WarehouseEntry."Location Code");
                ItemLedgerEntry.SetRange("Variant Code", WarehouseEntry."Variant Code");
                ItemLedgerEntry.SetRange("Lot No.", WarehouseEntry."Lot No.");
                ItemLedgerEntry.SetRange("Quantity", WarehouseEntry."Qty. (Base)");
                if ItemLedgerEntry.FindSet() then
                    repeat
                        DimensionValue1 := ItemLedgerEntry."Global Dimension 1 Code";
                        DimensionValue2 := ItemLedgerEntry."Global Dimension 2 Code";
                        FoundItemLedgerEntry := true;
                    until (ItemLedgerEntry.Next() = 0) or FoundItemLedgerEntry;
                if not FoundItemLedgerEntry then begin
                    if warehouseentry."Qty. (Base)" > 0 then begin
                        WarehouseEntry1.reset;
                        WarehouseEntry1.SetRange("Reference No.", WarehouseEntry."Reference No.");
                        WarehouseEntry1.setRange("Lot No.", WarehouseEntry."Lot No.");
                        warehouseEntry1.setRange("Item No.", WarehouseEntry."Item No.");
                        warehouseEntry1.setRange("Location Code", WarehouseEntry."Location Code");
                        warehouseEntry1.SetRange("Variant Code", WarehouseEntry."Variant Code");
                        if WarehouseEntry1.FindFirst() then begin
                            DimensionValue1 := WarehouseEntry1."RV_Dimension 1 Code";
                            DimensionValue2 := WarehouseEntry1."RV_Dimension 2 Code";
                            FoundItemLedgerEntry := true;
                        end;
                    end else begin
                        WarehouseEntry1.reset;
                        WarehouseEntry1.setRange("Lot No.", WarehouseEntry."Lot No.");
                        warehouseEntry1.setRange("Item No.", WarehouseEntry."Item No.");
                        warehouseEntry1.setRange("Location Code", WarehouseEntry."Location Code");
                        warehouseEntry1.SetRange("Variant Code", WarehouseEntry."Variant Code");
                        warehouseEntry1.setRange("Bin Code", WarehouseEntry."Bin Code");
                        warehouseEntry1.SetFilter("Entry No.", '<%1', WarehouseEntry."Entry No.");
                        warehouseEntry1.SetFilter("Quantity", '>0');
                        if WarehouseEntry1.FindLast() then begin
                            DimensionValue1 := WarehouseEntry1."RV_Dimension 1 Code";
                            DimensionValue2 := WarehouseEntry1."RV_Dimension 2 Code";
                            FoundItemLedgerEntry := true;
                        end;
                    end;
                end;
                if FoundItemLedgerEntry then begin
                    WarehouseEntry."RV_Dimension 1 Code" := DimensionValue1;
                    WarehouseEntry."RV_Dimension 2 Code" := DimensionValue2;
                    WarehouseEntry.Modify(true);
                end;
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
        GlobalRIKEVITASetup.TestField("Internal Use Dim. Code");
        GlobalGLSetup.Get();
        if (GlobalRIKEVITASetup."SITE Dim. Code" <> GlobalGLSetup."Global Dimension 1 Code") and
           (GlobalRIKEVITASetup."SITE Dim. Code" <> GlobalGLSetup."Global Dimension 2 Code")
        then
            Error('SITE Dimension Code must be configured as Global Dimension 1 or Global Dimension 2.');
        if (GlobalRIKEVITASetup."Internal Use Dim. Code" <> GlobalGLSetup."Global Dimension 1 Code") and
           (GlobalRIKEVITASetup."Internal Use Dim. Code" <> GlobalGLSetup."Global Dimension 2 Code")
        then
            Error('Internal Use Dimension Code must be configured as Global Dimension 1 or Global Dimension 2.');
        if GlobalRIKEVITASetup."Internal Use Dim. Code" = GlobalRIKEVITASetup."SITE Dim. Code" then
            Error('Internal Use Dimension Code and SITE Dimension Code must be different.');
    end;


    procedure GetDimensionSetID(
        ItemNo: Code[20];
        LotNo: Code[50]): Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Entry No.");
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Location Code", Cons_Location);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);

        // Use the Item Ledger Entry with the largest Entry No.
        if ItemLedgerEntry.FindLast() then
            exit(ItemLedgerEntry."Dimension Set ID");

        Error(
            'Item Ledger Entry not found. Item No.: %1, Lot No.: %2',
            ItemNo, LotNo);
    end;

}
