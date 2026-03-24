/// <summary>
/// Page RV QC Group List (ID 50506).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50506 "RV QC Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Group List';
    SourceTable = "RV QC Group";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("QC Group No."; Rec."QC Group No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Internal Specification"; Rec."Internal Specification")
                {
                    ApplicationArea = All;
                }
                field("External Specification"; Rec."External Specification")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}