/// <summary>
/// TableExtension RV Production Order (ID 50602) extends Production Order table
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
tableextension 50603 "RV_Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50600; "RV_Planning Date"; Date)
        {
            Caption = 'Planning Date';
        }

        field(50601; "RV_Planning Status"; Enum "RV Planning Status")
        {
            Caption = 'Planning Status';
        }

        field(50602; "RV_Planning Controller"; Text[50])
        {
            Caption = 'Planning Controller';
        }
    }
}
