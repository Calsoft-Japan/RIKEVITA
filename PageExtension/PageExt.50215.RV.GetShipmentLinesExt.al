/// <summary>
/// PageExtension RV Get Shipment Lines (ID 50215) extends "Get Shipment Lines"
/// FDD018 2026/07/07: New. (Bobby.ji)
/// FDD009 2026/08/30: Update to table field for page filtering. (Shawn)
/// additional requirement 2026/10/29: Add the following field. (Bobby.ji)
/// </summary>
pageextension 50215 "RV Get Shipment Lines Ext" extends "Get Shipment Lines"
{
    layout
    {
        addafter("Bill-to Customer No.")
        {
            field("Customer Name"; Rec."RV_Customer Name")
            {
                Caption = 'Customer Name';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Posting Date"; Rec."Posting Date")
            {
                Caption = 'Posting Date';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Order No."; Rec."Order No.")
            {
                Caption = 'Order No.';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                Caption = 'Order Line No.';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
        }
        addafter(YourReference)
        {
            field("Warehouse Shipment No."; Rec."RV_Warehouse Shipment No.")
            {
                Caption = 'Warehouse Shipment No.';
                ApplicationArea = All;
                Description = 'FDD018';
            }
            field("Posted Warehouse Shipment No."; Rec."RV_Posted Whse. Shipment No.")
            {
                Caption = 'Posted Warehouse Shipment No.';
                ApplicationArea = All;
                Description = 'FDD018';
            }
        }
    }
}
