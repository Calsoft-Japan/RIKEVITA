/// <summary>
/// Codeunit RIKE Planning Worksheet Addtion Fields (ID 50201)
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
codeunit 50201 "RIKE Planning Worksheet Fields"
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
                RequisitionLine.RV_AvailableInMultipleVendor := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnAfterCarryOutReqLineAction, '', false, false)]
    local procedure "Req. Wksh.-Make Order_OnAfterCarryOutReqLineAction"(var RequisitionLine: Record "Requisition Line"; var PurchaseHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; var OrderCounter: Integer; var LineCount: Integer)
    var
        VendorSelection: Record "RIKE Vendor Selection";
        POHeader: Record "Purchase Header";
        POLines: Record "Purchase Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if RequisitionLine.RV_AvailableInMultipleVendor then begin
            VendorSelection.Reset();
            VendorSelection.SetRange("Item No.", RequisitionLine."No.");
            if VendorSelection.FindFirst() then begin
                repeat

                    POHeader.Reset();
                    POHeader.Init();
                    POHeader."Document Type" := POHeader."Document Type"::Order;
                    POHeader.Validate("Buy-from Vendor No.", VendorSelection."Vendor No.");
                    POHeader.TestNoSeries();
                    POHeader."No." := NoSeriesMgt.GetNextNo(POHeader.GetNoSeriesCode(), WorkDate());
                    POHeader."Order Date" := WorkDate();
                    POHeader."Posting Date" := WorkDate();
                    //POHeader."Dimension Set ID" := PurchaseHeader."Dimension Set ID";
                    POHeader.Insert();
                    /*
                                        PurchaseHeader.Init();
                                        PurchaseHeader.Validate("Buy-from Vendor No.", VendorSelection."Vendor No.");
                                        PurchaseHeader."No." := '';
                                        PurchaseHeader.Insert(true);
                    */

                    POLines.Init();
                    POLines."Document Type" := POLines."Document Type"::Order;
                    POLines."Document No." := POHeader."No.";
                    POLines."Line No." := 10000;
                    POLines.Validate("Buy-from Vendor No.", VendorSelection."Vendor No.");
                    POLines.Validate(Type, POLines.Type::Item);
                    POLines.Validate("No.", VendorSelection."Item No.");
                    POLines.Validate(Quantity, VendorSelection."Quantity to Order");
                    POLines.Validate("Unit of Measure", VendorSelection."Unit of Measure Code");
                    POLines."Dimension Set ID" := POHeader."Dimension Set ID";
                    POLines.Insert();

                until VendorSelection.Next() = 0;
            end;
        end;

    end;

}
