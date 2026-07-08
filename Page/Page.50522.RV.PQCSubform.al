/// <summary>
/// PAge RV PQC Subform (ID 50522)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50522 "RV PQC Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Line";
    SourceTableView = where("QC Type" = filter(PQC));
    AutoSplitKey = true;
    DelayedInsert = true;
    InsertAllowed = false;
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
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SetQCLineEnable(TypeEnable, ValueTableTypeEnable);
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = TypeEnable;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = ValueTableTypeEnable;
                }
                field("QC Value"; Rec."QC Value")
                {
                    ApplicationArea = All;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Result 1"; Rec."QC Result 1")
                {
                    ApplicationArea = All;
                }
                field("QC Result 2"; Rec."QC Result 2")
                {
                    ApplicationArea = All;
                }
                field("Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetQCLineEnable(TypeEnable, ValueTableTypeEnable);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetQCLineEnable(TypeEnable, ValueTableTypeEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQCLineEnable(TypeEnable, ValueTableTypeEnable);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetQCLineEnable(TypeEnable, ValueTableTypeEnable);
    end;

    var
        TypeEnable: Boolean;
        ValueTableTypeEnable: Boolean;

}