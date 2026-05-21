/// <summary>
/// TableExtension RV Posted Whse Shipment Line (ID 50208) extends Posted Whse. Shipment Line table
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50208 "RV Posted Whse Shipment Line" extends "Posted Whse. Shipment Line"
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
        field(50201; "RV_Print RSPO No."; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD020';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."RV_Print RSPO No." WHERE("No." = FIELD("Item No.")));
        }
        field(50202; "RV_SI Received Date"; Date)
        {
            Caption = 'SI Received Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50200; "RV_Symbol Display Packing List"; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD019';
            FieldClass = FlowField;
            CalcFormula = Lookup("RV Item Symbol Setting"."Symbol Display Packing List" WHERE("Item Code" = FIELD("Item No.")));
        }
    }
}
