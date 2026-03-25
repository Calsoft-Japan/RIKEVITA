/// <summary>
/// pageextension Warehouse Shipment Subform Ext (ID 50107) extends "Warehouse Shipment Subform" page
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50107 "RV Whse. Shipment Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Qty. per Unit of Measure")
        {
            field("RV_B/L Date"; Rec."RV B/L Date")
            {
                ApplicationArea = All;
                Caption = 'B/L Date';
                Description = 'FDD008';
            }
            field("RV_Cosing Date"; Rec."RV Cosing Date")
            {
                ApplicationArea = All;
                Caption = 'Cosing Date';
                Description = 'FDD008';
            }
            field("RV_Stuffing Date"; Rec."RV Stuffing Date")
            {
                ApplicationArea = All;
                Caption = 'Stuffing Date';
                Description = 'FDD008';
            }
            field("RV_ETA"; Rec."RV ETA")
            {
                ApplicationArea = All;
                Caption = 'ETA';
                Description = 'FDD008';
            }
            field("RV_ETD"; Rec."RV ETD")
            {
                ApplicationArea = All;
                Caption = 'ETD';
                Description = 'FDD008';
            }
        }

    }
}
