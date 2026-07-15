/// <summary>
/// pageextension Sales Invoice Subform Ext (ID 50119) extends "Sales Invoice Subform" page
/// FDD007 2026/07/14: New. (Liuyang)
/// </summary>
pageextension 50119 "RV Sales Invoice Subform" extends "Sales Invoice Subform"
{
    actions
    {
        addfirst("&Line")
        {
            action(UpdatePrice)
            {
                ApplicationArea = All;
                Image = Price;
                //Ellipsis = true;
                Caption = 'Update Unit Pirce';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";//FDD007
                    SalesLine: Record "Sales Line";
                    WhseShptLine: Record "Warehouse Shipment Line";//FDD007
                    PriceCalculation: Interface "Price Calculation";//FDD007
                begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange(Type, "Sales Line Type"::Item);
                    SalesLine.SetFilter("No.", '<>""');
                    if SalesLine.FindSet(true) then begin
                        repeat
                            SalesHeader.Reset();
                            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");

                            WhseShptLine.Reset();
                            WhseShptLine.SetRange("Source Type", Database::"Sales Line");
                            WhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                            WhseShptLine.SetRange("Source No.", SalesHeader."No.");
                            WhseShptLine.SetRange("Source Line No.", SalesLine."Line No.");
                            if WhseShptLine.FindSet() then begin
                                SalesLine."Shipment Date" := WhseShptLine."Shipment Date";

                                SalesLine.GetPriceCalculationHandler("Price Type"::Sale, SalesHeader, PriceCalculation);

                                SalesLine.ApplyPrice(SalesLine.FieldNo("Shipment Date"), PriceCalculation);
                                SalesLine.Validate("Unit Price");
                                SalesLine.Modify();
                            end
                            else
                                Error(StrSubstNo('There is no shipment info for line %1, %2.', SalesLine."No.", SalesLine."Line No."));
                        until SalesLine.Next() = 0;

                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}
