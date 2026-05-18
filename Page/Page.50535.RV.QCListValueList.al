/// <summary>
/// Page RV QC List Value List (ID 50535).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50535 "RV QC List Value List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC List Value';
    SourceTable = "RV QC List Value";
    //Editable = false;
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
                field("Value Table Type"; Rec."List Value")
                {
                    ApplicationArea = All;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}