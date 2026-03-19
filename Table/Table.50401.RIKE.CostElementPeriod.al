/// <summary>
/// Table RV Cost Element Period (ID 50401).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
table 50401 "Standard Cost Element Period"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])                  //Period code (e.g. 2026-Q1)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Effective Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Effective End Date"; Date)
        {
            DataClassification = ToBeClassified;
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

