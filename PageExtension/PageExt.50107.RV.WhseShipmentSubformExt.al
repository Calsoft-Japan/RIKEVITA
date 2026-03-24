/// <summary>
/// pageextension Warehouse Shipment Subform Ext (ID 50107) extends "Warehouse Shipment Subform" page
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50107 "Whse. Shipment Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Qty. per Unit of Measure")
        {
            field("RV_B/L Date"; Rec."RV_B/L Date")
            {
                ApplicationArea = All;
                Caption = 'B/L Date';
                Description = 'FDD008';
            }
            field("RV_Cosing Date"; Rec."RV_Cosing Date")
            {
                ApplicationArea = All;
                Caption = 'Cosing Date';
                Description = 'FDD008';
            }
            field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
            {
                ApplicationArea = All;
                Caption = 'Stuffing Date';
                Description = 'FDD008';
            }
            field("RV_ETA"; Rec."RV_ETA")
            {
                ApplicationArea = All;
                Caption = 'ETA';
                Description = 'FDD008';
            }
            field("RV_ETD"; Rec."RV_ETD")
            {
                ApplicationArea = All;
                Caption = 'ETD';
                Description = 'FDD008';
            }
        }

    }
}
