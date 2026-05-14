/// <summary>
/// TableExtension RV Posted Whse Shipment Header (ID 50207) extends Posted Whse. Shipment Header table
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50207 "RV Posted Whse Shipment Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
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
        field(50206; "RV_VIA"; Text[50])
        {
            Caption = 'VIA';
            Description = 'FDD019';
            DataClassification = ToBeClassified;
        }
        field(50207; "RV_Feeder Vessel"; Text[50])
        {
            Caption = 'Feeder Vessel';
            Description = 'FDD019';
        }
        field(50208; "RV_Mother Vessel"; Text[50])
        {
            Caption = 'Mother Vessel';
            Description = 'FDD019';
        }
        field(50209; "RV_Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            Description = 'FDD008';
            TableRelation = "Country/Region";
        }
        field(50210; "RV_Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            Description = 'FDD008';
        }
        field(50211; "RV_SAILING ON OR ABOUT"; Date)
        {
            Caption = 'SAILING ON OR ABOUT';
            Description = 'FDD008';
        }
    }
}
