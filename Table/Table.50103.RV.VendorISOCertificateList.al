/// <summary>
/// Table RV_Vendor ISO Certificate List (ID 50103).
/// FDD013 2026/03/19: New (Liuyang)
/// </summary>
table 50103 "RV_Vendor ISO Certificate List"
{
    Caption = 'RV_Vendor ISO Certificate List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(2; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(3; "ISO Certificate"; Code[20])
        {
            Caption = 'ISO Certificate';
            TableRelation = "RV_ISO Certificate Code".Code;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,"In-Active",Expired;
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(7; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key(PK; "Vendor No.", "ISO Certificate", Status, "Start Date")
        {
            Clustered = true;
        }
    }
}
