/// <summary>
/// PageExtension RV_Item Tracking Lines (ID 50201) extends "Item Tracking Lines"
/// FDD001 FDD008 2026/03/12: New. (Bobby.ji)
/// </summary>
pageextension 50201 "RV Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addbefore("Expiration Date")
        {

            field("RV_Container No."; Rec."RV Container No.")//FDD008
            {
                Caption = 'Container No.';
                ApplicationArea = All;
            }
            field("Manufacture Date"; Rec."RV Manufacture Date")
            {
                Caption = 'Manufacture Date';
                ApplicationArea = all;
                //Visible = ShowManufactureDate;
            }
        }
        /*modify("Expiration Date")
        {
            Visible = ShowExpirationDate;
        }*/
    }

    var
        ShowManufactureDate: Boolean;
    //ShowExpirationDate: Boolean;

    /*
        trigger OnAfterGetRecord()
        var
            Item: Record Item;
        begin
            ShowManufactureDate := false;
            //ShowExpirationDate := true;
            Item.Get(Rec."Item No.");
            if Item."RV_Expiration Base Date (RM)" = Item."RV_Expiration Base Date (RM)"::"Manufacture Date" then begin
                ShowManufactureDate := true;
                ExpirationDateVisible := false;
            end;
        end;
        */
}
