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

    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnCodeOnBeforeSetPurchOrderHeader, '', false, false)]
        local procedure "Req. Wksh.-Make Order_OnCodeOnBeforeSetPurchOrderHeader"(var Sender: Codeunit "Req. Wksh.-Make Order"; var RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
        var
            RecRequisitionLine: Record "Requisition Line";
            VendorSelection: Record "RV Vendor Selection";
            ReqLineReserve: Codeunit "Req. Line-Reserve";
            LineNo: Integer;
        begin
            RecRequisitionLine.Reset();
            RecRequisitionLine.SetAscending("Line No.", true);
            if RecRequisitionLine.FindLast() then begin
                LineNo := RecRequisitionLine."Line No.";
            end;

            if RequisitionLine.FindFirst() then begin
                repeat
                    if RequisitionLine."RV AvailableInMultipleVendor" then begin

                        VendorSelection.Reset();
                        VendorSelection.SetRange("Item No.", RequisitionLine."No.");
                        if VendorSelection.FindFirst() then begin
                            repeat
                                LineNo := LineNo + 10000;
                                RecRequisitionLine.Init();
                                RecRequisitionLine.TransferFields(RequisitionLine);
                                RecRequisitionLine."Line No." := LineNo;
                                RecRequisitionLine."RV AvailableInMultipleVendor" := false;
                                RecRequisitionLine.Validate("Vendor No.", VendorSelection."Vendor No.");
                                RecRequisitionLine.Validate(Quantity, VendorSelection."Quantity to Order");
                                RecRequisitionLine.Validate("Accept Action Message", true);
                                RecRequisitionLine."RV AvailableInMultipleVendor" := false;
                                RecRequisitionLine.Insert();

                                ReqLineReserve.TransferReqLineToReqLine(RequisitionLine, RecRequisitionLine, VendorSelection."Quantity to Order", false);
                            until VendorSelection.Next() = 0;

                            VendorSelection.FindSet();
                            VendorSelection.DeleteAll();
                        end;
                        RequisitionLine.Delete(true);
                    end;
                until RequisitionLine.Next() = 0;

                RecRequisitionLine.CopyFilters(RequisitionLine);
                //"Requisition Line".SetRange("No.", RecRequisitionLine."No.");
            end;
        end;

    */

}
