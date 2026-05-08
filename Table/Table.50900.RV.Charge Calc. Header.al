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
                        if recSalesLine.Get(Enum::"Sales Document Type"::Order, recCCLine."Sales Order No.", recCCLine."Sales Order Line No.") then begin
                            recCCLine.CalcFields("Currency Code");
                            if Rec."Invoice Currency Code" = recCCLine."Currency Code" then begin
                                recCCLine."Exch. Rate from Inv. Currency" := 1;
                                recCCLine.Modify();
                            end;
                        end;

                    until recCCLine.Next() = 0;
            end;
        }

        field(7; "Status"; Enum "RV Charge Calc. Status")
        {
            Caption = 'Status';

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

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var

        DeleteOnCompletedErr: Label 'Cannot delete the compeleted data.';


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

    end;

    trigger OnDelete()
    begin

        if Status = Enum::"RV Charge Calc. Status"::Completed then
            Error(DeleteOnCompletedErr);

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