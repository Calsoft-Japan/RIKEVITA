/// <summary>
/// Table RV QC Customer External Spec. (ID 50504)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50504 "RV QC Customer External Spec."
{
    Caption = 'QC Customer External Spec.';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC Customer External Spec.";
    fields
    {
        field(1; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
            TableRelation = "RV QC Resource Group"."QC Resource Group No.";
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(4; "External Specification"; Code[20])
        {
            Caption = 'External Specification';
            TableRelation = "RV QC Specification";
        }
    }
    keys
    {
        key(PK; "QC Resource Group No.", "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }



}