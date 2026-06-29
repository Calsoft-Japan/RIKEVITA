/// <summary>
/// PageExtension RV_Sales Order Subform (ID 50620) extends "Sales Order"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>

pageextension 50621 "RV_Planning Components" extends "Planning Components"
{
    var
        RVBOMCheck: Codeunit "RV Check BOM Access ";
        RequisitionLine: Record "Requisition Line";
        Item: Record Item;

    trigger OnOpenPage()
    begin
        if RequisitionLine.Get(Rec."Worksheet Template Name",
                                Rec."Worksheet Batch Name",
                                Rec."Worksheet Line No.") then begin
            if RequisitionLine."Production BOM No." <> '' then
                RVBOMCheck.CheckBOMAccess(RequisitionLine."Production BOM No.")
            else
                if Item.Get(RequisitionLine."No.") then
                    RVBOMCheck.CheckBOMAccess(Item."Production BOM No.");
        end;
    end;
}
