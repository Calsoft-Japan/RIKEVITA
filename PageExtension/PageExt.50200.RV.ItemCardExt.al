/// <summary>
/// PageExtension RV_Item Card (ID 50200) extends "Item Card"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// PageExtension RV Item Card (ID 50606) extends "Item Card" Merge from 50606 to 50200, FDD014 2026/02/23: New. (Bobby.ji)
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50200 "RV Item Card" extends "Item Card"
{
    layout
    {
        addafter("Expiration Calculation")
        {
            field("Expiration Base Date (RM)"; Rec."RV Expiration Base Date (RM)")
            {
                Caption = 'Expiration Base Date (RM)';
                ApplicationArea = all;
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
