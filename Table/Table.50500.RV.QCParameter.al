/// <summary>
/// Table RV QC Parameter (ID 50500)
///  2026/02/23: New. (Mike)
/// </summary>
table 50500 "RV QC Parameter"
{
    Caption = 'QC Parameter';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC Parameter List";
    fields
    {
        field(1; "Parameter Name"; Code[20])
        {
            Caption = 'Parameter Name';
            NotBlank = true;
        }
        field(2; "Parameter Description"; Text[100])
        {
            Caption = 'Parameter Description';
        }
        field(3; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
            FieldClass = FlowField;
            CalcFormula = lookup("RV QC Value Table".Type where("Value Table Name" = field("Value Table Name")));
            Editable = false;
        }
        field(4; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
            FieldClass = FlowField;
            CalcFormula = lookup("RV QC Value Table"."Value Table Type" where("Value Table Name" = field("Value Table Name")));
            Editable = false;
        }
        field(5; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
            TableRelation = "RV QC Value Table"."Value Table Name";
        }

    }
    keys
    {
        key(PK; "Parameter Name")
        {
            Clustered = true;
        }
    }
}