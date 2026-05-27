/// <summary>
/// PageExtension RV Warehouse Shipment List (ID 50213) extends "Warehouse Shipment List"
/// FDD020 2026/05/14: New. (Bobby.ji)
/// </summary>
pageextension 50213 "RV Warehouse Shipment List Ext" extends "Warehouse Shipment List"
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
        WarehousePackingInfo.SetFilter("Posted Whse. Shipment No.", '=%1', '');
        WarehousePackingInfo.DeleteAll();
    end;

}
