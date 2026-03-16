/// <summary>
/// TableExtension Warehouse Shipment Line Exit (ID 50103) extends "Warehouse Shipment Line" table
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
tableextension 50103 "Warehouse Shipment Line Exit" extends "Warehouse Shipment Line"
{
    fields
    {
        field(50100; "RV_B/L Date"; Date)
        {
            Caption = 'B/L Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50101; "RV_Cosing Date"; Date)
        {
            Caption = 'Cosing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RVSteup: Record "RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);
                RVSteup.Reset();
                if RVSteup.FindFirst() then begin
                    DateFormulaVar := RVSteup."Stuffing Date Calculation";
                end;
                if Format(DateFormulaVar) = '' then
                    "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Cosing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation
            end;
        }
        field(50102; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50103; RV_ETA; Date)
        {
            Caption = 'ETA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50104; RV_ETD; Date)
        {
            Caption = 'ETD';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
    }
}
