/// <summary>
/// Table RIKE Resource QC Group (ID 50504)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50504 "RIKE Resource QC Group"
{
    Caption = 'Resource QC Group';
    DataClassification = CustomerContent;
    fields
    {

        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
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
        field(4; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
            FieldClass = FlowField;
            CalcFormula = lookup("Ship-to Address"."Country/Region Code" where("Customer No." = field("Customer No."), "Code" = field("Ship-to Code")));
            Editable = false;
        }
        field(5; "QC Group No."; Code[20])
        {
            Caption = 'QC Group No.';
            TableRelation = "RIKE QC Group"."QC Group No.";
        }
    }
    keys
    {
        key(PK; "Item No.", "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }



}