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
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("COA Lot No."; Rec."COA Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC Internal Spec. Line No."; Rec."QC Internal Spec. Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Value"; Rec."QC Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alpha. Min"; Rec."Alpha. Min")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alpha. Max"; Rec."Alpha. Max")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked Remark"; Rec."QC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
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