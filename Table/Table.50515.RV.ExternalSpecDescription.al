/// <summary>
/// Table RV External Spec. Description (ID 50515)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50515 "RV External Spec. Description"
{
    Caption = 'External Spec. Description';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
            TableRelation = "RV QC Resource Group"."QC Resource Group No.";
            NotBlank = true;
        }
        field(2; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Specification Line"."QC Parameter Name"
                   WHERE("QC Specification Name" = FIELD("External Spec. Name"));
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(5; "External Spec. Name"; Code[20])
        {
            Caption = 'External Spec. Name';
            TableRelation = "RV QC Specification";
        }
        field(6; "Customer Description"; Text[100])
        {
            Caption = 'Customer Description';
        }
        field(7; "Characteristic Specification"; Text[100])
        {
            Caption = 'Characteristic Specification';
        }
        field(8; "Method"; Text[100])
        {
            Caption = 'Method';
        }
    }
    keys
    {
        key(PK; "QC Resource Group No.", "Customer No.", "Ship-to Code", "External Spec. Name")
        {
            Clustered = true;
        }
    }



}