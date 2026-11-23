/// <summary>
/// Codeunit RV WS Item Reclass. Jnl. Mgt. (ID 50904)
/// FDD102 2026/11/12: New. (Shawn)
/// </summary>
codeunit 50904 "RV WS Item Reclass. Jnl. Mgt."
{
    Permissions = tabledata "Warehouse Entry" = m;

    var
        Cons_Location: Code[10];

    procedure CreateFromWarehouseShipment(
        WhseShptHeader: Record "Warehouse Shipment Header")
    var
        RVSetup: Record "RV RIKEVITA Setup";
        WhseShptLine: Record "Warehouse Shipment Line";
        ReservationEntry: Record "Reservation Entry";
        TempLotBuffer: Record "Reservation Entry" temporary;
        TempWarehouseEntry: Record "Warehouse Entry" temporary;
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        DimensionManagement: Codeunit DimensionManagement;
        RVIntMgt: Codeunit "RV WS Item Reclass. Inv. Mgt.";
        Item: Record Item;
        MissingLines: Text[2048];
        BatchName: Code[10];
        LotNo: Code[50];
        NextEntryNo: Integer;
        LineNo: Integer;
        MaxQty: Decimal;
        DestinationBin: Code[20];
        DimensionSetID: Integer;
        GlobalDim1Code: Code[20];
        GlobalDim2Code: Code[20];
        HasReservation: Boolean;
        HasBlankLot: Boolean;
    begin
        Cons_Location := 'SUPPLY';

        RVSetup.Get();
        RVSetup.TestField("Reason Code for Shipping");

        SourceCodeSetup.Get();

        WhseShptHeader.TestField("No.");
        WhseShptHeader.TestField("Posting Date");

        WhseShptLine.Reset();
        WhseShptLine.SetRange("No.", WhseShptHeader."No.");
        WhseShptLine.SetFilter("Item No.", '<>%1', '');

        if not WhseShptLine.FindSet() then
            Error('No Warehouse Shipment Lines were found.');

        // Check Lot No. assignment

        repeat
            HasReservation := false;
            HasBlankLot := false;

            ReservationEntry.Reset();
            ReservationEntry.SetSourceFilter(
                WhseShptLine."Source Type",
                WhseShptLine."Source Subtype",
                WhseShptLine."Source No.",
                WhseShptLine."Source Line No.",
                true);

            if ReservationEntry.FindSet() then
                repeat
                    HasReservation := true;

                    if ReservationEntry."Lot No." = '' then
                        HasBlankLot := true
                    else begin
                        LotNo := ReservationEntry."Lot No.";

                        // Collect unique Item No. / Lot No.
                        TempLotBuffer.Reset();
                        TempLotBuffer.SetRange("Item No.", WhseShptLine."Item No.");
                        TempLotBuffer.SetRange("Lot No.", LotNo);

                        if not TempLotBuffer.FindFirst() then begin
                            NextEntryNo += 1;

                            TempLotBuffer.Init();
                            TempLotBuffer."Entry No." := NextEntryNo;
                            TempLotBuffer."Item No." := WhseShptLine."Item No.";
                            TempLotBuffer."Lot No." := LotNo;
                            TempLotBuffer."Qty. to Handle (Base)" := ReservationEntry."Qty. to Handle (Base)" * -1;
                            TempLotBuffer.Insert();
                        end else begin
                            TempLotBuffer."Qty. to Handle (Base)" += ReservationEntry."Qty. to Handle (Base)" * -1;
                            TempLotBuffer.Modify();
                        end;
                    end;
                until ReservationEntry.Next() = 0;

            if (not HasReservation) or HasBlankLot then
                MissingLines +=
                    StrSubstNo(
                        ' Order No.: %1 / Line No.: %2 / Item No.: %3;\',
                        WhseShptLine."Source No.",
                        WhseShptLine."Source Line No.",
                        WhseShptLine."Item No.");

        until WhseShptLine.Next() = 0;

        // if a Lot No. is missing.
        if MissingLines <> '' then
            Error('Lot No. is missing on the following lines:\%1', MissingLines);

        // Get Journal Batch
        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Transfer);

        if not ItemJournalTemplate.FindFirst() then
            Error('Item Reclassification Journal Template was not found.');

        BatchName := WhseShptHeader."No.";

        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        ItemJournalBatch.SetRange(Name, BatchName);

        if not ItemJournalBatch.FindFirst() then begin

            ItemJournalBatch.Init();
            ItemJournalBatch."Journal Template Name" := ItemJournalTemplate.Name;
            ItemJournalBatch.SetupNewBatch();
            ItemJournalBatch.Name := BatchName;
            ItemJournalBatch."Reason Code" := RVSetup."Reason Code for Shipping";
            ItemJournalBatch.Insert(true);

        end;

        // Create Journal Lines

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        ItemJournalLine.SetRange("Journal Batch Name", BatchName);
        if not ItemJournalLine.IsEmpty() then begin
            Error('The Item Reclassification Batch %1 is not empty!', BatchName);
        end;

        TempLotBuffer.Reset();
        TempLotBuffer.SetFilter("Qty. to Handle (Base)", '>%1', 0);

        if TempLotBuffer.FindSet() then
            repeat
                // Get stock quantity by Bin.
                RVIntMgt.GetBinQtyBuffer(
                    WhseShptHeader,
                    TempLotBuffer."Qty. to Handle (Base)",
                    TempLotBuffer."Item No.",
                    TempLotBuffer."Lot No.",
                    TempWarehouseEntry);

                // Find the destination Bin with maximum quantity.
                MaxQty := 0;
                DestinationBin := '';

                TempWarehouseEntry.Reset();

                if TempWarehouseEntry.FindSet() then
                    repeat
                        if TempWarehouseEntry."Qty. (Base)" > MaxQty then begin
                            MaxQty := TempWarehouseEntry."Qty. (Base)";
                            DestinationBin := TempWarehouseEntry."Bin Code";
                        end;
                    until TempWarehouseEntry.Next() = 0;

                if DestinationBin = '' then
                    continue;

                // Get Dimension Set ID from latest Item Ledger Entry.
                DimensionSetID :=
                    RVIntMgt.GetDimensionSetID(
                        TempLotBuffer."Item No.",
                        TempLotBuffer."Lot No.");

                DimensionManagement.UpdateGlobalDimFromDimSetID(
                    DimensionSetID,
                    GlobalDim1Code,
                    GlobalDim2Code);

                // Get Item Base UOM.
                Item.Get(TempLotBuffer."Item No.");

                // Create one Journal Line for each source Bin.
                TempWarehouseEntry.Reset();

                if TempWarehouseEntry.FindSet() then
                    repeat

                        LineNo += 10000;

                        ItemJournalLine.Init();

                        ItemJournalLine."Journal Template Name" := ItemJournalTemplate.Name;
                        ItemJournalLine."Journal Batch Name" := BatchName;
                        ItemJournalLine."Line No." := LineNo;

                        ItemJournalLine.Validate("Source Code", SourceCodeSetup."Item Reclass. Journal");
                        ItemJournalLine.Validate("Posting Date", WhseShptHeader."Posting Date");
                        ItemJournalLine.Validate("Document No.", WhseShptHeader."No.");
                        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
                        ItemJournalLine.Validate("Item No.", TempLotBuffer."Item No.");
                        ItemJournalLine.Validate("Location Code", Cons_Location);
                        ItemJournalLine.Validate("Bin Code", TempWarehouseEntry."Bin Code");
                        ItemJournalLine.Validate("New Location Code", Cons_Location);
                        ItemJournalLine.Validate("New Bin Code", DestinationBin);
                        ItemJournalLine.Validate("Unit of Measure Code", Item."Base Unit of Measure");
                        ItemJournalLine.Validate(Quantity, TempWarehouseEntry."Qty. (Base)");
                        ItemJournalLine.Validate("Reason Code", ItemJournalBatch."Reason Code");

                        // Original and new Lot No.
                        ItemJournalLine."Lot No." := TempLotBuffer."Lot No.";
                        ItemJournalLine."New Lot No." := TempLotBuffer."Lot No.";


                        // Original Dimension.
                        ItemJournalLine."Dimension Set ID" := DimensionSetID;

                        ItemJournalLine."Shortcut Dimension 1 Code" := GlobalDim1Code;
                        ItemJournalLine."Shortcut Dimension 2 Code" := GlobalDim2Code;

                        // New Dimension.
                        ItemJournalLine."New Dimension Set ID" := DimensionSetID;

                        ItemJournalLine."New Shortcut Dimension 1 Code" := GlobalDim1Code;
                        ItemJournalLine."New Shortcut Dimension 2 Code" := GlobalDim2Code;

                        ItemJournalLine.Insert(true);

                        // Create standard Item Tracking entries.
                        ItemJnlLineReserve.CreateItemTracking(ItemJournalLine);

                        ReservationEntry.SetRange("Source Type", Database::"Item Journal Line");
                        ReservationEntry.SetRange("Source Subtype", ItemJournalLine."Entry Type".AsInteger());
                        ReservationEntry.SetRange("Source ID", ItemJournalLine."Journal Template Name");
                        ReservationEntry.SetRange("Source Batch Name", ItemJournalLine."Journal Batch Name");
                        ReservationEntry.SetRange("Source Ref. No.", ItemJournalLine."Line No.");
                        ReservationEntry.SetRange("Lot No.", ItemJournalLine."Lot No.");

                        if ReservationEntry.FindSet() then
                            repeat
                                ReservationEntry.Validate("New Lot No.", TempLotBuffer."Lot No.");
                                ReservationEntry.Validate("New Expiration Date", TempWarehouseEntry."Expiration Date");
                                ReservationEntry.Modify(true);
                            until ReservationEntry.Next() = 0;


                        // Original and new Lot No.
                        ItemJournalLine."Lot No." := '';
                        ItemJournalLine."New Lot No." := '';
                        ItemJournalLine.Modify();

                    until TempWarehouseEntry.Next() = 0;

            until TempLotBuffer.Next() = 0;

        Message(
            'Item Reclassification Journal created successfully.\' +
            'Template: %1\' +
            'Batch: %2\',
            ItemJournalTemplate.Name,
            BatchName);
    end;

    procedure OpenFromWarehouseShipment(
        WhseShptHeader: Record "Warehouse Shipment Header")
    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemReclassJournal: Page "Item Reclass. Journal";
        ItemJnlManagement: Codeunit ItemJnlManagement;
        BatchName: Code[10];

    begin
        BatchName := WhseShptHeader."No.";

        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Transfer);

        if not ItemJournalTemplate.FindFirst() then
            Error('Item Reclassification Journal Template was not found.');

        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        ItemJournalBatch.SetRange("Name", BatchName);
        if not ItemJournalBatch.FindFirst() then
            Error('Item Reclassification Journal Batch was not found.');

        ItemJournalLine.FilterGroup(2);
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        ItemJournalLine.FilterGroup(0);
        ItemJournalLine.SetRange("Journal Batch Name", BatchName);

        ItemJournalLine."Journal Template Name" := ItemJournalTemplate.Name;
        ItemJournalLine."Journal Batch Name" := BatchName;

        Page.Run(Page::"Item Reclass. Journal", ItemJournalLine);
    end;
}
