/// <summary>
/// Table RV Invy. Planning Line (ID 50408).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50418 "RV Invy. Planning Line"
{
    Caption = 'Inventory Planning Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Delivery Scheduling Name"; Code[10])
        {
            Caption = 'Demand Forecast Name';
            NotBlank = true;
            TableRelation = "RV Invy. Planning Name";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            autoIncrement = true;
        }
        field(3; VendorNo; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(4; "Vendor Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(6; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(7; "Site"; Code[20])
        {
            Caption = 'Site';
            TableRelation = "Dimension Value" where("Global Dimension No." = const(1));
        }
        field(8; "Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(9; "Date Type"; enum "RV Invy. Planning Data Type")
        {
            Caption = 'Date Type';
        }
        field(10; "Inventory Before Period"; decimal)
        {
            Caption = 'Inventory Before Period';
            DecimalPlaces = 0 : 5;
        }
        field(11; PIC; Text[50])
        {
            Caption = 'PIC';
        }
        field(101; "Date1 Quantity"; decimal)
        {
            Caption = 'Date1';
            DecimalPlaces = 0 : 5;
        }
        field(102; "Date2 Quantity"; decimal)
        {
            Caption = 'Date2';
            DecimalPlaces = 0 : 5;
        }
        field(103; "Date3 Quantity"; decimal)
        {
            Caption = 'Date3';
            DecimalPlaces = 0 : 5;
        }
        field(104; "Date4 Quantity"; decimal)
        {
            Caption = 'Date4';
            DecimalPlaces = 0 : 5;
        }
        field(105; "Date5 Quantity"; decimal)
        {
            Caption = 'Date5';
            DecimalPlaces = 0 : 5;
        }
        field(106; "Date6 Quantity"; decimal)
        {
            Caption = 'Date6';
            DecimalPlaces = 0 : 5;
        }
        field(107; "Date7 Quantity"; decimal)
        {
            Caption = 'Date7';
            DecimalPlaces = 0 : 5;
        }
        field(108; "Date8 Quantity"; decimal)
        {
            Caption = 'Date8';
            DecimalPlaces = 0 : 5;
        }
        field(109; "Date9 Quantity"; decimal)
        {
            Caption = 'Date9';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Date10 Quantity"; decimal)
        {
            Caption = 'Date10';
            DecimalPlaces = 0 : 5;
        }
        field(111; "Date11 Quantity"; decimal)
        {
            Caption = 'Date11';
            DecimalPlaces = 0 : 5;
        }
        field(112; "Date12 Quantity"; decimal)
        {
            Caption = 'Date12';
            DecimalPlaces = 0 : 5;
        }
        field(113; "Date13 Quantity"; decimal)
        {
            Caption = 'Date13';
            DecimalPlaces = 0 : 5;
        }
        field(114; "Date14 Quantity"; decimal)
        {
            Caption = 'Date14';
            DecimalPlaces = 0 : 5;
        }
        field(115; "Date15 Quantity"; decimal)
        {
            Caption = 'Date15';
            DecimalPlaces = 0 : 5;
        }
        field(116; "Date16 Quantity"; decimal)
        {
            Caption = 'Date16';
            DecimalPlaces = 0 : 5;
        }
        field(117; "Date17 Quantity"; decimal)
        {
            Caption = 'Date17';
            DecimalPlaces = 0 : 5;
        }
        field(118; "Date18 Quantity"; decimal)
        {
            Caption = 'Date18';
            DecimalPlaces = 0 : 5;
        }
        field(119; "Date19 Quantity"; decimal)
        {
            Caption = 'Date19';
            DecimalPlaces = 0 : 5;
        }
        field(120; "Date20 Quantity"; decimal)
        {
            Caption = 'Date20';
            DecimalPlaces = 0 : 5;
        }
        field(121; "Date21 Quantity"; decimal)
        {
            Caption = 'Date21';
            DecimalPlaces = 0 : 5;
        }
        field(122; "Date22 Quantity"; decimal)
        {
            Caption = 'Date22';
            DecimalPlaces = 0 : 5;
        }
        field(123; "Date23 Quantity"; decimal)
        {
            Caption = 'Date23';
            DecimalPlaces = 0 : 5;
        }
        field(124; "Date24 Quantity"; decimal)
        {
            Caption = 'Date24';
            DecimalPlaces = 0 : 5;
        }
        field(125; "Date25 Quantity"; decimal)
        {
            Caption = 'Date25';
            DecimalPlaces = 0 : 5;
        }
        field(126; "Date26 Quantity"; decimal)
        {
            Caption = 'Date26';
            DecimalPlaces = 0 : 5;
        }
        field(127; "Date27 Quantity"; decimal)
        {
            Caption = 'Date27';
            DecimalPlaces = 0 : 5;
        }
        field(128; "Date28 Quantity"; decimal)
        {
            Caption = 'Date28';
            DecimalPlaces = 0 : 5;
        }
        field(129; "Date29 Quantity"; decimal)
        {
            Caption = 'Date29';
            DecimalPlaces = 0 : 5;
        }
        field(130; "Date30 Quantity"; decimal)
        {
            Caption = 'Date30';
            DecimalPlaces = 0 : 5;
        }
        field(131; "Date31 Quantity"; decimal)
        {
            Caption = 'Date31';
            DecimalPlaces = 0 : 5;
        }
        field(132; "Date32 Quantity"; decimal)
        {
            Caption = 'Date32';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(Key1; "Delivery Scheduling Name", "Entry No.")
        {
            Clustered = true;
        }
        /*key(Key2; "Delivery Scheduling Name", "Item No.", "Location Code", "Forecast Date", "Component Forecast", "Variant Code")
        {
            SumIndexFields = "Forecast Quantity (Base)";
        }
        key(Key3; "Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code", "Variant Code")
        {
            SumIndexFields = "Forecast Quantity (Base)";
        }
        */
    }
}
