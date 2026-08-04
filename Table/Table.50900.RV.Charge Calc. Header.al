/// <summary>
/// Table RV Charge Calc. Header(ID 50900)
/// FDD009 2026/04/30: New. (Shawn)
/// </summary>
table 50900 "RV Charge Calc. Header"
{
    Caption = 'Charge Calc. Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Description"; Text[250])
        {
            Caption = 'Description';
        }

        field(3; "Calculation Date"; Date)
        {
            Caption = 'Calculation Date';
        }

        field(4; "Calculated By"; Code[50])
        {
            Caption = 'Calculated By';
            TableRelation = "User Setup"."User ID";

        }

        field(5; "Charge Type"; Enum "RV Charge Type")
        {
            Caption = 'Charge Type';

            trigger OnValidate()
            begin
                if (xRec."Charge Type" <> "Charge Type") and ("Charge Type" = Enum::"RV Charge Type"::" ") then
                    Error(ChargeTypeBlankErr);
            end;
        }

        field(6; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency.Code;

            trigger OnValidate()
            var
                recCCLine: Record "RV Charge Calc. Line";
                recSalesLine: Record "Sales Line";
            begin
                recCCLine.SetRange("Document No.", "No.");
                if recCCLine.FindSet() then
                    repeat
                        recSalesLine.Get(Enum::"Sales Document Type"::Order, recCCLine."Sales Order No.", recCCLine."Sales Order Line No.");
                        recCCLine.CalcFields("Currency Code");
                        if Rec."Invoice Currency Code" = recCCLine."Currency Code" then begin
                            recCCLine."Exch. Rate from Inv. Currency" := 1;
                        end else begin
                            recCCLine."Exch. Rate from Inv. Currency" := 0;
                        end;
                        recCCLine.Modify();

                    until recCCLine.Next() = 0;
            end;
        }

        field(7; "Status"; Enum "RV Charge Calc. Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            begin
                if (xRec.Status = Enum::"RV Charge Calc. Status"::Completed) and (Rec.Status <> Enum::"RV Charge Calc. Status"::Completed) then begin
                    Error(ModifyOnCompletedErr);
                end;
                if (xRec.Status <> Enum::"RV Charge Calc. Status"::Completed) and (Rec.Status = Enum::"RV Charge Calc. Status"::Completed) then begin
                    Error(ChangeToCompletedErr);
                end;

            end;

        }

        field(8; "Need Re-Calc."; Boolean)
        {
            Caption = 'Need Re-Calc.';
        }

        field(9; LOB; Code[20])
        {
            Caption = 'LOB';
            TableRelation = Customer."No." where("RV_Charge Type" = field("Charge Type"));

            trigger OnValidate()
            var
                recCust: Record Customer;
            begin

                if LOB <> '' then begin
                    if "Charge Type" = Enum::"RV Charge Type"::" " then
                        Error(ChargeTypeBlankErr);
                end;

                if xRec.LOB <> LOB then begin
                    if recCust.Get(LOB) then begin
                        Validate("Invoice Currency Code", recCust."Currency Code");
                        Validate("HTP Adjustment Price", recCust."RV_HTP Adjustment Price");
                    end else begin
                        Validate("Invoice Currency Code", '');
                        Validate("HTP Adjustment Price", 0);
                    end;
                end;

            end;
        }

        field(11; "HTP Adjustment Price"; Decimal)
        {
            Caption = 'HTP Adjustment Price';
        }
        field(12; "01-COO"; Decimal)
        {
            Caption = '01-COO';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(13; "02-FORWARDING"; Decimal)
        {
            Caption = '02-FORWARDING';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(14; "03-FUMIGATION"; Decimal)
        {
            Caption = '03-FUMIGATION';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(15; "04-HEALTH"; Decimal)
        {
            Caption = '04-HEALTH';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(16; "05-PALLETIZING"; Decimal)
        {
            Caption = '05-PALLETIZING';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(17; "06-PHYTO"; Decimal)
        {
            Caption = '06-PHYTO';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(18; "07-STUFFING"; Decimal)
        {
            Caption = '07-STUFFING';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(19; "08-TRANSPORT"; Decimal)
        {
            Caption = '08-TRANSPORT';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(20; "09-REACH"; Decimal)
        {
            Caption = '09-REACH';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(21; "10-Label"; Decimal)
        {
            Caption = '10-Label';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(22; "11-OF"; Decimal)
        {
            Caption = '11-OF';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(23; "99-OTHERS"; Decimal)
        {
            Caption = '99-OTHERS';

            trigger OnValidate()
            begin
                CalcTotalCost();
            end;
        }
        field(24; "FREIGHT"; Decimal)
        {
            Caption = 'FREIGHT';
        }
        field(31; "Total Cost"; Decimal)
        {
            Caption = 'Cost';
        }
        field(32; "Total Quantity (KG)"; Decimal)
        {
            Caption = 'Quantity (KG)';
            FieldClass = FlowField;
            CalcFormula = sum("RV Charge Calc. Line"."Quantity (KG)" where("Document No." = field("No.")));
        }
        field(41; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(42; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            TableRelation = "Purch. Inv. Header"."Vendor Invoice No.";
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var

        ModifyOnCompletedErr: Label 'Cannot modify or delete the compeleted data.';
        ChangeToCompletedErr: Label 'Status will be Completed after Carry Out.';
        ChargeTypeBlankErr: Label 'Charge Type is blank!';


    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        RIKEVITASetup.Get();
        RIKEVITASetup.TestField("No. Series for Chg. Calc.");
        Rec."No." := NoSeries.GetNextNo(RIKEVITASetup."No. Series for Chg. Calc.");

        "Calculation Date" := WorkDate();
        "Calculated By" := UserId;
        "Need Re-Calc." := true;

    end;

    trigger OnModify()
    begin
        CheckStatusCompleted();

        if (xRec."Charge Type" <> Rec."Charge Type")
            or (xRec."LOB" <> Rec."LOB")
            or (xRec."Invoice Currency Code" <> Rec."Invoice Currency Code")
            or (xRec."HTP Adjustment Price" <> Rec."HTP Adjustment Price")
            or (xRec."01-COO" <> Rec."01-COO")
            or (xRec."02-FORWARDING" <> Rec."02-FORWARDING")
            or (xRec."03-FUMIGATION" <> Rec."03-FUMIGATION")
            or (xRec."04-HEALTH" <> Rec."04-HEALTH")
            or (xRec."05-PALLETIZING" <> Rec."05-PALLETIZING")
            or (xRec."06-PHYTO" <> Rec."06-PHYTO")
            or (xRec."07-STUFFING" <> Rec."07-STUFFING")
            or (xRec."08-TRANSPORT" <> Rec."08-TRANSPORT")
            or (xRec."09-REACH" <> Rec."09-REACH")
            or (xRec."10-Label" <> Rec."10-Label")
            or (xRec."11-OF" <> Rec."11-OF")
            or (xRec."99-OTHERS" <> Rec."99-OTHERS")
            or (xRec."FREIGHT" <> Rec."FREIGHT") then begin

            "Need Re-Calc." := true;

        end;
    end;

    trigger OnDelete()
    begin
        CheckStatusCompleted();
    end;

    procedure CheckStatusCompleted()
    begin

        if xRec.Status = Enum::"RV Charge Calc. Status"::Completed then
            Error(ModifyOnCompletedErr);

    end;

    procedure ChargeLinesEditable() IsEditable: Boolean;
    begin

        IsEditable := Rec."Charge Type" <> Enum::"RV Charge Type"::" ";

    end;

    procedure CarryOutEnable() IsEditable: Boolean;
    begin

        IsEditable := rec.Status = Enum::"RV Charge Calc. Status"::WIP;

    end;

    procedure CalcTotalCost()
    begin
        "Total Cost" := "01-COO"
                        + "02-FORWARDING"
                        + "03-FUMIGATION"
                        + "04-HEALTH"
                        + "05-PALLETIZING"
                        + "06-PHYTO"
                        + "07-STUFFING"
                        + "08-TRANSPORT"
                        + "09-REACH"
                        + "10-Label"
                        + "11-OF"
                        + "99-OTHERS"; //Total amount of all charges except FREIGHT
    end;

}