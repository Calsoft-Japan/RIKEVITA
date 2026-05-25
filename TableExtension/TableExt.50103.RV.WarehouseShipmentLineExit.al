/// <summary>
/// TableExtension Warehouse Shipment Line Exit (ID 50103) extends "Warehouse Shipment Line" table
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD020 2026/04/08: New. (Bobby.ji)
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50103 "RV Warehouse Shipment Ln Ext" extends "Warehouse Shipment Line"
{
    fields
    {
        field(50100; "RV_B/L Date"; Date)
        {
            Caption = 'B/L Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50101; "RV_Closing Date"; Date)
        {
            Caption = 'Closing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RVSteup: Record "RV RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);

                if Rec."RV_Closing Date" = 0D then begin
                    "RV_Stuffing Date" := 0D;
                end else begin
                    RVSteup.Reset();
                    if RVSteup.FindFirst() then begin
                        DateFormulaVar := RVSteup."Stuffing Date Calculation";
                    end;

                    if (Format(DateFormulaVar) <> '') then
                        "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Closing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation
                end;
            end;
        }
        field(50102; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50103; "RV_ETA"; Date)
        {
            Caption = 'ETA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50104; "RV_ETD"; Date)
        {
            Caption = 'ETD';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50200; "RV_Print RSPO No."; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD020';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."RV_Print RSPO No." WHERE("No." = FIELD("Item No.")));
        }
        field(50201; "RV_Symbol Display Packing List"; Boolean)
        {
            Caption = 'Symbol Display Packing List';
            Description = 'FDD019';
            FieldClass = FlowField;
            CalcFormula = Lookup("RV Item Symbol Setting"."Symbol Display Packing List" WHERE("Item Code" = FIELD("Item No.")));
        }
        field(50202; "RV_SI Received Date"; Date)
        {
            Caption = 'SI Received Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
    }
}
