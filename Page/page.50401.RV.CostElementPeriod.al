/// <summary>
/// Page RV Cost Element Period (ID 50401).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
page 50401 "Standard Cost Element Period"
{
    PageType = List;
    SourceTable = "Standard Cost Element Period";
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
                }
                field("Description"; Rec."Description")
                {
                }
                field("Start Date"; Rec."Effective Start Date")
                {
                }
                field("End Date"; Rec."Effective End Date")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Details")
            {
                ApplicationArea = All;
                Image = ViewDetails;
                RunObject = page "Standard Cost Element Details";
                RunPageLink = "Period Code" = FIELD("Code");
            }
        }
    }
}