/// <summary>
/// Table RV QA External QC Results (ID 50511)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50511 "RV QA External QC Results"
{
    Caption = 'QA External QC Results';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
            TableRelation = "RV QA Header";
            NotBlank = true;
        }
        field(2; "COA Lot Line No."; Integer)
        {
            Caption = 'COA Lot Line No.';
        }
        field(3; "QC External Spec. Line No."; Integer)
        {
            Caption = 'QC External Spec. Line No.';
        }
        field(4; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
            trigger OnValidate()
            var
                QAInternalQCResults: Record "RV QA Internal QC Results";
                QCParameter: Record "RV QC Parameter";
                QCValueTable: Record "RV QC Value Table";
            begin
                QAInternalQCResults.Reset();
                QAInternalQCResults.SetRange("COA No.", "COA No.");
                QAInternalQCResults.SetRange("COA Lot Line No.", "COA Lot Line No.");
                QAInternalQCResults.SetRange("QC Parameter Name", "QC Parameter Name");
                if QAInternalQCResults.FindLast() then
                    "QC Value" := QAInternalQCResults."QC Value";

                if QCParameter.Get("QC Parameter Name") then begin
                    QCValueTable.Reset();
                    QCValueTable.SetRange("Value Table Name", QCParameter."Value Table Name");
                    if QCValueTable.FindFirst() then begin
                        "Value Table Type" := QCValueTable."Value Table Type";
                        Type := QCValueTable.Type;
                        "Value Table Name" := QCValueTable."Value Table Name";
                        "Alpha. Min" := QCValueTable."Minimum Value";
                        "Alpha. Max" := QCValueTable."Maximum Value";
                    end;
                end;
            end;
        }
        field(5; "QC Value"; Text[50])
        {
            Caption = 'QC Value';
        }
        field(6; "COA Value"; Text[50])
        {
            Caption = 'COA Value';
            TableRelation =
            if ("Value Table Type" = const("List")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Single")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Table")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"));

            trigger OnValidate()
            begin
                "Differ From QC Vaule" := "COA Value" <> "QC Value";
            end;
        }
        field(7; "Differ From QC Vaule"; Boolean)
        {
            Caption = 'Differ From QC Vaule';
        }
        field(9; "Alpha. Min"; Text[50])
        {
            Caption = 'Alpha. Min';
        }
        field(10; "Alpha. Max"; Text[50])
        {
            Caption = 'Alpha. Max';
        }
        field(13; "COA Lot No."; Code[30])
        {
            Caption = 'COA Lot No.';
        }
        field(100; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(101; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
        field(102; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
        }
        field(103; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot No.", "QC External Spec. Line No.")
        {
            Clustered = true;
        }
    }
}