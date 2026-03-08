/// <summary>
/// PageExtension RIKE Purchase Order Ext"(ID 50101) extends "Purchase Order" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50101 "RIKE Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Remit-to")
        {
            group("RIKE")
            {
                ShowCaption = false;
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
                field("RV_Contract Month"; Rec."RV_Contract Month")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
                field("RV_Contract Year"; Rec."RV_Contract Year")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
            }

        }
    }
}
