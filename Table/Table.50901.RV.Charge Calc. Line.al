/// <summary>
/// Table RV Charge Calc. Line(ID 50901)
/// FDD009 2026/04/30: New. (Shawn)
/// </summary>
table 50901 "RV Charge Calc. Line"
{
    Caption = 'Charge Calc. Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';

            trigger OnLookup()
            var
                ChargeCalcHeader: Record "RV Charge Calc. Header";
                SalesLineView: Record "Sales line";
                SalesLineLookup: Record "Sales line";
                pagSalesLine: Page "Sales Lines";

                ChargeTypeBlankErr: Label 'Charge Type is blank!';

            begin

                ChargeCalcHeader.Get("Document No.");

                if ChargeCalcHeader."Charge Type" = Enum::"RV Charge Type"::" " then
                    Error(ChargeTypeBlankErr);

                Clear(pagSalesLine);
                SalesLineView.Reset();
                SalesLineView.SetRange("Document Type", Enum::"Sales Document Type"::Order);
                SalesLineView.SetRange(Type, Enum::"Sales Line Type"::Item);
                SalesLineView.SetRange("RV_Charge Type", ChargeCalcHeader."Charge Type");

                if Page.RunModal(Page::"Sales Lines", SalesLineView) = Action::LookupOK then begin

                    "Sales Order No." := SalesLineView."Document No.";
                    "Sales Order Line No." := SalesLineView."Line No.";
                    Modify();

                end;
            end;

        }
        field(4; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Sell-to Customer No."
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."No."
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(7; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Quantity"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(8; "Sales Unit of Measure Code"; Code[10])
        {
            Caption = 'Sales Unit of Measure Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Unit of Measure Code"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(9; "Quantity (KG)"; Decimal)
        {
            Caption = 'Quantity (KG)';
        }
        field(10; "01-COO"; Decimal)
        {
            Caption = '01-COO';
        }
        field(11; "02-FORWARDING"; Decimal)
        {
            Caption = '02-FORWARDING';
        }
        field(12; "03-FUMIGATION"; Decimal)
        {
            Caption = '03-FUMIGATION';
        }
        field(13; "04-HEALTH"; Decimal)
        {
            Caption = '04-HEALTH';
        }
        field(14; "05-PALLETIZING"; Decimal)
        {
            Caption = '05-PALLETIZING';
        }
        field(15; "06-PHYTO"; Decimal)
        {
            Caption = '06-PHYTO';
        }
        field(16; "07-STUFFING"; Decimal)
        {
            Caption = '07-STUFFING';
        }
        field(17; "08-TRANSPORT"; Decimal)
        {
            Caption = '08-TRANSPORT';
        }
        field(18; "09-REACH"; Decimal)
        {
            Caption = '09-REACH';
        }
        field(19; "99-OTHERS"; Decimal)
        {
            Caption = '99-OTHERS';
        }
        field(20; "FREIGHT"; Decimal)
        {
            Caption = 'FREIGHT';
        }
        field(21; "HTP Adjustment Price"; Decimal)
        {
            Caption = 'HTP Adjustment Price';
        }
        field(22; "Total Charge (KG)"; Decimal)
        {
            Caption = 'Total Charge (KG)';
        }
        field(23; "Unit Charge (KG)"; Decimal)
        {
            Caption = 'Unit Charge (KG)';
        }
        field(24; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Currency Code"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(25; "Order Unit Price"; Decimal)
        {
            Caption = 'Order Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Unit Price"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(26; "Order Unit Price (KG)"; Decimal)
        {
            Caption = 'Order Unit Price (KG)';
        }
        field(27; "Invoice Unit Price (KG)"; Decimal)
        {
            Caption = 'Invoice Unit Price (KG)';
        }
        field(28; "Final Charge (KG)"; Decimal)
        {
            Caption = 'Final Charge (KG)';
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }


}