/// <summary>
/// PageExtension RIKE Finished Prod. Order Lines (ID 50604) extends "Finished Prod. Order Lines"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50604 "RIKE Finished ProdOrder Lines" extends "Finished Prod. Order Lines"
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
