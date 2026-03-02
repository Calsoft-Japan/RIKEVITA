/// <summary>
/// TableExtension RIKE User Setup (ID 50600) extends User Setup table
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
tableextension 50600 "RIKE User Setup" extends "User Setup"
{
    fields
    {
        field(50600; "RIKE Acc Highly Restricted BOM"; Boolean)
        {
            Caption = 'Access Highly Restricted BOM';
            Description = 'FDD014';
        }
    }
}