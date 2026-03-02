/// <summary>
/// PageExtension RIKE Production BOM (ID 50601) extends Production BOM page
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50601 "RIKE Production BOM" extends "Production BOM"
{
    layout
    {
        addlast(General)
        {
            field("RIKE Highly Restricted BOM"; Rec."RIKE Highly Restricted BOM")
            {
                ApplicationArea = All;
                Description = 'FDD014';
            }
        }
    }

    trigger OnOpenPage()
    var
        RIKEBOMCheck: Codeunit "RIKE Check BOM Access ";
    begin
        RIKEBOMCheck.CheckBOMAccess(Rec."No.");
    end;

    trigger OnAfterGetRecord()
    var
        RIKEBOMCheck: Codeunit "RIKE Check BOM Access ";
    begin
        RIKEBOMCheck.CheckBOMAccess(Rec."No.");
    end;

    var
        PermissionErrorMsg: Label 'You do not have permission to access this Production BOM. Please contact the system administrator.';
}
