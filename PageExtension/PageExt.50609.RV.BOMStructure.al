/// <summary>
/// PageExtension RV BOM Structure (ID 50609) extends "BOM Structure"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>

pageextension 50609 "RV BOM Structure" extends "BOM Structure"
{
    layout
    {
        modify(ItemFilter)
        {
            Description = 'FDD014';
            trigger OnBeforeValidate()
            var
                RVBOMCheck: Codeunit "RV Check BOM Access ";
                Item: Record Item;
            begin
                if Item.Get(ItemFilter) then
                    RVBOMCheck.CheckBOMAccess(Item."Production BOM No.");
            end;
        }
    }
}
