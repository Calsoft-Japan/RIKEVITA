/// <summary>
/// PageExtension RV_Item Card (ID 50200) extends "Item Card"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
pageextension 50200 "RV_Item Card" extends "Item Card"
{
    layout
    {
        addafter("Expiration Calculation")
        {
            field("Expiration Base Date (RM)"; Rec."RV_Expiration Base Date (RM)")
            {
                Caption = 'Expiration Base Date (RM)';
                ApplicationArea = all;
            }
        }
    }
}
