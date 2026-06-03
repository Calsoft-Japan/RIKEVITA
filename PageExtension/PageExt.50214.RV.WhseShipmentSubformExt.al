/// <summary>
/// PageExtension RV Whse Shipment Subform (ID 50214) extends "Whse. Shipment Subform"
/// FDD020 2026/05/14: New. (Bobby.ji)
/// </summary>
pageextension 50214 "RV Whse Shipment Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {

    }
    trigger OnDeleteRecord(): Boolean
    var
        WarehousePackingInfo: Record "RV Warehouse Packing Info.";
    begin
        WarehousePackingInfo.Reset();
        WarehousePackingInfo.SetRange("Warehouse Shipment No.", Rec."No.");
        WarehousePackingInfo.SetRange("Item No.", Rec."Item No.");
        WarehousePackingInfo.SetRange("Sales Order No.", Rec."Source No.");
        WarehousePackingInfo.SetRange("SO Line No.", Rec."Source Line No.");
        if WarehousePackingInfo.FindFirst() then begin
            WarehousePackingInfo.Delete();
        end;
    end;

}
