/// <summary>
/// TableExtension Warehouse Shipment Header Ext (ID 50102) extends "Warehouse Shipment Header" table
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
tableextension 50102 "Warehouse Shipment Header Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50100; "RV_B/L Date"; Date)
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
                            WhsShtLine."RV_B/L Date" := "RV_B/L Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50101; "RV_Cosing Date"; Date)
        {
            Caption = 'Cosing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhsShtLine: Record "Warehouse Shipment Line";
                RVSteup: Record "RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);
                RVSteup.Reset();
                if RVSteup.FindFirst() then begin
                    DateFormulaVar := RVSteup."Stuffing Date Calculation";
                end;
                if (Format(DateFormulaVar) <> '') then
                    "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Cosing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation

                WhsShtLine.Reset();
                WhsShtLine.SetRange("No.", "No.");
                if WhsShtLine.FindFirst() then
                    if Confirm('Do you want to update the related shipment lines with the same Cosing Date and Stuffing Date?') then begin
                        repeat
                            //WhsShtLine."RV_B/L Date" := "RV_B/L Date";
                            WhsShtLine."RV_Cosing Date" := "RV_Cosing Date";
                            WhsShtLine."RV_Stuffing Date" := "RV_Stuffing Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50102; "RV_Stuffing Date"; Date)
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
                            WhsShtLine."RV_Stuffing Date" := "RV_Stuffing Date";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50103; "RV_Country of Origin"; Text[50])
        {
            Caption = 'Country of Origin';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50104; RV_VIA; Text[50])
        {
            Caption = 'VIA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50105; "RV_Final Destination"; Text[50])
        {
            Caption = 'Final Destination';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50106; "RV_Feeder Vessel"; Text[50])
        {
            Caption = 'Feeder Vessel';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50107; "RV_Mother Vessel"; Text[50])
        {
            Caption = 'Mother Vessel';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50108; RV_ETD; Date)
        {
            Caption = 'ETD';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50109; RV_ETA; Date)
        {
            Caption = 'ETA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
    }
}
