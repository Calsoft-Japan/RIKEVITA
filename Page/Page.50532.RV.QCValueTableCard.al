/// <summary>
/// Page RV QC Value Table Card (ID 50532)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50532 "RV QC Value Table Card"
{
    Caption = 'QC Value Table';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "RV QC Value Table";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Value Table Name"; Rec."Value Table Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = ValueTableTypeEnable;
                    trigger OnValidate()
                    var
                        QCListValue: Record "RV QC List Value";
                    begin
                        Rec.SetQCEnable(LineEnable, ValueEnable, TypeEnable, ValueTableTypeEnable);
                        if (xRec."Value Table Type" <> Rec."Value Table Type") then begin
                            QCListValue.Reset();
                            QCListValue.SetRange("Value Table Name", Rec."Value Table Name");
                            QCListValue.DeleteAll();
                        end;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = TypeEnable;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                    Editable = ValueEnable;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                    Editable = ValueEnable;
                }
            }
            part(SubLine; "RV QC List Value Subform")
            {
                Caption = 'List Value';
                ApplicationArea = All;
                SubPageLink = "Value Table Name" = field("Value Table Name");
                UpdatePropagation = Both;
                Visible = LineEnable;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetQCEnable(LineEnable, ValueEnable, TypeEnable, ValueTableTypeEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQCEnable(LineEnable, ValueEnable, TypeEnable, ValueTableTypeEnable);
    end;

    var
        LineEnable: Boolean;
        ValueEnable: Boolean;
        TypeEnable: Boolean;
        ValueTableTypeEnable: Boolean;
}




