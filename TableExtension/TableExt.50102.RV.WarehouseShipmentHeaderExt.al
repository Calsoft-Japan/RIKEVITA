/// <summary>
/// TableExtension Warehouse Shipment Header Ext (ID 50102) extends "Warehouse Shipment Header" table
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
tableextension 50102 "RV Warehouse Shipment HDR Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50100; "RV B/L Date"; Date)
        {
            Caption = 'B/L Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhsShtLine: Record "Warehouse Shipment Line";
            begin
                WhsShtLine.Reset();
                WhsShtLine.SetRange("No.", "No.");
                if WhsShtLine.FindFirst() then
                    if Confirm('You have modified the field B/L Date. Do you want to update the line?') then begin
                        repeat
                            WhsShtLine."RV B/L Date" := "RV B/L Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50101; "RV Cosing Date"; Date)
        {
            Caption = 'Cosing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhsShtLine: Record "Warehouse Shipment Line";
                RVSteup: Record "RV RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);
                RVSteup.Reset();
                if RVSteup.FindFirst() then begin
                    DateFormulaVar := RVSteup."Stuffing Date Calculation";
                end;
                if (Format(DateFormulaVar) <> '') then
                    "RV Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV Cosing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation

                WhsShtLine.Reset();
                WhsShtLine.SetRange("No.", "No.");
                if WhsShtLine.FindFirst() then
                    if Confirm('Do you want to update the related shipment lines with the same Cosing Date and Stuffing Date?') then begin
                        repeat
                            //WhsShtLine."RV_B/L Date" := "RV_B/L Date";
                            WhsShtLine."RV Cosing Date" := "RV Cosing Date";
                            WhsShtLine."RV Stuffing Date" := "RV Stuffing Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50102; "RV Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhsShtLine: Record "Warehouse Shipment Line";
            begin
                WhsShtLine.Reset();
                WhsShtLine.SetRange("No.", "No.");
                if WhsShtLine.FindFirst() then
                    if Confirm('You have modified the field Stuffing Date. Do you want to update the line?') then begin
                        repeat
                            WhsShtLine."RV Stuffing Date" := "RV Stuffing Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50103; "RV Country of Origin"; Text[50])
        {
            Caption = 'Country of Origin';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50104; "RV VIA"; Text[50])
        {
            Caption = 'VIA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50105; "RV Final Destination"; Text[50])
        {
            Caption = 'Final Destination';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50106; "RV Feeder Vessel"; Text[50])
        {
            Caption = 'Feeder Vessel';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50107; "RV Mother Vessel"; Text[50])
        {
            Caption = 'Mother Vessel';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50108; "RV ETD"; Date)
        {
            Caption = 'ETD';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50109; "RV ETA"; Date)
        {
            Caption = 'ETA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
    }
}
