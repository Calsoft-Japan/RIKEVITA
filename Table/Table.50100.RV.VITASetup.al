/// <summary>
/// Table RIKEVITA Setup (ID 50100).
/// FDD030 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// </summary>
table 50100 "RIKEVITA Setup"
{
    Caption = 'RIKEVITA Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            Description = 'FDD030';
        }
        field(2; "Notification Calculation"; Code[10])
        {
            Caption = 'Notification Calculation';
            Description = 'FDD030';
        }
        field(3; "Notify-to Email Address"; Text[50])
        {
            Caption = 'Notify-to Email Address';
            Description = 'FDD030';
        }
        field(4; "Stuffing Date Calculation"; DateFormula)
        {
            Caption = 'Stuffing Date Calculation';
            Description = 'FDD008';
        }
        field(5; "ACC Site Analysis Code"; Code[20])
        {
            Caption = 'ACC Site Analysis Code';
            Description = 'FDD034';
        }
        field(12; "IQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'IQC No. Nos.';
            TableRelation = "No. Series";
        }
        field(13; "COA No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'COA No. Nos.';
            TableRelation = "No. Series";
        }

        field(14; "FP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(15; "WIP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WIP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(16; "PQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PQC No. Nos.';
            TableRelation = "No. Series";
        }
        field(17; "FQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FQC No. Nos.';
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
