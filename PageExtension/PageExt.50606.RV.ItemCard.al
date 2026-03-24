/// <summary>
/// PageExtension RV Item Card (ID 50606) extends "Item Card"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50606 "RV Item Card" extends "Item Card"
{
    actions
    {
        modify(BOMStructure)
        {
            Description = 'FDD014';
            trigger OnBeforeAction()
            var
                RVBOMCheck: Codeunit "RV Check BOM Access ";
                Item: Record Item;
            begin
                if Rec."Production BOM No." <> '' then
                    RVBOMCheck.CheckBOMAccess(Rec."Production BOM No.")
                else
                    if Item.Get(Rec."No.") then
                        RVBOMCheck.CheckBOMAccess(Item."Production BOM No.");
            end;
        }
    }
}
