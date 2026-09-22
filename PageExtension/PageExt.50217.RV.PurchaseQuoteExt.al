/// <summary>
/// PageExtension RV Purchase Quote (ID 50217) extends "Purchase Quote"
/// On-demand request: add RV_Supplier Quotation No. by Bobby 09/16/2026
/// </summary>
pageextension 50217 "RV Purchase Quote Ext" extends "Purchase Quote"
{
    layout
    {
        addafter(Status)
        {
            field("RV_Supplier Quotation No."; Rec."RV_Supplier Quotation No.")
            {
                Caption = 'Supplier Quotation No.';
                ApplicationArea = All;
            }
        }
    }
}
