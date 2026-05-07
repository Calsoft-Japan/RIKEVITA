/// <summary>
/// Table RV QC Value Table (ID 50517)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50517 "RV QC List Value"
{
    Caption = 'List Value';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC List Value List";
    fields
    {
        field(10; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
            NotBlank = true;
        }
        field(20; "List Value"; Text[50])
        {
            Caption = 'List Value';
        }
        field(30; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
    }
    keys
    {
        key(PK; "Value Table Name", "List Value")
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