/// <summary>
/// Codeunit RV Get Shipment Lines (ID 50203)
/// FDD021 2026/05/12: New. (Bobby.ji)
/// </summary>
codeunit 50203 "RV Get Shipment Lines"
{
    [EventSubscriber(ObjectType::Page, Page::"Get Shipment Lines", OnCreateLinesOnAfterSalesGetShptSetSalesHeader, '', false, false)]
    local procedure "Get Shipment Lines_OnCreateLinesOnAfterSalesGetShptSetSalesHeader"(var Sender: Page "Get Shipment Lines"; var SalesHeader: Record "Sales Header"; var SalesShipmentLine: Record "Sales Shipment Line")
    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        RecSalesHeader: Record "Sales Header";
    begin
        RecSalesHeader.Reset();
        RecSalesHeader.SetRange("No.", SalesShipmentLine."Order No.");
        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
        if RecSalesHeader.FindFirst() then begin
            WhseShipmentLine.Reset();
            WhseShipmentLine.SetRange("Source Type", 37);
            WhseShipmentLine.SetRange("Source No.", RecSalesHeader."No.");
            if WhseShipmentLine.FindFirst() then begin
                if WhseShipmentHeader.Get(WhseShipmentLine."No.") then begin
                    SalesHeader.RV_ETA := WhseShipmentHeader.RV_ETA;
                    SalesHeader.RV_ETD := WhseShipmentHeader.RV_ETD;
                end;
            end;
        end;


    end;



}
