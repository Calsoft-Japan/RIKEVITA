/// <summary>
/// Codeunit RIKE Planning Worksheet Addtion Fields (ID 50201)
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
codeunit 50201 "RIKE Planning Worksheet Fields"
{
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnAfterCopyFromItem, '', false, false)]
    local procedure "Requisition Line_OnAfterCopyFromItem"(var RequisitionLine: Record "Requisition Line"; Item: Record Item; CurrentFieldNo: Integer)
    begin
        RequisitionLine."RV_Expiration Calculation" := Item."Expiration Calculation";
    end;


}
