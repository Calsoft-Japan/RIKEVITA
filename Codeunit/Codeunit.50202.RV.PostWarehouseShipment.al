/// <summary>
/// Codeunit RV Post Warehouse Shipment (ID 50202)
/// FDD019 2026/04/24: New. (Bobby.ji)
/// </summary>
codeunit 50202 "RV Post Warehouse Shipment"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnBeforePostedWhseShptHeaderInsert, '', false, false)]
    local procedure "Whse.-Post Shipment_OnBeforePostedWhseShptHeaderInsert"(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShipmentHeader."RV_Consignee Name" := WarehouseShipmentHeader."RV_Consignee Name";
        PostedWhseShipmentHeader."RV_Consignee Address" := WarehouseShipmentHeader."RV_Consignee Address";
        PostedWhseShipmentHeader."RV_Consignee Address 2" := WarehouseShipmentHeader."RV_Consignee Address 2";
        PostedWhseShipmentHeader."RV_Consignee City" := WarehouseShipmentHeader."RV_Consignee City";
        PostedWhseShipmentHeader."RV_Consignee Post Code" := WarehouseShipmentHeader."RV_Consignee Post Code";
        PostedWhseShipmentHeader."RV_Consignee Country/Region" := WarehouseShipmentHeader."RV_Consignee Country/Region";
    end;


}
