/// <summary>
/// Table RV_ISO Certificate Code (ID 50102).
/// FDD013 2026/03/19: New (Liuyang)
/// </summary>
table 50102 "RV_ISO Certificate Code"
{
    Caption = 'RV_ISO Certificate Code';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
