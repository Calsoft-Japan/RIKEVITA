/// <summary>
/// PageExtension RV_Sales Invoice Subform (ID 50903) extends "Sales Invoice Subform"
/// FDD009 2026/04/29: New. (Shawn) 
/// </summary>
pageextension 50903 "RV_Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
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
