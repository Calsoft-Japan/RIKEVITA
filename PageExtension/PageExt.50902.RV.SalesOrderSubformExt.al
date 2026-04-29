/// <summary>
/// PageExtension RV_Sales Order Subform (ID 50902) extends "Sales Order Subform"
/// FDD009 2026/04/29: New. (Shawn) 
/// </summary>
pageextension 50902 "RV_Sales Order Subform Ext" extends "Sales Order Subform"
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
        }
    }
}
