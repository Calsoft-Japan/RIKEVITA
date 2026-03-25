/// <summary>
/// PageExtension RIKE Posted Pur Invoices Ext"(ID 50104) extends "Posted Purchase Invoices" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50104 "RV Posted Pur Invoices Ext" extends "Posted Purchase Invoices"
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
