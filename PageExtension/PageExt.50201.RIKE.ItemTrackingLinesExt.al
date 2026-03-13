/// <summary>
/// PageExtension RV_Item Tracking Lines (ID 50201) extends "Item Tracking Lines"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
pageextension 50201 "RV_Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addbefore("Expiration Date")
        {
            field("Manufacture Date"; Rec."RV_Manufacture Date")
            {
                Caption = 'Manufacture Date';
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    Item.Get(Rec."Item No.");
                    if Item."RV_Expiration Base Date (RM)" = Item."RV_Expiration Base Date (RM)"::"Manufacture Date" then begin
                        Rec."Expiration Date" := CalcDate(Item."Expiration Calculation", Rec."RV_Manufacture Date");
                    end;
                end;
            }
        }
    }
}
