/// <summary>
/// PageExtension Released Prod. Order Lines" (ID 50602) extends "Released Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50602 "RIKE Released Prod. Order Line" extends "Released Prod. Order Lines"
{
    actions
    {
        modify(Components)
        {
            trigger OnBeforeAction()
            var
                RIKEBOMCheck: Codeunit "RIKE Check BOM Access ";
            begin
                RIKEBOMCheck.CheckBOMAccess(Rec."Production BOM No.");
            end;
        }
    }
}
