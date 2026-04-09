/// <summary>
/// PageExtension RV Firm Planned Prod. Order Lines (ID 50603) extends "Firm Planned Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50603 "RV FirmPlan ProdOrderLines" extends "Firm Planned Prod. Order Lines"
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
