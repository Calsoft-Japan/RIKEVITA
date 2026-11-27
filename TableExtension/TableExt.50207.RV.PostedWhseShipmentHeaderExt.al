/// <summary>
/// TableExtension RV Posted Whse Shipment Header (ID 50207) extends Posted Whse. Shipment Header table
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50207 "RV Posted Whse Shipment Header" extends "Posted Whse. Shipment Header"
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

        }
        field(50102; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            Description = 'FDD008';
            DataClassification = ToBeClassified;

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
            Description = 'FDD019';
        }
        field(50107; "RV_Mother Vessel"; Text[50])
        {
            Caption = 'Mother Vessel';
            Description = 'FDD019';
        }
        field(50108; "RV_ETD"; Date)
        {
            Caption = 'ETD';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
        }
        field(50109; "RV_ETA"; Date)
        {
            Caption = 'ETA';
            Description = 'FDD008';
            DataClassification = ToBeClassified;
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
        field(50206; "RV_AdditionalLabelRequirement"; Text[250])
        {
            Caption = 'Additional Label Requirement';
        }
        field(50207; "RV_Palletize Type"; Enum "RV Palletize Type")
        {
            Caption = 'Palletize Type';
        }
        field(50208; "RV_No. of Pallet"; Integer)
        {
            Caption = 'No. of Pallet';
        }
        field(50209; "RV_MAFAS"; Boolean)
        {
            Caption = 'MAFAS';
        }
        field(50210; "RV_Wooden Frame"; Boolean)
        {
            Caption = 'Wooden Frame';
        }
        field(50211; "RV_AdditionalRequestBasedOnSI"; Text[250])
        {
            Caption = 'Additional Request Based On SI';
        }
        field(50212; "RV_Fresh Lot No."; Boolean)
        {
            Caption = 'Fresh Lot No.';
        }
        field(50213; "RV_Maximum Lot No."; Integer)
        {
            Caption = 'Maximum Lot No.';
        }
        field(50214; "RV_AFAS"; Boolean)
        {
            Caption = 'AFAS';
        }
        field(50215; "RV_Container Fumigation"; Boolean)
        {
            Caption = 'Container Fumigation';
        }
        field(50216; "RV_Plastic Wall (Reefer)"; Boolean)
        {
            Caption = 'Plastic Wall (Reefer)';
        }
        field(50217; "RV_Container Liner (Blanket)"; Boolean)
        {
            Caption = 'Container Liner (Blanket)';
        }
        field(50218; "RV_Drawback"; Boolean)
        {
            Caption = 'Drawback';
        }
    }
}
