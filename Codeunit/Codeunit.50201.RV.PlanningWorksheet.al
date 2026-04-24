/// <summary>
/// Codeunit RV Planning Worksheet Addtion Fields (ID 50201)
/// FDD001 2026/03/12: New. (Bobby.ji)
/// FDD002
/// </summary>
codeunit 50201 "RV Planning Worksheet Fields"
{
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnAfterCopyFromItem, '', false, false)]
    local procedure "Requisition Line_OnAfterCopyFromItem"(var RequisitionLine: Record "Requisition Line"; Item: Record Item; CurrentFieldNo: Integer)
    var
        ItemVendor: Record "Item Vendor";
    begin
        RequisitionLine."RV_Expiration Calculation" := Item."Expiration Calculation";//FDD001
        ItemVendor.Reset();
        ItemVendor.SetRange("Item No.", RequisitionLine."No.");
        if ItemVendor.FindSet() then begin
            if ItemVendor.Count > 1 then begin
                RequisitionLine."RV_AvailableInMultipleVendor" := true;
            end;
        end;
    end;

}
