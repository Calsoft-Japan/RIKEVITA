/// <summary>
/// TableExtension RIKE Production BOM Header (ID 50601) extends Production BOM Header table
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
tableextension 50601 "RIKE Production BOM Header" extends "Production BOM Header"
{
    fields
    {
        field(50600; "RIKE Highly Restricted BOM"; Boolean)
        {
            Caption = 'Highly Restricted BOM';
            Description = 'FDD014';
            DataClassification = ToBeClassified;
        }
    }
}
