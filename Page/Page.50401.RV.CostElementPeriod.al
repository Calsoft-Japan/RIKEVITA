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
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        StandardCostElementDetails: Record "Standard Cost Element Details";
                    begin
                        StandardCostElementDetails.SetRange("Period Code", Rec.Code);
                        Page.Run(Page::"Standard Cost Element Details", StandardCostElementDetails);
                    end;
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
                field("Current Period"; Rec."Current Period")
                {
                }
                field("Comment"; Rec."Comment")
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