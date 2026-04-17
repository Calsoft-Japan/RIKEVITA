/// <summary>
/// Table RV QC Resource Group (ID 50503)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50503 "RV QC Resource Group"
{
    Caption = 'QC Resource Group';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC Resource Group List";
    fields
    {
        field(1; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
            NotBlank = true;
        }
        field(2; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
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
        key(PK; "QC Resource Group No.", "Effective Date")
        {
            Clustered = true;
        }
    }



}