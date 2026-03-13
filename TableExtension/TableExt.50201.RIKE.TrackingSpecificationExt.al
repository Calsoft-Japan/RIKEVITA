/// <summary>
/// TableExtension RV_Tracking Specification (ID 50201) extends Tracking Specification table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
tableextension 50201 "RV_Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        field(50200; "RV_Manufacture Date"; Date)
        {
            Description = 'FDD001';
        }
    }
}
