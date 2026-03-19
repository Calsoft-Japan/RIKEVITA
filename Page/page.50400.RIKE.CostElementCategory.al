/// <summary>
/// Page RV Cost Element Category (ID 50400).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
page 50400 "RIKE Cost Element Category"
{
    SourceTable = "RIKE Cost Element Category";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}