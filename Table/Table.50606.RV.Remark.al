/// <summary>
/// Table RV Standard Remark (ID 50606).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50606 "RV Standard Remark"
{
    DataClassification = ToBeClassified;
    LookupPageId = "RV Standard Remark";

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Remark Type"; Enum "RV Remark Type")
        {
            Caption = 'Remark Type';
            DataClassification = ToBeClassified;
        }
        field(3; Remark; Text[150])
        {
            Caption = 'Remark';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code, "Remark Type")
        {
            Clustered = true;
        }
    }
}