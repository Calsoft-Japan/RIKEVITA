/// <summary>
/// Page RV_ISO Certificate Code (ID 50106).
/// FDD013 2026/03/19: New (Liuyang)
/// Setup list for ISO Certificate Codes. Accessible from the search menu
/// and linked from the Vendor ISO Certificate List page.
/// </summary>
page 50106 "RV ISO Certificate Code"
{
    Caption = 'ISO Certificate Code';
    PageType = List;
    SourceTable = "RV ISO Certificate Code";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ISO certificate code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the ISO certificate code.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewRecord)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                ToolTip = 'Add a new ISO certificate code.';

                trigger OnAction()
                begin
                    Rec.Init();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(NewRecord_Promoted; NewRecord) { }
        }
    }
}
