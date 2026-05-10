/// <summary>
/// PageExtension RV_Posted Sales Invoice Subform (ID 50905) extends "Posted Sales Invoice Subform"
/// FDD009 2026/04/29: New. (Shawn) 
/// </summary>
pageextension 50905 "RV_PostedSalesInvSubform Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Unit Price")
        {
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
