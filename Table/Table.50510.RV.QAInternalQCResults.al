/// <summary>
/// Table RV QA Internal QC Results (ID 50510)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50510 "RV QA Internal QC Results"
{
    Caption = 'QA Internal QC Results';
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
        field(3; "QC Internal Spec. Line No."; Integer)
        {
            Caption = 'QC Internal Spec. Line No.';
        }
        field(4; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
        }
        field(5; "QC Result"; Code[20])
        {
            Caption = 'QC Result';
        }
        field(6; "QC Type"; Enum "RV QC Type")
        {
            Caption = 'QC Type';
        }
        field(7; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
        field(8; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(9; "Alpha. Min"; Text[50])
        {
            Caption = 'Alpha. Min';
        }
        field(10; "Alpha. Max"; Text[50])
        {
            Caption = 'Alpha. Max';
        }
        field(11; "QC Checked Remark"; Text[150])
        {
            Caption = 'QC Checked Remark';
        }
        field(12; "QC Approved Remark"; Text[150])
        {
            Caption = 'QC Approved Remark';
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.", "QC Internal Spec. Line No.")
        {
            Clustered = true;
        }
    }

    var
}