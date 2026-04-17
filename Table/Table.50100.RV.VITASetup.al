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
            TableRelation = Dimension.Code;
            Description = 'FDD034';
        }
        field(6; "QC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'QC No. Nos.';
            TableRelation = "No. Series";
        }
        field(7; "COA No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'COA No. Nos.';
            TableRelation = "No. Series";
        }
        field(8; "FP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(9; "WIP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WIP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(10; "Recipient Ref. Code"; Code[10])
        {
            Description = 'FDD017';
        }
        field(11; "MUFG PIC 1"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MUFG PIC 1 Email';
        }
        field(12; "MUFG PIC 2"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MUFG PIC 2 Email';
        }
        field(13; "MUFG PIC 3"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MUFG PIC 3 Email';
        }
        field(14; "MayBank PIC 1"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MayBank PIC 1 Email';
        }
        field(15; "MayBank PIC 2"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MayBank PIC 2 Email';
        }
        field(16; "MayBank PIC 3"; Text[80])
        {
            Description = 'FDD017';
            Caption = 'MayBank PIC 3 Email';
        }
        field(17; "Demostic Excel Template"; Blob)
        {
            Description = 'FDD017';
        }
        field(18; "Jompay Excel Template"; Blob)
        {
            Description = 'FDD017';
        }
        field(19; "GIRO Excel Template"; Blob)
        {
            Description = 'FDD017';
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
