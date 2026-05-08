/// <summary>
/// Codeunit Sales Price Based on Shipment (ID 50102)
/// FDD007 2026/03/17: New. (Liuyang)
/// FDD007 2026/05/8: Modify the stuffing date updating logic(ZHAO)
/// </summary>
tableextension 50106 "RV Sales Line Ext." extends "Sales Line"
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
                Validate("Unit Price");
            end;
        }

        field(50100; "RV_B/L Date"; Date)
        {
            Caption = 'B/L Date';
            Description = 'FDD012';
            DataClassification = ToBeClassified;
        }
        field(50101; "RV_Cosing Date"; Date)
        {
            Caption = 'Cosing Date';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RVSteup: Record "RV RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);

                if Rec."RV_Cosing Date" = 0D then begin
                    validate("RV_Stuffing Date", 0D);
                end else begin
                    RVSteup.get();
                    DateFormulaVar := RVSteup."Stuffing Date Calculation";
                    if (Format(DateFormulaVar) <> '') then
                        Validate("RV_Stuffing Date", CalcDate('-' + Format(DateFormulaVar), "RV_Cosing Date"))//Stuffing Date = Closing Date - Stuffing Date Calculation
                    else
                        Validate("RV_Stuffing Date", "RV_Cosing Date")
                end;
            end;
        }

        field(50102; "RV_ETA"; Date)
        {
            Caption = 'ETA';
            Description = 'FDD012';
            DataClassification = ToBeClassified;
        }
        field(50103; "RV_ETD"; Date)
        {
            Caption = 'ETD';
            Description = 'FDD012';
            DataClassification = ToBeClassified;
        }
    }
}
