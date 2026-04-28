/// <summary>
/// TableExtension RV Production Order (ID 50602) extends Production Order table
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
tableextension 50602 "RV_Production Order" extends "Production Order"
{
    fields
    {
        field(50600; "RV_Planning Date"; Date)
        {
            Caption = 'Planning Date';
            DataClassification = ToBeClassified;
        }

        field(50601; "RV_Planning Status"; Enum "RV Planning Status")
        {
            Caption = 'Planning Status';
            DataClassification = ToBeClassified;
        }

        field(50602; "RV_Planning Controller"; Text[50])
        {
            Caption = 'Planning Controller';
            DataClassification = ToBeClassified;
        }

        field(50603; "RV_Rescheduling Starting Date"; DateTime)
        {
            Caption = 'Rescheduling Starting Date';
            DataClassification = ToBeClassified;
        }

        field(50604; "RV_Rescheduling Ending Date"; DateTime)
        {
            Caption = 'Rescheduling Ending Date';
            DataClassification = ToBeClassified;
        }
    }
}
