/// <summary>
/// TableExtension RV_Reservation Entry (ID 50203) extends Reservation Entry table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
tableextension 50203 "RV_Reservation Entry" extends "Reservation Entry"
{
    fields
    {
        field(50200; "RV_Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
            Description = 'FDD001';
        }
        field(50201; "RV_Container No."; Code[20])
        {
            Caption = 'Container No.';
            Description = 'FDD008';
        }
    }
}
