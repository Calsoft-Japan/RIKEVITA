/// <summary>
/// PAge RV IQC Subform (ID 50510)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50510 "RV IQC Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
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
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                }
                field("Value Table Type"; Rec."Value Table Type")
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