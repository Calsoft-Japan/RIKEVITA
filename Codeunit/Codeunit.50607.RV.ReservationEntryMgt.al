codeunit 50607 ReservationEntryMgt
{

    procedure FindReservationEntry(var ProcessingsalesLine: Record "Sales Line")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        ReqLineDataType: Record "Requisition Line";
        TransferLine: Record "Transfer Line";
        ILEntry: Record "Item Ledger Entry";
        OutputILEntry: Record "Item Ledger Entry";
        ResEntryTransfer: Record "Reservation Entry";
        PlanBOM: Record "Planning Component";
    begin
        TemTransferOrder.DeleteAll();
        TemProdOrder.DeleteAll();
        ResEntryMinus.Reset();
        ResEntryMinus.setrange("Source Type", 37);
        ResEntryMinus.setrange("Source ID", ProcessingsalesLine."Document No.");
        ResEntryMinus.SetRange("Source Ref. No.", ProcessingsalesLine."Line No.");
        ResEntryMinus.SetRange("Positive", false);
        if ResEntryMinus.FindSet() then
            repeat
                ResEntryPlus.Reset();
                ResEntryPlus.SetRange("Entry No.", ResEntryMinus."Entry No.");
                ResEntryPlus.SetRange("Positive", true);
                if ResEntryPlus.FindFirst() then begin
                    case ResEntryPlus."Source Type" of
                        Database::"Requisition Line":
                            begin
                                if ReqLineDataType.get(ResEntryPlus."Source ID", ResEntryPlus."Source Batch Name", ResEntryPlus."Source Ref. No.") then begin
                                    case ReqLineDataType."Ref. Order Type" of
                                        //just do tranfer order case, because may be the production order has been created but transfer order is not created.
                                        ReqLineDataType."Ref. Order Type"::Transfer:
                                            begin
                                                FindTransferLineReservationEntry(ResEntryPlus);
                                            end;

                                    end;
                                end;
                            end;
                        Database::"Transfer Line":
                            begin
                                if TransferLine.get(ResEntryPlus."Source ID", ResEntryPlus."Source Ref. No.") then begin
                                    IF TransferOrderNo = '' then
                                        TransferOrderNo := TransferLine."Document No."
                                    else
                                        TransferOrderNo := TransferOrderNo + '|' + TransferLine."Document No.";
                                    if TransferOrderLineNo = '' then
                                        TransferOrderLineNo := FORMAT(TransferLine."Line No.")
                                    else
                                        TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(TransferLine."Line No.");

                                    IF NOT TemTransferOrder.Get(TransferLine."Document No.") THEN BEGIN
                                        TemTransferOrder.Init();
                                        TemTransferOrder."No." := TransferLine."Document No.";
                                        TemTransferOrder.Insert();
                                    END;
                                    FindTransferLineReservationEntry(ResEntryPlus);

                                end;
                            end;
                        Database::"Item Ledger Entry":
                            begin
                                ILEntry.get(ResEntryPlus."Source Ref. No.");
                                if ILEntry."Document Type" = ILEntry."Entry Type"::Output then begin
                                    IF ProdOrderNo = '' then
                                        ProdOrderNo := ResEntryPlus."Source ID"
                                    else
                                        ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                    if ProdOrderLineNo = '' then
                                        ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                    else
                                        ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                    TemProdOrder.Reset();
                                    TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                    IF TemProdOrder.isempty THEN BEGIN
                                        TemProdOrder."No." := ResEntryPlus."Source ID";
                                        TemProdOrder.Insert();
                                    END;
                                end else begin
                                    if ILEntry."Entry Type" = ILEntry."Entry Type"::Transfer then begin
                                        IF TransferOrderNo = '' then
                                            TransferOrderNo := ILEntry."Order No."
                                        else
                                            TransferOrderNo := TransferOrderNo + '|' + ILEntry."Order No.";
                                        if TransferOrderLineNo = '' then
                                            TransferOrderLineNo := FORMAT(ILEntry."Order Line No.")
                                        else
                                            TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(ILEntry."Order Line No.");
                                        IF NOT TemTransferOrder.Get(ILEntry."Order No.") THEN BEGIN
                                            TemTransferOrder.Init();
                                            TemTransferOrder."No." := ILEntry."Order No.";
                                            TemTransferOrder.Insert();
                                        END;
                                    end;
                                    //Since the inventory is transfered, the production has been completed. just get related item ledger entry by lot no.                                 IF ILEntry."Lot No." <> '' then begin
                                    OutputILEntry.reset;
                                    OutputILEntry.SetRange("Entry Type", OutputILEntry."Entry Type"::Output);
                                    OutputILEntry.SetRange("Item No.", ILEntry."Item No.");
                                    OutputILEntry.SetRange("Lot No.", ILEntry."Lot No.");
                                    if OutputILEntry.FindFirst() then begin
                                        IF ProdOrderNo = '' then
                                            ProdOrderNo := OutputILEntry."Document No."
                                        else
                                            ProdOrderNo := ProdOrderNo + '|' + OutputILEntry."Document No.";
                                        if ProdOrderLineNo = '' then
                                            ProdOrderLineNo := FORMAT(OutputILEntry."Order Line No.")
                                        else
                                            ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(OutputILEntry."Order Line No.");
                                        TemProdOrder.Reset();
                                        TemProdOrder.SetRange("No.", OutputILEntry."Document No.");
                                        IF TemProdOrder.isempty THEN BEGIN
                                            TemProdOrder."No." := OutputILEntry."Document No.";
                                            TemProdOrder.Insert();
                                        END;
                                    end;
                                end;
                            end;
                        Database::"Prod. Order Line":
                            begin
                                IF ProdOrderNo = '' then
                                    ProdOrderNo := ResEntryPlus."Source ID"
                                else
                                    ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                if ProdOrderLineNo = '' then
                                    ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                else
                                    ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                TemProdOrder.Reset();
                                TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                IF TemProdOrder.isempty THEN BEGIN
                                    TemProdOrder."No." := ResEntryPlus."Source ID";
                                    TemProdOrder.Insert();
                                END;
                            end;
                    end;
                end;
            until ResEntryMinus.Next() = 0;
    end;

    procedure FindTransferLineReservationEntry(var
                                                   TransResEntryPlus: Record "Reservation Entry")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        ReqLineDataType: Record "Requisition Line";
        TransferLine: Record "Transfer Line";
        ILEntry: Record "Item Ledger Entry";
        OutputILEntry: Record "Item Ledger Entry";
    begin
        ResEntryMinus.Reset();
        IF TransResEntryPlus."Source Type" = 5741 THEN BEGIN
            ResEntryMinus.setrange("Source Type", 5741);
            ResEntryMinus.setrange("Source ID", TransResEntryPlus."Source ID");
            ResEntryMinus.SetRange("Source Ref. No.", TransResEntryPlus."Source Ref. No.");
        end else begin
            ResEntryMinus.setrange("Source Type", 246);
            ResEntryMinus.setrange("Source ID", TransResEntryPlus."Source ID");
            ResEntryMinus.SetRange("Source Batch Name", TransResEntryPlus."Source Batch Name");
            ResEntryMinus.SetRange("Source Ref. No.", TransResEntryPlus."Source Ref. No.");
        end;
        ResEntryMinus.SetRange("Positive", false);
        if ResEntryMinus.findset then begin
            repeat
                ResEntryPlus.Reset();
                ResEntryPlus.setrange("Entry No.", ResEntryMinus."Entry No.");
                ResEntryPlus.setrange("Positive", true);
                if ResEntryPlus.FindSet() then begin
                    repeat
                        case ResEntryPlus."Source Type" of
                            Database::"Requisition Line":
                                begin
                                    if ReqLineDataType.get(ResEntryPlus."Source ID", ResEntryPlus."Source Batch Name", ResEntryPlus."Source Ref. No.") then begin
                                        case ReqLineDataType."Ref. Order Type" of
                                            //just do tranfer order case, because may be the production order has been created but transfer order is not created.
                                            ReqLineDataType."Ref. Order Type"::Transfer:
                                                FindTransferLineReservationEntry(TransResEntryPlus);
                                        end;
                                    end;
                                end;
                            Database::"Transfer Line":
                                begin
                                    if TransferLine.get(ResEntryPlus."Source ID", ResEntryPlus."Source Ref. No.") then begin
                                        IF TransferOrderNo = '' then
                                            TransferOrderNo := TransferLine."Document No."
                                        else
                                            TransferOrderNo := TransferOrderNo + '|' + TransferLine."Document No.";
                                        if TransferOrderLineNo = '' then
                                            TransferOrderLineNo := FORMAT(TransferLine."Line No.")
                                        else
                                            TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(TransferLine."Line No.");
                                        IF NOT TemTransferOrder.Get(TransferLine."Document No.") THEN BEGIN
                                            TemTransferOrder.Init();
                                            TemTransferOrder."No." := TransferLine."Document No.";
                                            TemTransferOrder.Insert();
                                        END;
                                        FindTransferLineReservationEntry(TransResEntryPlus);

                                    end;
                                end;
                            Database::"Item Ledger Entry":
                                begin
                                    ILEntry.get(ResEntryPlus."Source Ref. No.");
                                    if ILEntry."Document Type" = ILEntry."Entry Type"::Output then begin
                                        IF ProdOrderNo = '' then
                                            ProdOrderNo := ResEntryPlus."Source ID"
                                        else
                                            ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                        if ProdOrderLineNo = '' then
                                            ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                        else
                                            ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");

                                        TemProdOrder.Reset();
                                        TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                        IF TemProdOrder.isempty THEN BEGIN
                                            TemProdOrder."No." := ResEntryPlus."Source ID";
                                            TemProdOrder.Insert();
                                        END;
                                    end else begin
                                        if ILEntry."Entry Type" = ILEntry."Entry Type"::Transfer then begin
                                            IF TransferOrderNo = '' then
                                                TransferOrderNo := ILEntry."Order No."
                                            else
                                                TransferOrderNo := TransferOrderNo + '|' + ILEntry."Order No.";
                                            if TransferOrderLineNo = '' then
                                                TransferOrderLineNo := FORMAT(ILEntry."Order Line No.")
                                            else
                                                TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(ILEntry."Order Line No.");
                                            IF NOT TemTransferOrder.Get(ILEntry."Order No.") THEN BEGIN
                                                TemTransferOrder.Init();
                                                TemTransferOrder."No." := ILEntry."Order No.";
                                                TemTransferOrder.Insert();
                                            END;
                                        end;
                                        //Since the inventory is transfered, the production has been completed. just get related item ledger entry by lot no.                                 IF ILEntry."Lot No." <> '' then begin
                                        OutputILEntry.reset;
                                        OutputILEntry.SetRange("Entry Type", OutputILEntry."Entry Type"::Output);
                                        OutputILEntry.SetRange("Item No.", ILEntry."Item No.");
                                        OutputILEntry.SetRange("Lot No.", ILEntry."Lot No.");
                                        if OutputILEntry.FindFirst() then begin
                                            IF ProdOrderNo = '' then
                                                ProdOrderNo := OutputILEntry."Document No."
                                            else
                                                ProdOrderNo := ProdOrderNo + '|' + OutputILEntry."Document No.";
                                            if ProdOrderLineNo = '' then
                                                ProdOrderLineNo := FORMAT(OutputILEntry."Order Line No.")
                                            else
                                                ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(OutputILEntry."Order Line No.");
                                            TemProdOrder.Reset();
                                            TemProdOrder.SetRange("No.", OutputILEntry."Document No.");
                                            IF TemProdOrder.isempty THEN BEGIN
                                                TemProdOrder."No." := OutputILEntry."Document No.";
                                                TemProdOrder.Insert();
                                            END;
                                        end;
                                    end;
                                end;
                            Database::"Prod. Order Line":
                                begin
                                    IF ProdOrderNo = '' then
                                        ProdOrderNo := ResEntryPlus."Source ID"
                                    else
                                        ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                    if ProdOrderLineNo = '' then
                                        ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                    else
                                        ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                    TemProdOrder.Reset();
                                    TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                    IF TemProdOrder.isempty THEN BEGIN
                                        TemProdOrder."No." := ResEntryPlus."Source ID";
                                        TemProdOrder.Insert();
                                    END;
                                end;
                        end;
                    until ResEntryPlus.Next() = 0;
                end;
            until ResEntryMinus.Next() = 0;
        end;
    end;

    procedure GetProdNoInfo(var ProdNo: Text[250])
    begin
        ProdNo := '';
        if TemProdOrder.FindSet() then
            repeat
                if ProdNo = '' then
                    ProdNo := TemProdOrder."No."
                else
                    ProdNo := ProdNo + '|' + TemProdOrder."No.";
            until TemProdOrder.Next() = 0;
    end;

    var
        TransferOrderNo: Text[250];
        TransferOrderLineNo: Text[250];
        ProdOrderNo: Text[250];
        ProdOrderLineNo: Text[250];
        EntryNo: Integer;
        Counts: Integer;
        TemTransferOrder: Record "Transfer Header" temporary;
        TemTransferLine: Record "Transfer Line" temporary;
        TemProdOrder: Record "Production Order" temporary;

}
