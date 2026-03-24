/// <summary>
/// PageExtension RV Item List (ID 50607) extends "Item List"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50607 "RV Item List" extends "Item List"
{
    actions
    {
        modify(Structure)
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
