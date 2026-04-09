/// <summary>
/// PAge RV FQC Subform (ID 50526)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50526 "RV FQC Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Line";
    SourceTableView = where("QC Type" = filter(FQC));
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Result"; Rec."QC Result")
                {
                    ApplicationArea = All;
                }
                field("Check Status"; Rec."Check Status")
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