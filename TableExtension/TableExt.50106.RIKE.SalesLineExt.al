/// <summary>
/// Codeunit Sales Price Based on Shipment (ID 50102)
/// FDD007 2026/03/17: New. (Liuyang)
/// </summary>
tableextension 50106 "Sales Line Ext." extends "Sales Line"
{
    fields
    {
        modify("Shipment Date")//FDD007
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                PriceCalculation: Interface "Price Calculation";
            begin
                // Only recalculate for Item lines that have an item number.
                if (Type <> Type::Item) or ("No." = '') then
                    exit;

                // Only recalculate if the date actually changed.
                if "Shipment Date" = xRec."Shipment Date" then
                    exit;

                // GetPriceCalculationHandler requires 3 parameters in BC 27:
                //   PriceType   : "Price Type"::Sale
                //   SalesHeader : the parent Sales Header record
                //   PriceCalculation : the resolved interface (out param)
                SalesHeader.Get("Document Type", "Document No.");
                GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

                // ApplyPrice requires 2 parameters:
                //   CalledByFieldNo : the field that triggered recalculation
                //   PriceCalculation : the resolved interface
                // The OnAfterGetDocumentDate subscriber in the companion codeunit
                // intercepts this call and substitutes Planned Delivery Date as
                // the effective date for the Price List Line date filter.
                ApplyPrice(FieldNo("Shipment Date"), PriceCalculation);
            end;
        }
    }
}
