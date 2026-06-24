table 50519 "RV QC Spec. List Value"
{
    Caption = 'List Value';
    DataClassification = CustomerContent;
    //LookupPageID = "RV QC Spec. List Value";
    fields
    {
        field(1; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
        }
        field(2; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
        }
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
