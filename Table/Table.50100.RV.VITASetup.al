/// <summary>
/// Table RIKEVITA Setup (ID 50100).
/// FDD030 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)/// 
/// FDD009 2026/04/29: Charge Allocation fields Added. (Shawn)
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
        field(112; "IQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'IQC No. Nos.';
            TableRelation = "No. Series";
        }
        field(113; "COA No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'COA No. Nos.';
            TableRelation = "No. Series";
        }

        field(114; "FP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(115; "WIP Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WIP Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(116; "PQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PQC No. Nos.';
            TableRelation = "No. Series";
        }
        field(117; "FQC No. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FQC No. Nos.';
            TableRelation = "No. Series";
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
        field(22; "No. Series for Chg. Calc."; Code[20])
        {
            Description = 'FDD009';
            Caption = 'No. Series for Chg. Calc.';
            TableRelation = "No. Series".Code;
        }
        field(23; "01-COO"; Code[20])
        {
            Description = 'FDD009';
            Caption = '01-COO';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(24; "02-FORWARDING"; Code[20])
        {
            Description = 'FDD009';
            Caption = '02-FORWARDING';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(25; "03-FUMIGATION"; Code[20])
        {
            Description = 'FDD009';
            Caption = '03-FUMIGATION';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(26; "04-HEALTH"; Code[20])
        {
            Description = 'FDD009';
            Caption = '04-HEALTH';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(27; "05-PALLETIZING"; Code[20])
        {
            Description = 'FDD009';
            Caption = '05-PALLETIZING';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(28; "06-PHYTO"; Code[20])
        {
            Description = 'FDD009';
            Caption = '06-PHYTO';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(29; "07-STUFFING"; Code[20])
        {
            Description = 'FDD009';
            Caption = '07-STUFFING';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(30; "08-TRANSPORT"; Code[20])
        {
            Description = 'FDD009';
            Caption = '08-TRANSPORT';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(31; "09-REACH"; Code[20])
        {
            Description = 'FDD009';
            Caption = '09-REACH';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(32; "99-OTHERS"; Code[20])
        {
            Description = 'FDD009';
            Caption = '99-OTHERS';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(33; "Freight Charge Item No"; Code[20])
        {
            Description = 'FDD009';
            Caption = 'Freight Charge Item No';
            TableRelation = "Item"."No." where(Type = const("Non-Inventory"));
        }
        field(34; "HTP Adjustment"; Code[20])
        {
            Description = 'FDD009';
            Caption = 'HTP Adjustment';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
        }
        field(35; "Chg. Calc. UOM (KG)"; Code[10])
        {
            Description = 'FDD009';
            Caption = 'Chg. Calc. UOM (KG)';
            TableRelation = "Unit of Measure".Code;
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
