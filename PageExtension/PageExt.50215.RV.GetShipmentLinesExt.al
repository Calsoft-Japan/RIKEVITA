/// <summary>
/// PageExtension RV Get Shipment Lines (ID 50215) extends "Get Shipment Lines"
/// FDD018 2026/07/07: New. (Bobby.ji)
/// </summary>
pageextension 50215 "RV Get Shipment Lines Ext" extends "Get Shipment Lines"
{
    layout
    {
        addafter(YourReference)
        {
            field("Warehouse Shipment No."; WarehouseShipmentNo)
            {
                Caption = 'Warehouse Shipment No.';
                ApplicationArea = All;
                Description = 'FDD018';
            }
            field("Posted Warehouse Shipment No."; PostedWarehouseShipmentNo)
            {
                Caption = 'Posted Warehouse Shipment No.';
                ApplicationArea = All;
                Description = 'FDD018';
            }
        }
    }
    var
        WarehouseShipmentNo: Code[20];
        PostedWarehouseShipmentNo: Code[20];

    trigger OnAfterGetRecord()
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        PostedWhseShipmentLine.Reset();
        PostedWhseShipmentLine.SetRange("Posted Source No.", Rec."Document No.");
        PostedWhseShipmentLine.SetRange("Source Line No.", Rec."Line No.");
        if PostedWhseShipmentLine.FindFirst() then begin
            WarehouseShipmentNo := PostedWhseShipmentLine."Whse. Shipment No.";
            PostedWarehouseShipmentNo := PostedWhseShipmentLine."No.";
        end;
    end;
}
