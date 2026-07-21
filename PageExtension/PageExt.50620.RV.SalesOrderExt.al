/// <summary>
/// PageExtension RV_Sales Order Subform (ID 50620) extends "Sales Order"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50620 "RV_Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("RV_Shipment Type"; Rec."RV_Shipment Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
