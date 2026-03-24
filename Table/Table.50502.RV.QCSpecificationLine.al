/// <summary>
/// Table RV QC Specification Line (ID 50502)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50502 "RV QC Specification Line"
{
    Caption = 'QC Specification Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
        }
        field(2; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
        }

        field(3; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
            FieldClass = FlowField;
            CalcFormula = lookup("RV QC Parameter"."Value Table Type" where("Parameter Name" = field("QC Parameter Name")));
            Editable = false;
        }

        field(4; "Target Value ib Base UM"; Text[100])
        {
            Caption = 'Target Value ib Base UM';
        }
    }
    keys
    {
        key(PK; "QC Specification Name", "QC Parameter Name")
        {
            Clustered = true;
        }
    }



}