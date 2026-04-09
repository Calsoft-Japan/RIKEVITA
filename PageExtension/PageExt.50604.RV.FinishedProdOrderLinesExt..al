/// <summary>
/// PageExtension RV Finished Prod. Order Lines (ID 50604) extends "Finished Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50604 "RV Finished ProdOrder Lines" extends "Finished Prod. Order Lines"
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
