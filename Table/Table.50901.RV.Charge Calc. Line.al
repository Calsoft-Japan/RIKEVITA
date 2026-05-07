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

        }
        field(4; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            trigger OnValidate()
            var
                recCCHeader: Record "RV Charge Calc. Header";
                recSalesLine: Record "Sales Line";
            begin
                if recSalesLine.Get(Enum::"Sales Document Type"::Order, Rec."Sales Order No.", Rec."Sales Order Line No.") then begin
                    Rec.CalcFields("Currency Code");
                    if recCCHeader.Get(Rec."Document No.") then begin
                        if recCCHeader."Invoice Currency Code" = Rec."Currency Code" then begin
                            Rec."Exch. Rate from Inv. Currency" := 1;
                        end;
                    end;
                end;
            end;
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
        field(19; "10-Label"; Decimal)
        {
            Caption = '10-Label';
        }
        field(20; "11-OF"; Decimal)
        {
            Caption = '11-OF';
        }
        field(21; "99-OTHERS"; Decimal)
        {
            Caption = '99-OTHERS';
        }
        field(22; "FREIGHT"; Decimal)
        {
            Caption = 'FREIGHT';
        }
        field(23; "HTP Adjustment Price"; Decimal)
        {
            Caption = 'HTP Adjustment Price';
            FieldClass = FlowField;
            CalcFormula = lookup("RV Charge Calc. Header"."HTP Adjustment Price" where("No." = field("Document No.")));
        }
        field(24; "Total Charge (KG)"; Decimal)
        {
            Caption = 'Total Charge (KG)';
        }
        field(25; "Unit Charge (KG)"; Decimal)
        {
            Caption = 'Unit Charge (KG)';
        }
        field(26; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Currency Code"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(27; "Exch. Rate from Inv. Currency"; Decimal)
        {
            Caption = 'Exch. Rate from Inv. Currency';
        }
        field(28; "01-COO (Order Curr.)"; Decimal)
        {
            Caption = '01-COO (Order Curr.)';
        }
        field(29; "02-FORWARDING (Order Curr.)"; Decimal)
        {
            Caption = '02-FORWARDING (Order Curr.)';
        }
        field(30; "03-FUMIGATION (Order Curr.)"; Decimal)
        {
            Caption = '03-FUMIGATION (Order Curr.)';
        }
        field(31; "04-HEALTH (Order Curr.)"; Decimal)
        {
            Caption = '04-HEALTH (Order Curr.)';
        }
        field(32; "05-PALLETIZING (Order Curr.)"; Decimal)
        {
            Caption = '05-PALLETIZING (Order Curr.)';
        }
        field(33; "06-PHYTO (Order Curr.)"; Decimal)
        {
            Caption = '06-PHYTO (Order Curr.)';
        }
        field(34; "07-STUFFING (Order Curr.)"; Decimal)
        {
            Caption = '07-STUFFING (Order Curr.)';
        }
        field(35; "08-TRANSPORT (Order Curr.)"; Decimal)
        {
            Caption = '08-TRANSPORT (Order Curr.)';
        }
        field(36; "09-REACH (Order Curr.)"; Decimal)
        {
            Caption = '09-REACH (Order Curr.)';
        }
        field(37; "10-Label (Order Curr.)"; Decimal)
        {
            Caption = '10-Label (Order Curr.)';
        }
        field(38; "11-OF (Order Curr.)"; Decimal)
        {
            Caption = '11-OF (Order Curr.)';
        }
        field(39; "99-OTHERS (Order Curr.)"; Decimal)
        {
            Caption = '99-OTHERS (Order Curr.)';
        }
        field(40; "FREIGHT (Order Curr.)"; Decimal)
        {
            Caption = 'FREIGHT (Order Curr.)';
        }
        field(41; "Total Charge (KG) (Ord Curr.)"; Decimal)
        {
            Caption = 'Total Charge (KG) (Order Curr.)';
        }
        field(42; "HTP Adj. Price (Order Curr.)"; Decimal)
        {
            Caption = 'HTP Adj. Price (Order Curr.)';
        }
        field(43; "Unit Charge (KG) (Ord Curr.)"; Decimal)
        {
            Caption = 'Unit Charge (KG) (Order Curr.)';
        }
        field(44; "Order Unit Price"; Decimal)
        {
            Caption = 'Order Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Unit Price"
                                where("Document Type" = const(Order),
                                        "Document No." = field("Sales Order No."),
                                        "Line No." = field("Sales Order Line No.")));
        }
        field(45; "Order Unit Price (KG)"; Decimal)
        {
            Caption = 'Order Unit Price (KG)';
        }
        field(46; "Invoice Unit Price (KG)"; Decimal)
        {
            Caption = 'Invoice Unit Price (KG)';
        }
        field(47; "Invoice Amount (KG)"; Decimal)
        {
            Caption = 'Invoice Amount (KG)';
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure CalcBaseFields()
    var
        recCCHeader: Record "RV Charge Calc. Header";
        Item: Record Item;
        RVSetup: Record "RV RIKEVITA Setup";
        ItemOUM: Record "Item Unit of Measure";

    begin
        //set or check Line Exchange rate.
        recCCHeader.Get("Document No.");
        CalcFields("Currency Code");
        if recCCHeader."Invoice Currency Code" = "Currency Code" then begin
            "Exch. Rate from Inv. Currency" := 1;
        end else begin
            TestField("Exch. Rate from Inv. Currency");
        end;

        //set KG-related fields.
        RVSetup.Get();
        RVSetup.TestField("Chg. Calc. UOM (KG)");

        CalcFields("Item No.", "Sales Quantity", "Sales Unit of Measure Code", "Order Unit Price");
        TestField("Item No.");

        Item.Get("Item No.");
        ItemOUM.Get("Item No.", RVSetup."Chg. Calc. UOM (KG)");

        ItemOUM.TestField(Weight);

        if "Sales Unit of Measure Code" = RVSetup."Chg. Calc. UOM (KG)" then begin
            "Quantity (KG)" := "Sales Quantity";
            "Order Unit Price (KG)" := "Order Unit Price";
        end else begin
            "Quantity (KG)" := "Sales Quantity" * ItemOUM.Weight;
            "Order Unit Price (KG)" := "Order Unit Price" / ItemOUM.Weight;
        end;

    end;


}