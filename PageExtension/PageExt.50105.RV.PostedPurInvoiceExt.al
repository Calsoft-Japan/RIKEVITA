/// <summary>
/// PageExtension RIKE Posted Pur Invoice Ext"(ID 50105) extends "Posted Purchase Invoice" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50105 "RV Posted Pur Invoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Remit-to")
        {
            group("RIKE")
            {
                ShowCaption = false;
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
                field("RV_Contract Month"; Rec."RV Contract Month")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
                field("RV_Contract Year"; Rec."RV Contract Year")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
            }

        }
    }
}
