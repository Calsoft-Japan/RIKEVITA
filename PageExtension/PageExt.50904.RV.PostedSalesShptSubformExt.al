/// <summary>
/// PageExtension RV_Posted Sales Shpt. Subform (ID 50904) extends "Posted Sales Shpt. Subform"
/// FDD009 2026/04/29: New. (Shawn) 
/// </summary>
pageextension 50904 "RV_PostedSalesShptSubform Ext" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("RV_Posted Whse. Shipment No."; Rec."RV_Posted Whse. Shipment No.")
            {
                Caption = 'Posted Warehouse Shipment No.';
                ApplicationArea = All;
            }
            field("RV_Freight Charge"; Rec."RV_Freight Charge")
            {
                Caption = 'Freight Charge';
                ApplicationArea = All;
            }
            field("RV_Other Charge"; Rec."RV_Other Charge")
            {
                Caption = 'Other Charge';
                ApplicationArea = All;
            }
            field("RV_Charge Type"; Rec."RV_Charge Type")
            {
                Caption = 'Charge Type';
                ApplicationArea = All;
            }
        }
    }
}
