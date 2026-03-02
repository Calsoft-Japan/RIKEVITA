/// <summary>
/// Table RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// </summary>
table 50100 "RIKEVITA Setup"
{
    Caption = 'RIKEVITA Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
