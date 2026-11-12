/// <summary>
/// PageExtension RIKE Posted Pur Invoices Ext"(ID 50104) extends "Posted Purchase Invoices" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// On-demand request: add RV_Department Dimension Code by Bobby 11/12/2026
/// </summary>
pageextension 50104 "RV Posted Pur Invoices Ext" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("RV_Department Dimension Code"; Rec."RV_Department Dimension Code")
            {
                Caption = 'Department Dimension Code';
                ApplicationArea = All;
            }
        }

        addafter("Document Date")
        {
            field(RV_ETA; Rec."RV_ETA")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
            field(RV_ETD; Rec."RV_ETD")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
        }
    }
}
