/// <summary>
/// PageExtension RV Production BOM (ID 50601) extends Production BOM page
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50601 "RV Production BOM" extends "Production BOM"
{
    layout
    {
        addlast(General)
        {
            field("RV Highly Restricted BOM"; Rec."RV Highly Restricted BOM")
            {
                ApplicationArea = All;
                Description = 'FDD014';
            }
        }
    }

    trigger OnOpenPage()
    var
        RVBOMCheck: Codeunit "RV Check BOM Access ";
    begin
        RVBOMCheck.CheckBOMAccess(Rec."No.");
    end;

    trigger OnAfterGetRecord()
    var
        RVBOMCheck: Codeunit "RV Check BOM Access ";
    begin
        RVBOMCheck.CheckBOMAccess(Rec."No.");
    end;

    var
        PermissionErrorMsg: Label 'You do not have permission to access this Production BOM. Please contact the system administrator.';
}
