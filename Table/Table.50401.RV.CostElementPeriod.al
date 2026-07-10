/// <summary>
/// Table Standard Cost Element Period (ID 50401).
/// FDD034 2026/03/19: New. (Vani)
/// FDD034 2026/07/10: Update. (Bobby) 
/// </summary>
table 50401 "Standard Cost Element Period"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[50])                  //Period code (e.g. 2026-Q1)
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
            Description = 'FDD034';
        }
        field(2; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
            Description = 'FDD034';
        }
        field(3; "Effective Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Effective Start Date';
            Description = 'FDD034';
        }
        field(4; "Effective End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Effective End Date';
            Description = 'FDD034';
        }
        field(5; "Current Period"; Boolean) //Added by Bobby on 2026/07/10
        {
            DataClassification = ToBeClassified;
            Caption = 'Current Period';
            Description = 'FDD034';
        }
        field(6; "Comment"; Text[250]) //Added by Bobby on 2026/07/10
        {
            DataClassification = ToBeClassified;
            Caption = 'Comment';
            Description = 'FDD034';
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

