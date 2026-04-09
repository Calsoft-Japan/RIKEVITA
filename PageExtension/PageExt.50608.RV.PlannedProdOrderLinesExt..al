/// <summary>
/// PageExtension RV Planned Prod. Order Lines (ID 50604) extends "Planned Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>

pageextension 50608 "RV Planned Prod. Order Lines" extends "Planned Prod. Order Lines"
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
