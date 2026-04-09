/// <summary>
/// PageExtension Released Prod. Order Lines" (ID 50602) extends "Released Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50602 "RV Released Prod. Order Line" extends "Released Prod. Order Lines"
{
    actions
    {
        modify(Components)
        {
            Description = 'FDD014';
            trigger OnBeforeAction()
            var
                RVBOMCheck: Codeunit "RV Check BOM Access ";
            begin
                RVBOMCheck.CheckBOMAccess(Rec."Production BOM No.");
            end;
        }
    }
}
