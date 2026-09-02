/// <summary>
/// Codeunit RV Charge Calc. Subscriber (ID 50901)
/// FDD009 2026/05/09: New. (Shawn)
/// </summary>
codeunit 50901 "RV Charge Calc. Subscriber"
{
    Permissions = tabledata "Sales Shipment Line" = m;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCustLedgEntryInsert, '', false, false)]
    local procedure DoOnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    var
        recSalesInvLine: Record "Sales Invoice Line";
    begin

        recSalesInvLine.SetRange("Document No.", CustLedgerEntry."Document No.");
        recSalesInvLine.SetRange(Type, Enum::"Sales Line Type"::Item);
        if not recSalesInvLine.IsEmpty then begin
            recSalesInvLine.CalcSums("RV_Freight Charge");
            CustLedgerEntry."RV_Freight Charge" := recSalesInvLine."RV_Freight Charge";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterInsertShipmentLine, '', false, false)]
    local procedure DoOnAfterInsertShipmentLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var SalesShptLine: record "Sales Shipment Line"; PreviewMode: Boolean; xSalesLine: Record "Sales Line")
    var
        recPostedWhseShptLine: Record "Posted Whse. Shipment Line";
    begin

        recPostedWhseShptLine.SetRange("Posted Source Document", recPostedWhseShptLine."Posted Source Document"::"Posted Shipment");
        recPostedWhseShptLine.SetRange("Posted Source No.", SalesShptLine."Document No.");
        recPostedWhseShptLine.SetRange("Source Line No.", SalesShptLine."Line No.");
        if recPostedWhseShptLine.FindFirst() then begin

            SalesShptLine."RV_Warehouse Shipment No." := recPostedWhseShptLine."Whse. Shipment No.";
            SalesShptLine."RV_Posted Whse. Shipment No." := recPostedWhseShptLine."No.";
            SalesShptLine.Modify();
        end;
    end;
}