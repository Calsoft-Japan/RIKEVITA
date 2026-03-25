/// <summary>
/// TableExtension RIKE User Setup (ID 50600) extends User Setup table
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
tableextension 50600 "RIKE User Setup" extends "User Setup"
{
    fields
    {
        field(50600; "RV Acc Highly Restricted BOM"; Boolean)
        {
            Caption = 'Access Highly Restricted BOM';
            Description = 'FDD014';
        }
        field(50100; "Allow Edit of Container No."; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Container No.';
            Description = 'FDD008';
        }
        field(50101; "Allow Edit of B/L Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of B/L Date';
            Description = 'FDD008';
        }
        field(50102; "Allow Edit of Closing Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Closing Date';
            Description = 'FDD008';
        }
        field(50103; "Allow Edit of Staffing Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Staffing Date';
            Description = 'FDD008';
        }

    }
}