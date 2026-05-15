/// <summary>
/// Codeunit RV Get Shipment Lines (ID 50203)
/// FDD021 2026/05/12: New. (Bobby.ji)
/// </summary>
codeunit 50203 "RV Get Shipment Lines"
{
    [EventSubscriber(ObjectType::Page, Page::"Get Shipment Lines", OnCreateLinesOnAfterSalesGetShptSetSalesHeader, '', false, false)]
    local procedure "Get Shipment Lines_OnCreateLinesOnAfterSalesGetShptSetSalesHeader"(var Sender: Page "Get Shipment Lines"; var SalesHeader: Record "Sales Header"; var SalesShipmentLine: Record "Sales Shipment Line")
    var
        PostWhseShipmentLine: Record "Posted Whse. Shipment Line";
        PostWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        RecSalesHeader: Record "Sales Header";
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.Reset();
        WarehouseEntry.SetRange("Source No.", SalesShipmentLine."Order No.");
        WarehouseEntry.SetRange("Source Line No.", SalesShipmentLine."Order Line No.");
        if WarehouseEntry.FindFirst() then begin
            if PostWhseShipmentHeader.Get(WarehouseEntry."Whse. Document No.") then begin
                //SalesHeader.RV_ETA := WhseShipmentHeader.RV_ETA;
                //SalesHeader.RV_ETD := WhseShipmentHeader.RV_ETD;
                SalesHeader.RV_VIA := PostWhseShipmentHeader.RV_VIA;
                SalesHeader."RV_Feeder Vessel" := PostWhseShipmentHeader."RV_Feeder Vessel";
                SalesHeader."RV_Mother Vessel" := PostWhseShipmentHeader."RV_Mother Vessel";
                SalesHeader.RV_Destination := PostWhseShipmentHeader."RV_Final Destination";
                SalesHeader."RV_Country of Origin" := PostWhseShipmentHeader."RV_Country of Origin";
                SalesHeader."RV_SAILING ON OR ABOUT" := PostWhseShipmentHeader."RV_SAILING ON OR ABOUT";
                SalesHeader.Modify();
            end;
        end;
    end;



}
