/// <summary>
/// TableExtension Warehouse Shipment Header Ext (ID 50102) extends "Warehouse Shipment Header" table
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50102 "RV Warehouse Shipment HDR Ext" extends "Warehouse Shipment Header"
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
        field(50101; "RV_Closing Date"; Date)
        {
            Caption = 'Closing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhsShtLine: Record "Warehouse Shipment Line";
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

                WhsShtLine.Reset();
                WhsShtLine.SetRange("No.", "No.");
                if WhsShtLine.FindFirst() then
                    if Confirm('Do you want to update the related shipment lines with the same Cosing Date and Stuffing Date?') then begin
                        repeat
                            //WhsShtLine."RV_B/L Date" := "RV_B/L Date";
                            WhsShtLine."RV_Closing Date" := "RV_Closing Date";
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
        field(50103; "RV_Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50104; "RV_VIA"; Text[50])
        {
            Caption = 'VIA - Port';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50105; "RV_Final Destination"; Text[50])
        {
            Caption = 'Final Destination - Port';
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
        field(50108; "RV_ETD"; Date)
        {
            Caption = 'ETD';
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
                            WhsShtLine."RV_ETD" := "RV_ETD";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50109; "RV_ETA"; Date)
        {
            Caption = 'ETA';
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
                            WhsShtLine."RV_ETA" := "RV_ETA";
                            WhsShtLine.Modify();
                        until WhsShtLine.Next() = 0;
                    end;
            end;
        }
        field(50110; "RV_Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50111; "RV_SAILING ON OR ABOUT"; Date)
        {
            Caption = 'Sailing on Board - SOB';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50112; "RV_Shipping Type Code"; Enum "RV Shipping Type Code")
        {
            Caption = 'Shipping Type Code';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50113; "RV_Shipment Type"; Enum "RV Shipment Type")
        {
            Caption = 'Shipment Type';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50200; "RV_Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name';
            Description = 'FDD019';
        }
        field(50201; "RV_Consignee Address"; Text[100])
        {
            Caption = 'Consignee Address';
            Description = 'FDD019';
        }
        field(50202; "RV_Consignee Address 2"; Text[100])
        {
            Caption = 'Consignee Address 2';
            Description = 'FDD019';
        }
        field(50203; "RV_Consignee City"; Text[30])
        {
            Caption = 'Consignee City';
            Description = 'FDD019';
        }
        field(50204; "RV_Consignee Post Code"; Code[20])
        {
            Caption = 'Consignee Post Code';
            Description = 'FDD019';
        }
        field(50205; "RV_Consignee Country/Region"; Code[10])
        {
            Caption = 'Consignee Country/Region';
            Description = 'FDD019';
            TableRelation = "Country/Region";
        }

        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                WhseShptLine: Record "Warehouse Shipment Line";
            begin
                WhseShptLine.Reset();
                WhseShptLine.SetRange("No.", Rec."No.");
                if WhseShptLine.FindSet() then
                    repeat
                        WhseShptLine."Shipment Date" := Rec."Posting Date";
                        WhseShptLine.Modify();
                    until WhseShptLine.Next() = 0;
            end;
        }
    }

    trigger OnDelete()//FDD019
    var
        WarehousePackingInfo: Record "RV Warehouse Packing Info.";
    begin
        WarehousePackingInfo.Reset();
        WarehousePackingInfo.SetRange("Warehouse Shipment No.", Rec."No.");
        WarehousePackingInfo.SetFilter("Posted Whse. Shipment No.", '=%1', '');
        WarehousePackingInfo.DeleteAll();
    end;
}
