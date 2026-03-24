/// <summary>
/// Page RV QC Parameter List (ID 50500).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50500 "RV QC Parameter List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Parameter List';
    SourceTable = "RV QC Parameter";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Parameter Name"; Rec."Parameter Name")
                {
                    ApplicationArea = All;
                }
                field("Parameter Description"; Rec."Parameter Description")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                }
                field("Value Table Name"; Rec."Value Table Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}