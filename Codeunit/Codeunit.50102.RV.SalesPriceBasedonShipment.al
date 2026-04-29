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
        PriceCalculation: Interface "Price Calculation";
    begin
        if SalesLine.FindSet(true) then
            repeat
                SalesLine."Shipment Date" := SalesHeader."Shipment Date";
                SalesLine.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

                SalesLine.ApplyPrice(SalesLine.FieldNo("Shipment Date"), PriceCalculation);
                SalesLine.Validate("Unit Price");
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;

}
