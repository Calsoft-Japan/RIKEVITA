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
        PostedWhseShipmentHeader.RV_VIA := WarehouseShipmentHeader.RV_VIA;
        PostedWhseShipmentHeader."RV_Feeder Vessel" := WarehouseShipmentHeader."RV_Feeder Vessel";
        PostedWhseShipmentHeader."RV_Mother Vessel" := WarehouseShipmentHeader."RV_Mother Vessel";
        PostedWhseShipmentHeader."RV_Country of Origin" := WarehouseShipmentHeader."RV_Country of Origin";
        PostedWhseShipmentHeader."RV_Ship-to Name" := WarehouseShipmentHeader."RV_Ship-to Name";
        PostedWhseShipmentHeader."RV_SAILING ON OR ABOUT" := WarehouseShipmentHeader."RV_SAILING ON OR ABOUT";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnAfterPostedWhseShptHeaderInsert, '', false, false)]
    local procedure "Whse.-Post Shipment_OnAfterPostedWhseShptHeaderInsert"(PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; LastShptNo: Code[20])
    var
        PackingInfo: Record "RV Warehouse Packing Info.";
        TmpPackingInfo: Record "RV Warehouse Packing Info." temporary;
    begin
        PackingInfo.Reset();
        PackingInfo.SetRange("Warehouse Shipment No.", PostedWhseShipmentHeader."Whse. Shipment No.");
        if PackingInfo.FindSet() then begin
            repeat
                PackingInfo.Rename(PackingInfo."Warehouse Shipment No.", PostedWhseShipmentHeader."No.", PackingInfo."Sales Order No.", PackingInfo."SO Line No.");
            until PackingInfo.Next() = 0;
        end;

    end;
}
