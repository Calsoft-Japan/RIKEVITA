/// <summary>
/// Table RIKEVITA Setup (ID 50100).
/// FDD030 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// </summary>
table 50100 "RV RIKEVITA Setup"
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
        field(12; "QC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'QC No. Nos.';
            TableRelation = "No. Series";
        }
        field(13; "COA No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'COA No. Nos.';
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
