/// <summary>
/// PageExtension RIKE User Setup (ID 50600) extends User Setup page
/// FDD014 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// FDD039 2026/03/26: Add. "Allow QC Check" "Allow QC Approve"
///                         "Allow QA Check","RV_Allow QA Approve","RV_Allow QA Reject"(Mike)
/// </summary>
pageextension 50600 "RIKE User Setup" extends "User Setup"
{
    layout
    {
        addafter("Service Invoice Posting Policy")
        {
            field("RV_Acc Highly Restricted BOM"; rec."RV_Acc Highly Restricted BOM")
            {
                ApplicationArea = All;
                Description = 'FDD014';
            }
        }

        addafter("User ID")
        {
            field("Allow Edit of Container No."; Rec."RV_Allow Edit of Container No.")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of B/L Date"; Rec."RV_Allow Edit of B/L Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of Closing Date"; Rec."RV_Allow Edit of Closing Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of Staffing Date"; Rec."RV_Allow Edit of Stuffing Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow QC Check"; Rec."RV_Allow QC Check")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QC Approve"; Rec."RV_Allow QC Approve")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QC Reverse"; Rec."RV_Allow QC Reverse")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QA Check"; Rec."RV_Allow QA Check")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QA Approve"; Rec."RV_Allow QA Approve")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QA Reject"; Rec."RV_Allow QA Reject")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
            field("Allow QA Reverse"; Rec."RV_Allow QA Reverse")
            {
                ApplicationArea = All;
                Description = 'FDD039';
            }
        }
    }
}