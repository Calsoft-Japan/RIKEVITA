/// <summary>
/// Page RV QC Value Table (ID 50531).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50531 "RV QC Value Table List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Value Table';
    SourceTable = "RV QC Value Table";
    Editable = false;
    CardPageId = "RV QC Value Table Card";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Value Table Name"; Rec."Value Table Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}