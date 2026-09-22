/// <summary>
/// PageExtension RV Purchase Quotes (ID 50218) extends "Purchase Quote"
/// On-demand request: add RV_Supplier Quotation No. by Bobby 09/16/2026
/// </summary>
pageextension 50218 "RV Purchase Quotes Ext" extends "Purchase Quotes"
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
