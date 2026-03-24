/// <summary>
/// PageExtension RIKE Purchase Order List Ext"(ID 50100) extends "Purchase Order List" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50100 "RIKE Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        addafter("Document Date")
        {
            field(RV_ETA; Rec.RV_ETA)
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
            field(RV_ETD; Rec.RV_ETD)
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
        }
    }
}
