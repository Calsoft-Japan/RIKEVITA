/// <summary>
/// PAge RV RV COA ExterQCResult Subform (ID 50516)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50516 "RV COA ExterQCResult Subform"
{
    PageType = ListPart;
    ApplicationArea = All;

    UsageCategory = None;
    SourceTable = "RV QA External QC Results";
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
                field("QC External Spec. Line No."; Rec."QC External Spec. Line No.")
                {
                    ApplicationArea = All;
                }

                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                }
                field("QC Value"; Rec."QC Value")
                {
                    ApplicationArea = All;
                }
                field("COA Value"; Rec."COA Value")
                {
                    ApplicationArea = All;
                }
                field("Differ From QC Vaule"; Rec."Differ From QC Vaule")
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