/// <summary>
/// Page RV QC List Value Subform (ID 50533).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50533 "RV QC List Value Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'QC List Value';
    SourceTable = "RV QC List Value";
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
                    TableRelation = "RV QC Value Table"."Value Table Name";
                    Editable = false;
                    Visible = false;
                }
                field("List Value"; Rec."List Value")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}