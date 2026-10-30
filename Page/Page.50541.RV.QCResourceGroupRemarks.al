/// <summary>
/// Page RV External Spec. Description (ID 50530).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50542 "RV QC Resource Group Remarks"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Resource Group Remarks';
    SourceTable = "RV QC Resource Group Remarks";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("QC Resource Group No."; Rec."QC Resource Group No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Remark Code"; Rec."Remark Code")
                {
                    ApplicationArea = All;
                }
                field("Remark Type"; Rec."Remark Type")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}