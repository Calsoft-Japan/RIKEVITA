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
}
