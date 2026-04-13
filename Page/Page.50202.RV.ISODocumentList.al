/// <summary>
/// Page RIKE ISO Document List (ID 50202).
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
page 50202 "RV ISO Document List"
{
    ApplicationArea = All;
    Caption = 'ISO Document List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "RV ISO Document";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Report Code"; Rec."Report Code")
                {
                    Caption = 'Report Code';
                    Description = 'FDD020';
                    ApplicationArea = All;
                }
                field("Report Name"; Rec."Report Name")
                {
                    Caption = 'Report Name';
                    Description = 'FDD020';
                    ApplicationArea = All;
                }
                field("ISO Document No."; Rec."ISO Document No.")
                {
                    Caption = 'ISO Document No.';
                    Description = 'FDD020';
                    ApplicationArea = All;
                }
                field("ISO Doc. Version No."; Rec."ISO Doc. Version No.")
                {
                    Caption = 'ISO Doc. Version No.';
                    Description = 'FDD020';
                    ApplicationArea = All;
                }
            }

        }
    }


}

