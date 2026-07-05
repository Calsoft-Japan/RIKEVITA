/// <summary>
/// TableExtension RV User Setup (ID 50600) extends User Setup table
/// FDD014 2026/02/23: New. (Stephen)
/// FDD039 2026/03/26: Add. "Allow QC Check" "Allow QC Approve",
///                         "Allow QA Check","RV_Allow QA Approve","RV_Allow QA Reject"(Mike)
/// </summary>
tableextension 50600 "RV User Setup" extends "User Setup"
{
    fields
    {
        field(50500; "RV_Allow QC Check"; Boolean)
        {
            Caption = 'Allow QC Check';
            Description = 'FDD039';
        }
        field(50501; "RV_Allow QC Approve"; Boolean)
        {
            Caption = 'Allow QC Approve';
            Description = 'FDD039';
        }
        field(50502; "RV_Allow QA Check"; Boolean)
        {
            Caption = 'Allow QA Check';
            Description = 'FDD039';
        }
        field(50503; "RV_Allow QA Approve"; Boolean)
        {
            Caption = 'Allow QA Approve';
            Description = 'FDD039';
        }
        field(50504; "RV_Allow QA Reject"; Boolean)
        {
            Caption = 'Allow QA Reject';
            Description = 'FDD039';
        }
        field(50505; "RV_Allow QA Reverse"; Boolean)
        {
            Caption = 'Allow QA Reverse';
            Description = 'FDD039';
        }
        field(50506; "RV_Allow QC Reverse"; Boolean)
        {
            Caption = 'Allow QC Reverse';
            Description = 'FDD039';
        }
        field(50600; "RV_Acc Highly Restricted BOM"; Boolean)
        {
            Caption = 'Access Highly Restricted BOM';
            Description = 'FDD014';
        }
        field(50100; "RV_Allow Edit of Container No."; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Container No.';
            Description = 'FDD008';
        }
        field(50101; "RV_Allow Edit of B/L Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of B/L Date';
            Description = 'FDD008';
        }
        field(50102; "RV_Allow Edit of Closing Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Closing Date';
            Description = 'FDD008';
        }
        field(50103; "RV_Allow Edit of Stuffing Date"; Enum "RV EditPermission")
        {
            Caption = 'Allow Edit of Stuffing Date';
            Description = 'FDD008';
        }

    }
}