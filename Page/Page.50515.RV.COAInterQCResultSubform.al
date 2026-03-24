/// <summary>
/// PAge RV COA InterQCResult Subform (ID 50515)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50515 "RV COA InterQCResult Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QA Internal QC Results";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                }
                field("COA Lot Line No."; Rec."COA Lot Line No.")
                {
                    ApplicationArea = All;
                }
                field("QC Internal Spec. Line No."; Rec."QC Internal Spec. Line No.")
                {
                    ApplicationArea = All;
                }

                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                }
                field("QC Result"; Rec."QC Result")
                {
                    ApplicationArea = All;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                }
                field("Alpha. Min"; Rec."Alpha. Min")
                {
                    ApplicationArea = All;
                }
                field("Alpha. Max"; Rec."Alpha. Max")
                {
                    ApplicationArea = All;
                }
                field("QC Checked Remark"; Rec."QC Checked Remark")
                {
                    ApplicationArea = All;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    var

}