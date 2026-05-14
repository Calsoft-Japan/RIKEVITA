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
                    "QC Value" := QAInternalQCResults."QC Result";

                if QCParameter.Get("QC Parameter Name") then begin
                    QCValueTable.Reset();
                    QCValueTable.SetRange("Value Table Name");
                    if QCValueTable.FindFirst() then begin
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
        field(11; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.", "QC External Spec. Line No.")
        {
            Clustered = true;
        }
    }
}