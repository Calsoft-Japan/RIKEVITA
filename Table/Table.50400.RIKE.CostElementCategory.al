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
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Raw Material","Package Material","Energy","Water","Process";
            OptionCaption = ' , Raw Material, Package Material, Energy, Water, Process';
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