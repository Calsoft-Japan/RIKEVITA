/// <summary>
/// PageExtension RIKE User Setup (ID 50600) extends User Setup page
/// FDD014 2026/02/23: New. (Stephen)
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
    }
}