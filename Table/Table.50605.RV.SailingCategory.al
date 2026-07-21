/// <summary>
/// Table RV Holding Category (ID 50605)
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50605 "RV Holding Category"
{
    DataClassification = ToBeClassified;
    LookupPageId = "RV Holding Category";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Holding Period Calculation"; DateFormula)
        {
            Caption = 'Holding Period Calculation';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
