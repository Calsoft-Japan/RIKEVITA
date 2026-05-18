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
                    Editable = ListValueEnable;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                    Editable = CheckStatusEnable;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetQCEnable(ListValueEnable, CheckStatusEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetQCEnable(ListValueEnable, CheckStatusEnable);
    end;
    /*
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ExistingRec: Record "RV QC List Value";
        QCValueTable: Record "RV QC Value Table";
    begin
        if QCValueTable.Get(Rec."Value Table Name") then begin
            if (QCValueTable."Value Table Type" = QCValueTable."Value Table Type"::Single)
            or (QCValueTable."Value Table Type" = QCValueTable."Value Table Type"::table) then begin

                ExistingRec.SetRange("Value Table Name", Rec."Value Table Name");
                if not ExistingRec.IsEmpty() then
                    Error('When single and table, only one detail can be defined.');
            end;
        end;
    end;
    */

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update();
    end;



    procedure SetQCEnable(var ListValueEnable: Boolean; var CheckStatusEnable: Boolean)
    var
        ExistingRec: Record "RV QC List Value";
        QCValueTable: Record "RV QC Value Table";
    begin
        ListValueEnable := true;
        CheckStatusEnable := true;

        if Rec."List Value" = '' then begin
            if QCValueTable.Get(Rec."Value Table Name") then begin
                if (QCValueTable."Value Table Type" = QCValueTable."Value Table Type"::Single)
                or (QCValueTable."Value Table Type" = QCValueTable."Value Table Type"::table) then begin

                    ExistingRec.SetRange("Value Table Name", Rec."Value Table Name");
                    if not ExistingRec.IsEmpty() then begin
                        ListValueEnable := false;
                        CheckStatusEnable := false;
                    end;
                    // Error('When single and table, only one detail can be defined.');
                end;
            end;
        end;
    end;

    var
        ListValueEnable: Boolean;
        CheckStatusEnable: Boolean;
}