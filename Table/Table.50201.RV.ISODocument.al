/// <summary>
/// Table RV ISO Document (ID 50201).
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
table 50201 "RV ISO Document"
{
    Caption = 'RV ISO Document';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Report Code"; Code[50])
        {
            Caption = 'Report Code';
            Description = 'FDD020';
        }
        field(2; "Report Name"; Text[100])
        {
            Caption = 'Report Name';
            Description = 'FDD020';
        }
        field(3; "ISO Document No."; Text[50])
        {
            Caption = 'ISO Document No.';
            Description = 'FDD020';
        }
        field(4; "ISO Doc. Version No."; Text[50])
        {
            Caption = 'ISO Doc. Version No.';
            Description = 'FDD020';
        }
    }
    keys
    {
        key(PK; "Report Code")
        {
            Clustered = true;
        }
    }
}
