/// <summary>
/// PageExtension RV Item Card (ID 50606) extends "Item Card"
/// FDD014 2026/02/23: New. (Stephen)
/// FDD014 2026/07/28: Add field. (Stephen)
/// </summary>
pageextension 50606 "RV_Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field(RV_PIC; Rec."RV_PIC")
            {
                ApplicationArea = All;
                Caption = 'PIC';
                Description = 'FDDXXX';
            }
        }
    }
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
