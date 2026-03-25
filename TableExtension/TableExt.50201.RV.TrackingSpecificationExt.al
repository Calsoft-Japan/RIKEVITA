/// <summary>
/// TableExtension RV_Tracking Specification (ID 50201) extends Tracking Specification table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
tableextension 50201 "RV Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        field(50200; "RV Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
            Description = 'FDD001';
        }
        field(50201; "RV Container No."; Code[20])
        {
            Caption = 'Container No.';
            Description = 'FDD008';
        }
    }
}
