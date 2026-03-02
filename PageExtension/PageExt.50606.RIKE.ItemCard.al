/// <summary>
/// PageExtension RIKE Item Card (ID 50606) extends "Item Card"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50606 "RIKE Item Card" extends "Item Card"
{
    actions
    {
        modify(BOMStructure)
        {
            trigger OnBeforeAction()
            var
                RIKEBOMCheck: Codeunit "RIKE Check BOM Access ";
                Item: Record Item;
            begin
                if Rec."Production BOM No." <> '' then
                    RIKEBOMCheck.CheckBOMAccess(Rec."Production BOM No.")
                else
                    if Item.Get(Rec."No.") then
                        RIKEBOMCheck.CheckBOMAccess(Item."Production BOM No.");
            end;
        }
    }
}
