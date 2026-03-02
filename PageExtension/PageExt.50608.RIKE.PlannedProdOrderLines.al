/// <summary>
/// PageExtension RIKE Planned Prod. Order Lines (ID 50604) extends "Planned Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>

pageextension 50608 "RIKE Planned Prod. Order Lines" extends "Planned Prod. Order Lines"
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
