/// <summary>
/// Table RV QC Group (ID 50503)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50503 "RV QC Group"
{
    Caption = 'QC Group';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC Group No."; Code[20])
        {
            Caption = 'QC Group No.';
            NotBlank = true;
        }
        field(2; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            NotBlank = true;
        }
        field(3; "Internal Specification"; Code[20])
        {
            Caption = 'Internal Specification';
            TableRelation = "RV QC Specification";
        }
        field(4; "External Specification"; Code[20])
        {
            Caption = 'External Specification';
            TableRelation = "RV QC Specification";
        }
    }
    keys
    {
        key(PK; "QC Group No.", "Effective Date")
        {
            Clustered = true;
        }
    }



}