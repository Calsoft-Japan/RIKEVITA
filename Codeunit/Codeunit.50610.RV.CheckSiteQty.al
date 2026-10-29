/// <summary>
/// Codeunit RV Check Site Qty (ID 50610)
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
codeunit 50610 "RV Check Site Qty"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnCodeOnBeforePostLines', '', false, false)]
    local procedure OnCodeOnBeforePostLinesHandler(var ItemJournalLine: Record "Item Journal Line")
    var
        ILE: record "Item Ledger Entry";
        T337: record "Reservation Entry";
    begin
        // Your code here
        GLSetup.Get();
        if ItemJournalLine.FindSet() then
            repeat
                if not ItemJnlTemplate.get(ItemJournalLine."Journal Template Name") then
                    exit;

                if ItemJnlTemplate.type <> ItemJnlTemplate.type::Transfer then
                    exit;

                ILE.Reset();
                ILE.SetRange("Item No.", ItemJournalLine."Item No.");
                ILE.SetRange("Location Code", ItemJournalLine."Location Code");
                ILE.SetRange("global dimension 1 code", ItemJournalLine."Shortcut Dimension 1 Code");
                ILE.SetRange("global dimension 2 code", ItemJournalLine."Shortcut Dimension 2 Code");

                T337.Reset();
                T337.SetRange("Item No.", ItemJournalLine."Item No.");
                T337.SetRange("Source Type", DATABASE::"Item Journal Line");
                T337.SetRange("Source ID", ItemJournalLine."Journal Template Name");
                T337.SetRange("Source Batch Name", ItemJournalLine."Journal Batch Name");
                T337.SetRange("Source Ref. No.", ItemJournalLine."Line No.");
                if T337.FindSet() then begin
                    repeat
                        // Your code for handling reservation entries here
                        ILE.SetRange("Lot No.", T337."Lot No.");
                        ILE.CalcSums("Remaining Quantity");
                        if ILE."Remaining Quantity" < ItemJournalLine."Quantity (Base)" then
                            Error(ErrorText, ItemJournalLine."Item No.", ItemJournalLine."Location Code", T337."Lot No.", GLSetup."Shortcut Dimension 1 Code" + ' ' + ItemJournalLine."Shortcut Dimension 1 Code", GLSetup."Shortcut Dimension 2 Code" + ' ' + ItemJournalLine."Shortcut Dimension 2 Code", ItemJournalLine."Line No.");

                    until T337.Next() = 0;
                end else begin
                    ILE.CalcSums("Remaining Quantity");
                    if ILE."Remaining Quantity" < ItemJournalLine."Quantity (Base)" then
                        Error(ErrorText, ItemJournalLine."Item No.", ItemJournalLine."Location Code", '', GLSetup."Shortcut Dimension 1 Code" + ' ' + ItemJournalLine."Shortcut Dimension 1 Code", GLSetup."Shortcut Dimension 2 Code" + ' ' + ItemJournalLine."Shortcut Dimension 2 Code", ItemJournalLine."Line No.");

                end;
            until ItemJournalLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::page, page::"Sales Order Subform", 'OnAfterActionEvent', 'Reserve', false, false)]
    local procedure OnAfterActionReserve(var Rec: Record "Sales Line")
    var
        T337: Record "Reservation Entry";
        T337Plus: Record "Reservation Entry";
        ILE: Record "Item Ledger Entry";
        ProdOrderLine: Record "Prod. Order Line";
        salesLine: Record "Sales Line";
    begin
        // Your code for handling the event here
        T337.Reset();
        T337.SetRange("Item No.", Rec."No.");
        T337.SetRange("Source Type", DATABASE::"Sales Line");
        T337.SetRange("Source ID", Rec."Document No.");
        T337.SetRange("Source Ref. No.", Rec."Line No.");
        if T337.FindSet() then
            repeat
                if T337Plus.get(T337."Entry No.", true) then begin
                    case T337Plus."Source Type" of
                        DATABASE::"Item Ledger Entry":
                            // Your code for handling sales line source type here
                            begin
                                ILE.get(T337Plus."Source Ref. No.");
                                salesLine.get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                                salesLine.Validate("Shortcut Dimension 1 Code", ILE."Global Dimension 1 Code");
                                salesLine.Modify();
                                exit;
                            end;
                        database::"Prod. Order Line":
                            // Your code for handling production order line source type here
                            begin
                                if ProdOrderLine.get(T337Plus."Source Subtype", T337Plus."Source ID", T337Plus."Source Prod. Order Line") then begin
                                    salesLine.get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                                    salesLine.Validate("Shortcut Dimension 1 Code", ProdOrderLine."Shortcut Dimension 1 Code");
                                    salesLine.Modify();
                                    exit;
                                end;
                            end;
                    end;
                end;
            until T337.Next() = 0;
    end;

    [EventSubscriber(ObjectType::page, page::"Released Prod. Order Lines", 'OnAfterActionEvent', '&Reserve', false, false)]
    local procedure OnAfterActionReserveReleasedProdOrderLines(var Rec: Record "Prod. Order Line")
    begin
        // Your code for handling the event here
        SetSiteCodeFromProdToSO(Rec);
    end;

    [EventSubscriber(ObjectType::page, page::"Firm Planned Prod. Order Lines", 'OnAfterActionEvent', '&Reserve', false, false)]
    local procedure OnAfterActionReserveFirmPlannedProdOrderLines(var Rec: Record "Prod. Order Line")
    begin
        // Your code for handling the event here
        SetSiteCodeFromProdToSO(Rec);
    end;

    procedure SetSiteCodeFromProdToSO(var Rec: Record "Prod. Order Line")
    var
        T337: Record "Reservation Entry";
        T337Minus: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        ProdOrderHeader: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        T337.Reset();
        T337.SetRange("Item No.", Rec."Item No.");
        T337.SetRange("Source Type", DATABASE::"Prod. Order Line");
        T337.SetRange("Source ID", Rec."Prod. Order No.");
        T337.SetRange("Source Prod. Order Line", Rec."Line No.");
        if T337.FindSet() then
            repeat
                if T337Minus.get(T337."Entry No.", false) then begin
                    // Your code for handling the reservation entry here
                    case T337Minus."Source Type" of
                        DATABASE::"Sales Line":
                            begin
                                // Your code for handling sales line source type here
                                if SalesLine.get(T337Minus."Source Subtype", T337Minus."Source ID", T337Minus."Source Ref. No.") then begin
                                    // Your code for handling the sales line here
                                    ProdOrderHeader.get(Rec.Status, Rec."Prod. Order No.");
                                    ProdOrderHeader.Validate("Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 1 Code");
                                    ProdOrderHeader.Modify();

                                    ProdOrderLine.get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.");
                                    ProdOrderLine.Validate("Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 1 Code");
                                    ProdOrderLine.Modify();
                                end;
                            end;
                    end;
                end;
            until T337.Next() = 0;
    end;

    [EventSubscriber(ObjectType::table, database::"Production Order", 'OnBeforeConfirmUpdateAllLineDim', '', false, false)]
    local procedure OnBeforeConfirmUpdateAllLineDim(var IsHandled: Boolean)
    begin
        // Your code for handling the event here
        IsHandled := true;
    end;

    var
        ItemJnlTemplate: Record "Item Journal Template";
        ErrorText: Label 'Not enough quantity available for Item %1 in Location %2 and Lot %3 and %4 and %5 for Item Reclass Journal Line No. %6';
        GLSetup: Record "General Ledger Setup";
}