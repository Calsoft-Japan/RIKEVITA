
/// <summary>
/// PageExtension RV Purchase Order (ID 50612) extends "Purchase Order"
/// FDD012 2026/03/15: New. (Stephen)
/// </summary>
pageextension 50612 "RV Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("RV Planning Date"; Rec."RV_Planning Date")
            {
                ApplicationArea = All;
            }

            field("RV Planning Status"; Rec."RV_Planning Status")
            {
                ApplicationArea = All;
            }

            field("RV Planning Controller"; Rec."RV_Planning Controller")
            {
                ApplicationArea = All;
            }
        }
    }
}
