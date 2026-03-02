/// <summary>
/// PageExtension RIKE Item List (ID 50607) extends "Item List"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50607 "RIKE Item List" extends "Item List"
{
    actions
    {
        modify(Structure)
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
