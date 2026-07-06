/// <summary>
/// Table RV QC Value Table (ID 50517)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50519 "RV Specification Value Setting"
{
    Caption = 'Specification Value Setting';
    DataClassification = CustomerContent;
    LookupPageID = "RV Specification Value Setting";
    fields
    {
        field(10; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
            TableRelation = "RV QC Specification";
        }
        field(20; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
        }
        field(30; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
        }
        field(35; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
        field(40; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(50; "List Value"; Text[50])
        {
            Caption = 'List Value';
        }
        field(60; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
    }
    keys
    {
        key(PK; "QC Specification Name", "QC Parameter Name", "Value Table Name", "List Value")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "List Value", "Check Status")
        {
        }
    }
}