/// <summary>
/// PageExtension RIKE Firm Planned Prod. Order Lines (ID 50603) extends "Firm Planned Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50603 "RIKE FirmPlan ProdOrderLines" extends "Firm Planned Prod. Order Lines"
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
