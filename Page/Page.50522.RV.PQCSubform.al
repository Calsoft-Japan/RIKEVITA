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