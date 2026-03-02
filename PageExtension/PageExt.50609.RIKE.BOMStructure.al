/// <summary>
/// PageExtension RIKE BOM Structure (ID 50609) extends "BOM Structure"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>

pageextension 50609 "RIKE BOM Structure" extends "BOM Structure"
{
    layout
    {
        modify(ItemFilter)
        {
            trigger OnBeforeValidate()
            var
                RIKEBOMCheck: Codeunit "RIKE Check BOM Access ";
                Item: Record Item;
            begin
                if Item.Get(ItemFilter) then
                    RIKEBOMCheck.CheckBOMAccess(Item."Production BOM No.");
            end;
        }
    }
}
