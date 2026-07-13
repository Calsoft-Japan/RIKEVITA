/// <summary>
/// Codeunit RV Post Warehouse Shipment (ID 50202)
/// FDD019 2026/04/24: New. (Bobby.ji)
/// FDD008 2026/05/19 (Liuyang)
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
        PostedWhseShipmentHeader."RV_Final Destination" := WarehouseShipmentHeader."RV_Final Destination";
        PostedWhseShipmentHeader."RV_Country of Origin" := WarehouseShipmentHeader."RV_Country of Origin";
        PostedWhseShipmentHeader."RV_Ship-to Name" := WarehouseShipmentHeader."RV_Ship-to Name";
        PostedWhseShipmentHeader."RV_SAILING ON OR ABOUT" := WarehouseShipmentHeader."RV_SAILING ON OR ABOUT";

        //FDD008
        PostedWhseShipmentHeader."RV_B/L Date" := WarehouseShipmentHeader."RV_B/L Date";
        PostedWhseShipmentHeader."RV_Closing Date" := WarehouseShipmentHeader."RV_Closing Date";
        PostedWhseShipmentHeader."RV_Stuffing Date" := WarehouseShipmentHeader."RV_Stuffing Date";
        PostedWhseShipmentHeader.RV_ETD := WarehouseShipmentHeader."RV_ETD";
        PostedWhseShipmentHeader.RV_ETA := WarehouseShipmentHeader."RV_ETA";
        //FDD008

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnAfterPostedWhseShptHeaderInsert, '', false, false)]
    local procedure "Whse.-Post Shipment_OnAfterPostedWhseShptHeaderInsert"(PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; LastShptNo: Code[20])
    var
        PackingInfo: Record "RV Warehouse Packing Info.";
    //TmpPackingInfo: Record "RV Warehouse Packing Info." temporary;
    //NewPackingInfo: Record "RV Warehouse Packing Info.";
    begin
        PackingInfo.Reset();
        PackingInfo.SetRange("Warehouse Shipment No.", PostedWhseShipmentHeader."Whse. Shipment No.");
        PackingInfo.SetRange("Posted Whse. Shipment No.", '');
        if PackingInfo.FindSet() then begin
            repeat
                /*IF NOT NewPackingInfo.get(PackingInfo."Warehouse Shipment No.", PostedWhseShipmentHeader."No.", PackingInfo."Sales Order No.", PackingInfo."SO Line No.") then begin
                    NewPackingInfo.TransferFields(PackingInfo, true);
                    NewPackingInfo."Warehouse Shipment No." := PackingInfo."Warehouse Shipment No.";
                    NewPackingInfo."Sales Order No." := PackingInfo."Sales Order No.";
                    NewPackingInfo."SO Line No." := PackingInfo."SO Line No.";
                    NewPackingInfo."Posted Whse. Shipment No." := PostedWhseShipmentHeader."No.";
                    NewPackingInfo.Insert();
                end;
                //PackingInfo.Rename(PackingInfo."Warehouse Shipment No.", PostedWhseShipmentHeader."No.", PackingInfo."Sales Order No.", PackingInfo."SO Line No.");
                PackingInfo.Delete();*/
                PackingInfo."Posted Whse. Shipment No." := PostedWhseShipmentHeader."No.";
                PackingInfo.Modify();
            until PackingInfo.Next() = 0;
        end;

    end;

    //FDD008
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnCreatePostedShptLineOnBeforePostedWhseShptLineInsert, '', false, false)]
    local procedure "Whse.-Post Shipment_OnCreatePostedShptLineOnBeforePostedWhseShptLineInsert"(var PostedWhseShptLine: Record "Posted Whse. Shipment Line"; WhseShptLine: Record "Warehouse Shipment Line")
    begin
        //FDD008
        PostedWhseShptLine."RV_B/L Date" := WhseShptLine."RV_B/L Date";
        PostedWhseShptLine."RV_Closing Date" := WhseShptLine."RV_Closing Date";
        PostedWhseShptLine."RV_Stuffing Date" := WhseShptLine."RV_Stuffing Date";
        PostedWhseShptLine.RV_ETD := WhseShptLine."RV_ETD";
        PostedWhseShptLine.RV_ETA := WhseShptLine."RV_ETA";
        //FDD008
    end;

}
