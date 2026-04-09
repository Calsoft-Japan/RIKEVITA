/// <summary>
/// PageExtension RV Planning Worksheet (ID 50605) extends "Planning Worksheet"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50605 "RV Planning Worksheet" extends "Planning Worksheet"
{
    actions
    {
        modify("BOM Level")
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
        modify(Components)
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
