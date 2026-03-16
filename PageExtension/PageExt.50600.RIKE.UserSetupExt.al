/// <summary>
/// PageExtension RIKE User Setup (ID 50600) extends User Setup page
/// FDD014 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// </summary>
pageextension 50600 "RIKE User Setup" extends "User Setup"
{
    layout
    {
        addafter("Service Invoice Posting Policy")
        {
            field("RIKE Acc Highly Restricted BOM"; rec."RIKE Acc Highly Restricted BOM")
            {
                ApplicationArea = All;
                Description = 'FDD014';
            }
        }

        addafter("User ID")
        {
            field("Allow Edit of Container No."; Rec."Allow Edit of Container No.")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of B/L Date"; Rec."Allow Edit of B/L Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of Closing Date"; Rec."Allow Edit of Closing Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
            field("Allow Edit of Staffing Date"; Rec."Allow Edit of Staffing Date")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
        }
    }
}