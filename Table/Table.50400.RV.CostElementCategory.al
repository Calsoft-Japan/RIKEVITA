/// <summary>
/// Table RV Cost Element Category (ID 50400).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
table 50400 "RIKE Cost Element Category"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            Description = 'FDD034';
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            Description = 'FDD034';
        }
        field(3; "Type"; Enum "RIKE Cost Element Category")
        {
            DataClassification = ToBeClassified;
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