/// <summary>
/// PageExtension RIKE Purchase Order List Ext"(ID 50100) extends "Purchase Order List" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50100 "RV Purchase Order List Ext" extends "Purchase Order List"
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
