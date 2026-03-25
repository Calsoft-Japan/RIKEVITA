/// <summary>
/// PageExtension RIKE Purchase Invoices Ext"(ID 50102) extends "Purchase Invoices" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50102 "RV Purchase Invoices Ext" extends "Purchase Invoices"
{
    layout
    {
        addafter("Document Date")
        {
            field(RV_ETA; Rec."RV ETA")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
            field(RV_ETD; Rec."RV ETD")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
        }
    }
}
