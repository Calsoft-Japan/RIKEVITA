/// <summary>
/// Codeunit Sales Price Based on Shipment (ID 50102)
/// FDD007 2026/03/17: New. (Liuyang)
/// </summary>
codeunit 50102 "RV Sales Price Based on Shpt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price", OnAfterGetDocumentDate, '', false, false)]
    local procedure UseDeliveryDateForPriceLookup(
            var DocumentDate: Date;
            SalesHeader: Record "Sales Header";
            SalesLine: Record "Sales Line")
    begin
        // Guard: only redirect when the line has a computed delivery date.
        // When Planned Delivery Date = 0D (date chain not yet calculated),
        // leave the standard DocumentDate (Order Date) in place so the
        // price lookup still succeeds.
        if SalesLine."Shipment Date" = 0D then
            exit;

        // Replace the standard Order Date with the Planned Delivery Date.
        // "Price Calculation Buffer Mgt.".SetFilters() will use this value
        // to filter Price List Lines by their Starting Date / Ending Date,
        // finding prices that are valid on the delivery date.
        DocumentDate := SalesLine."Shipment Date";
    end;


    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", OnAfterInsertLine, '', false, false)]
    local procedure "Sales-Get Shipment_OnAfterInsertLine"(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesShptLine2: Record "Sales Shipment Line"; TransferLine: Boolean; var SalesHeader: Record "Sales Header")
    var
        PriceCalculation: Interface "Price Calculation";
    begin
        SalesLine.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

        SalesLine.ApplyPrice(SalesLine.FieldNo("Shipment Date"), PriceCalculation);
        SalesLine.Validate("Unit Price");
        SalesLine.Modify();
    end; */


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", OnAfterCreateInvLines, '', false, false)]
    local procedure "Sales-Get Shipment_OnAfterCreateInvLines"(var Sender: Codeunit "Sales-Get Shipment"; var SalesShipmentLine2: Record "Sales Shipment Line"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; SalesShipmentHeader: Record "Sales Shipment Header")
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        PriceCalculation: Interface "Price Calculation";
    begin
        if SalesShipmentLine2.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Shipment No.", SalesShipmentLine2."Document No.");
                SalesLine.SetRange("Shipment Line No.", SalesShipmentLine2."Line No.");
                if SalesLine.FindSet(true) then begin
                    SalesLine."Shipment Date" := SalesShipmentLine2."Shipment Date";

                    PostedWhseShptLine.Reset();
                    PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
                    PostedWhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                    PostedWhseShptLine.SetRange("Source No.", SalesHeader."No.");
                    PostedWhseShptLine.SetRange("Source Line No.", SalesLine."Line No.");
                    PostedWhseShptLine.SetCurrentKey("Shipment Date");
                    PostedWhseShptLine.SetAscending("Shipment Date", false);
                    if PostedWhseShptLine.FindFirst() then
                        SalesLine."Shipment Date" := PostedWhseShptLine."Shipment Date";

                    SalesLine.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

                    SalesLine.ApplyPrice(SalesLine.FieldNo("Shipment Date"), PriceCalculation);
                    SalesLine.Validate("Unit Price");
                    SalesLine.Modify();
                end;
                SalesLine.SetRange("Shipment No.");//cancel filter for report repeat
                SalesLine.SetRange("Shipment Line No.");
            until SalesShipmentLine2.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        SalesLine: Record "Sales Line";//FDD007
        WhsShipment: Record "Warehouse Shipment Header";//FDD007
        WhseShptLine: Record "Warehouse Shipment Line";//FDD007
        //PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        PriceCalculation: Interface "Price Calculation";//FDD007
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        NeedReopen: Boolean;
    begin
        /*
        NeedReopen := (SalesHeader.Status = SalesHeader.Status::Released);
        if NeedReopen then
            ReleaseSalesDoc.Reopen(SalesHeader);
        
        if SalesHeader.Invoice = true then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, "Sales Line Type"::Item);
            SalesLine.SetFilter("Qty. to Invoice", '>0');
            if SalesLine.FindSet() then
                repeat
                    WhseShptLine.Reset();
                    WhseShptLine.SetRange("Source Type", Database::"Sales Line");
                    WhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                    WhseShptLine.SetRange("Source No.", SalesHeader."No.");
                    WhseShptLine.SetRange("Source Line No.", SalesLine."Line No.");
                    if WhseShptLine.FindSet() then begin
                        WhsShipment.Get(WhseShptLine."No.");
                        SalesLine."Shipment Date" := WhsShipment."Posting Date";

                        /* PostedWhseShptLine.Reset();
                        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
                        PostedWhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                        PostedWhseShptLine.SetRange("Source No.", SalesHeader."No.");
                        PostedWhseShptLine.SetRange("Source Line No.", SalesLine."Line No.");
                        PostedWhseShptLine.SetCurrentKey("Shipment Date");
                        PostedWhseShptLine.SetAscending("Shipment Date", false);
                        if PostedWhseShptLine.FindFirst() then
                            SalesLine."Shipment Date" := PostedWhseShptLine."Shipment Date"; */
        /*
        SalesLine.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

        SalesLine.ApplyPrice(SalesLine.FieldNo("Shipment Date"), PriceCalculation);
        SalesLine.Validate("Unit Price");
        SalesLine.Modify();
    end;
until SalesLine.Next() = 0;
end;
*/
        //if NeedReopen then
        //    SalesHeader.PerformManualRelease();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesLines, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesLines"(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var TempVATAmountLine: Record "VAT Amount Line" temporary; var EverythingInvoiced: Boolean)
    var
        WhsShipment: Record "Warehouse Shipment Header";//FDD007
        WhseShptLine: Record "Warehouse Shipment Line";//FDD007
        PriceCalculation: Interface "Price Calculation";//FDD007
    begin
        /* if TempSalesLineGlobal.FindSet() then
            repeat
                WhseShptLine.Reset();
                WhseShptLine.SetRange("Source Type", Database::"Sales Line");
                WhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                WhseShptLine.SetRange("Source No.", SalesHeader."No.");
                WhseShptLine.SetRange("Source Line No.", TempSalesLineGlobal."Line No.");
                if WhseShptLine.FindSet() then begin
                    WhsShipment.Get(WhseShptLine."No.");

                    TempSalesLineGlobal."Shipment Date" := WhsShipment."Posting Date";
                    TempSalesLineGlobal.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

                    TempSalesLineGlobal.ApplyPrice(TempSalesLineGlobal.FieldNo("Shipment Date"), PriceCalculation);
                    TempSalesLineGlobal.Validate("Unit Price");
                    TempSalesLineGlobal.Modify();
                end;
            until TempSalesLineGlobal.Next() = 0; */
    end;


}
