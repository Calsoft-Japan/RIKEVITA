/// <summary>
/// Codeunit RV Post Results Line Process (ID 50603)
/// FDD010 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50603 "RV Post Prod Result Line Proc."
{
    TableNo = 50601;
    trigger OnRun()
    begin
        ProdResultJournalLine.Reset();
        ProdResultJournalLine.CopyFilters(Rec);
        if ProdResultJournalLine.FindSet() then begin
            CreateProdJournal();
        end;
    end;

    var
        ProdResultJournalLine: Record "RV Prod. Result Journal Line";
        ProdResultJournalLineTmp: Record "RV Prod. Result Journal Line" temporary;
        PstProdResJnlLine: Record "RV Pst. Prod. Res. Jnl. Line";
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderComp: Record "Prod. Order Component";
        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        NextLineNo: Integer;
        Text000: Label '%1 journal';
        Text003: Label 'DEFAULT';
        Text004: Label 'Production Journal';

    procedure CreateProdJournal()
    var
        ItemJnlPostBatch: CODEUNIT "Item Jnl.-Post Batch";
    begin
        ProdResultJournalLineTmp.Reset();
        ProdResultJournalLineTmp.DeleteAll();

        SetTemplateAndBatchName();
        DeleteJnlLines(ToTemplateName, ToBatchName, ProdResultJournalLine."Prod. Order No.", ProdResultJournalLine."Prod. Order Line No.");

        ProdOrderLine.get(ProdOrderLine.Status::Released,
                ProdResultJournalLine."Prod. Order No.",
                ProdResultJournalLine."Prod. Order Line No.");


        repeat
            case ProdResultJournalLine."Data Type" of
                ProdResultJournalLine."Data Type"::"Adjust Output",
                ProdResultJournalLine."Data Type"::"Planned Output":
                    begin

                        CreateOutputJnlLine();
                    end;
                ProdResultJournalLine."Data Type"::"Adjust Consumption",
                ProdResultJournalLine."Data Type"::"Planned Consumption":
                    begin
                        CreateConsumptionJnlLine();
                    end;
            end;

            ProdResultJournalLineTmp.Init();
            ProdResultJournalLineTmp.TransferFields(ProdResultJournalLine);
            ProdResultJournalLineTmp.Insert();

        until ProdResultJournalLine.Next() = 0;

        Clear(ItemJnlPostBatch);
        ItemJnlPostBatch.SetSuppressCommit(true);
        ItemJnlPostBatch.Run(ItemJnlLine);

        ProdResultJournalLineTmp.Reset();
        if ProdResultJournalLineTmp.FindSet() then begin
            repeat
                PstProdResJnlLine.Init();
                PstProdResJnlLine.TransferFields(ProdResultJournalLineTmp);
                PstProdResJnlLine."Entry No." := 0;
                PstProdResJnlLine.Insert();

                ProdResultJournalLine.Get(ProdResultJournalLineTmp."Batch Name", ProdResultJournalLineTmp."Journal Line No.");
                ProdResultJournalLine.Delete();
            until ProdResultJournalLineTmp.Next() = 0;
        end;

    end;

    procedure SetTemplateAndBatchName()
    var
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        User: Text;
        IsHandled: Boolean;
        PageID: Integer;
    begin
        PageID := Page::"Production Journal";
        PageTemplate := PageTemplate::"Prod. Order";

        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange("Page ID", PageID);
        ItemJnlTemplate.SetRange(Recurring, false);
        ItemJnlTemplate.SetRange(Type, PageTemplate);
        if not ItemJnlTemplate.FindFirst() then begin
            ItemJnlTemplate.Init();
            ItemJnlTemplate.Recurring := false;
            ItemJnlTemplate.Validate(Type, PageTemplate);
            ItemJnlTemplate.Validate("Page ID");

            ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name));
            ItemJnlTemplate.Description := StrSubstNo(Text000, ItemJnlTemplate.Type);
            ItemJnlTemplate.Insert();
        end;

        ToTemplateName := ItemJnlTemplate.Name;
        ToBatchName := '';
        User := UpperCase(UserId); // Uppercase in case of Windows Login
        if User <> '' then
            if (StrLen(User) < MaxStrLen(ItemJnlLine."Journal Batch Name")) and (ItemJnlLine."Journal Batch Name" <> '') then
                ToBatchName := CopyStr(ItemJnlLine."Journal Batch Name", 1, MaxStrLen(ItemJnlLine."Journal Batch Name") - 1) + 'A'
            else
                ToBatchName := DelChr(CopyStr(User, 1, MaxStrLen(ItemJnlLine."Journal Batch Name")), '>', '0123456789');

        if ToBatchName = '' then
            ToBatchName := Text003;

        if not ItemJnlBatch.Get(ToTemplateName, ToBatchName) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
            ItemJnlBatch.SetupNewBatch();
            ItemJnlBatch.Name := ToBatchName;
            ItemJnlBatch.Description := Text004;
            ItemJnlBatch.Insert(true);
        end;
    end;

    procedure DeleteJnlLines(TemplateName: Code[10]; BatchName: Code[10]; ProdOrderNo: Code[20]; ProdOrderLineNo: Integer)
    var
        ItemJnlLine2: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        IsHandled: Boolean;
    begin
        ItemJnlLine2.Reset();
        ItemJnlLine2.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine2.SetRange("Journal Batch Name", BatchName);
        ItemJnlLine2.SetRange("Order Type", ItemJnlLine2."Order Type"::Production);
        ItemJnlLine2.SetRange("Order No.", ProdOrderNo);
        if ProdOrderLineNo <> 0 then
            ItemJnlLine2.SetRange("Order Line No.", ProdOrderLineNo);
        if ItemJnlLine2.Find('-') then begin
            repeat
                if ReservEntryExist(ItemJnlLine2, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            until ItemJnlLine2.Next() = 0;

            ItemJnlLine2.DeleteAll(true);
        end;
    end;

    procedure ReservEntryExist(ItemJnlLine2: Record "Item Journal Line"; var ReservEntry: Record "Reservation Entry"): Boolean
    begin
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line");
        ReservEntry.SetRange("Source ID", ItemJnlLine2."Journal Template Name");
        ReservEntry.SetRange("Source Ref. No.", ItemJnlLine2."Line No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservEntry.SetRange("Source Subtype", ItemJnlLine2."Entry Type");
        ReservEntry.SetRange("Source Batch Name", ItemJnlLine2."Journal Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        if not ReservEntry.IsEmpty() then
            exit(true);

        exit(false);
    end;

    procedure CreateOutputJnlLine()
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        ProdOrderRtngLine.get(ProdOrderRtngLine.Status::Released,
                            ProdResultJournalLine."Prod. Order No.",
                            ProdResultJournalLine."Prod. Order Line No.",
                            ProdResultJournalLine."Routing No.",
                            ProdResultJournalLine."Operation No.");

        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := ToTemplateName;
        ItemJnlLine."Journal Batch Name" := ToBatchName;
        ItemJnlLine."Line No." := NextLineNo;
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
        ItemJnlLine.Validate("Order No.", ProdOrderLine."Prod. Order No.");
        ItemJnlLine.Validate("Order Line No.", ProdOrderLine."Line No.");
        ItemJnlLine.Validate("Item No.", ProdOrderLine."Item No.");
        ItemJnlLine.Validate("Variant Code", ProdOrderLine."Variant Code");
        ItemJnlLine.Validate("Location Code", ProdOrderLine."Location Code");
        ItemJnlLine.Validate("Dimension Set ID", ProdOrderLine."Dimension Set ID");
        if ProdOrderLine."Bin Code" <> '' then
            ItemJnlLine.Validate("Bin Code", ProdOrderLine."Bin Code");
        ItemJnlLine.Validate("Routing No.", ProdOrderLine."Routing No.");
        ItemJnlLine.Validate("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ItemJnlLine.Validate("Operation No.", ProdResultJournalLine."Operation No.");
        ItemJnlLine.Validate("Unit of Measure Code", ProdResultJournalLine.UOM);
        ItemJnlLine.Validate("Setup Time", 0);
        ItemJnlLine.Validate("Run Time", 0);
        ItemJnlLine.Validate("Output Quantity", ProdResultJournalLine.Quantity);
        ItemJnlLine.Validate("Scrap Quantity", ProdResultJournalLine."Scrap Quantity");
        ItemJnlLine."Flushing Method" := ProdOrderRtngLine."Flushing Method";
        ItemJnlLine.Insert();
        NextLineNo += 10000;

        TempReservEntry.Init();
        TempReservEntry."Lot No." := ProdResultJournalLine."Lot No.";

        CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line",
            ItemJnlLine."Entry Type".AsInteger(),
            ItemJnlLine."Journal Template Name",
            ItemJnlLine."Journal Batch Name",
            0,
            ItemJnlLine."Line No.",
            ItemJnlLine."Qty. per Unit of Measure",
            ItemJnlLine.Quantity,
            ItemJnlLine."Quantity (Base)",
            TempReservEntry
            );
        CreateReservEntry.CreateEntry(
        ItemJnlLine."Item No.",
        ItemJnlLine."Variant Code",
        ItemJnlLine."Location Code",
        '',
        WorkDate(),
        WorkDate(),
        0,
        Enum::"Reservation Status"::Surplus
        );
    end;

    procedure CreateConsumptionJnlLine()
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := ToTemplateName;
        ItemJnlLine."Journal Batch Name" := ToBatchName;
        ItemJnlLine."Line No." := NextLineNo;
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
        ItemJnlLine.Validate("Order No.", ProdResultJournalLine."Prod. Order No.");
        ItemJnlLine.Validate("Source No.", ProdOrderLine."Item No.");
        ItemJnlLine.Validate("Item No.", ProdResultJournalLine."Item No.");
        ItemJnlLine.Validate("Unit of Measure Code", ProdResultJournalLine.UOM);
        ItemJnlLine.Description := ProdOrderComp.Description;
        ItemJnlLine.Validate(Quantity, ProdResultJournalLine.Quantity);

        ProdOrderComp.Reset();
        ProdOrderComp.SetCurrentKey(Status, "Prod. Order No.", "Routing Link Code");
        ProdOrderComp.SetRange(Status, ProdOrderComp.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        ProdOrderComp.SetRange("Line No.", ProdResultJournalLine."Prod. Order Comp. Line No.");
        if ProdOrderComp.FindFirst() then begin
            ItemJnlLine.Validate("Location Code", ProdOrderComp."Location Code");
            ItemJnlLine.Validate("Dimension Set ID", ProdOrderComp."Dimension Set ID");
            ItemJnlLine."Variant Code" := ProdOrderComp."Variant Code";
            ItemJnlLine.Validate("Prod. Order Comp. Line No.", ProdOrderComp."Line No.");
            ItemJnlLine."Flushing Method" := ProdOrderComp."Flushing Method";
        end;
        ItemJnlLine.Validate("Order Line No.", ProdResultJournalLine."Prod. Order Line No.");
        ItemJnlLine.Insert();

        NextLineNo += 10000;

        TempReservEntry.Init();
        TempReservEntry."Lot No." := ProdResultJournalLine."Lot No.";

        CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line",
            ItemJnlLine."Entry Type".AsInteger(),
            ItemJnlLine."Journal Template Name",
            ItemJnlLine."Journal Batch Name",
            0,
            ItemJnlLine."Line No.",
            ItemJnlLine."Qty. per Unit of Measure",
            ItemJnlLine.Quantity,
            ItemJnlLine."Quantity (Base)",
            TempReservEntry
            );
        CreateReservEntry.CreateEntry(
        ItemJnlLine."Item No.",
        ItemJnlLine."Variant Code",
        ItemJnlLine."Location Code",
        '',
        WorkDate(),
        WorkDate(),
        0,
        Enum::"Reservation Status"::Surplus
        );
    end;

    procedure CreateArchive()
    begin

    end;
}
