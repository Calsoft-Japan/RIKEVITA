/// <summary>
/// PageExtension RIKE Planning Worksheet (ID 50605) extends "Planning Worksheet"
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
pageextension 50605 "RIKE Planning Worksheet" extends "Planning Worksheet"
{
    actions
    {
        modify("BOM Level")
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
        modify(Components)
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
