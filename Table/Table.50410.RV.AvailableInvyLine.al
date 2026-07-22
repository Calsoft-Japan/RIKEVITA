table 50410 "RV.Available Invy. Line"
{
    Caption = 'Available Invy. Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Available Invy. Name"; Code[10])
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
        field(3; "Calculating Base Date"; Date)
        {
            Caption = 'Calculating Base Date';
        }

        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(5; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(6; "Item Description 2"; Text[100])
        {
            Caption = 'Item Description 2';
        }

        field(7; "Site"; Code[20])
        {
            Caption = 'Site';
            TableRelation = "Dimension Value" where("Global Dimension No." = const(1));
        }
        field(8; "Segment"; Code[20])
        {
            Caption = 'Segment';
            TableRelation = "Dimension Value" where("Global Dimension No." = const(2));
        }
        field(10; "Location"; Code[10])
        {
            Caption = 'Location';
            TableRelation = "Location";
        }
        field(11; "Bin Code"; Code[10])
        {
            Caption = 'Bin Code';
            TableRelation = "Bin" where("Location Code" = Field("Location"));
        }

        field(12; "Classification"; Code[30])
        {
            Caption = 'Classification';
        }
        field(13; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(14; "Sub Lot No."; Code[30])
        {
            Caption = 'Sub Lot No.';
        }
        field(15; "Mfg. Date"; Date)
        {
            Caption = 'Mfg. Date';
        }
        field(16; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }

        field(17; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(18; "Item Type"; Code[20])
        {
            Caption = 'Item Type';
            //TableRelation = "Dimension Value";
        }
        field(19; "RSPO"; Boolean)
        {
            Caption = 'RSPO';
        }
        field(20; "Allergen"; Boolean)
        {
            Caption = 'Allergen';
        }
        field(9; "Derive Unit of Measure"; Code[10])
        {
            Caption = 'Derive Unit of Measure';
            TableRelation = "Unit of Measure";
        }

        field(101; "Base Unit Invy. Qty."; decimal)
        {
            Caption = 'Base Unit Invy. Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(102; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(103; "KG Unit Invy. Qty."; decimal)
        {
            Caption = 'KG Unit Invy. Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(104; "KG Unit of Measure"; Code[10])
        {
            Caption = 'KG Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(105; "Unit Cost 1"; decimal)
        {
            Caption = 'Unit Cost 1';
            DecimalPlaces = 0 : 8;
        }
        field(106; "Cost Amount 1"; decimal)
        {
            Caption = 'Cost Amount 1';
            AutoFormatType = 1;
        }
        field(107; "Unit Cost 2"; decimal)
        {
            Caption = 'Unit Cost 2';
            DecimalPlaces = 0 : 8;
        }
        field(108; "Cost Amount 2"; decimal)
        {
            Caption = 'Cost Amount 2';
            AutoFormatType = 1;
        }
        field(109; "Unit Cost 3"; decimal)
        {
            Caption = 'Unit Cost 3';
            DecimalPlaces = 0 : 8;
        }
        field(110; "Cost Amount 3"; decimal)
        {
            Caption = 'Cost Amount 3';
            AutoFormatType = 1;
        }
        field(111; "Roll Unit Cost"; decimal)
        {
            Caption = 'Roll Unit Cost';
            DecimalPlaces = 0 : 8;
        }
        field(112; "Roll Cost Amount"; decimal)
        {
            Caption = 'Roll Cost Amount';
            AutoFormatType = 1;
        }
        field(113; "Direct Dep. Exp."; Decimal)
        {
            Caption = 'Direct Dep. Exp.';
            DecimalPlaces = 0 : 8;

        }
        field(114; "Direct Fixed Cost"; Decimal)
        {
            Caption = 'Direct Fixed Cost';
            DecimalPlaces = 0 : 8;
        }
        field(115; "Direct Labor Cost"; Decimal)
        {
            Caption = 'Direct Labor Cost';
            DecimalPlaces = 0 : 8;
        }
        field(116; "Electricity Fee"; Decimal)
        {
            Caption = 'Electricity Fee';
            DecimalPlaces = 0 : 8;
        }
        field(117; "Gas Fee"; Decimal)
        {
            Caption = 'Gas Fee';
            DecimalPlaces = 0 : 8;
        }
        field(118; "Indirect Cost"; Decimal)
        {
            Caption = 'Indirect Cost';
            DecimalPlaces = 0 : 8;

        }
        field(119; "Raw Material Cost"; Decimal)
        {
            Caption = 'Raw Material Cost';
            DecimalPlaces = 0 : 8;
        }
        field(120; "Package Material Cost"; Decimal)
        {
            Caption = 'Package Material Cost';
            DecimalPlaces = 0 : 8;
        }
        field(121; "Water"; Decimal)
        {
            Caption = 'Water';
            DecimalPlaces = 0 : 8;
        }
        field(122; "Direct Dep. Exp. Amt."; Decimal)
        {
            Caption = 'Direct Dep. Exp. Amt.';
            AutoFormatType = 1;

        }
        field(123; "Direct Fixed Cost Amt."; Decimal)
        {
            Caption = 'Direct Fixed Cost Amt.';
            AutoFormatType = 1;
        }
        field(124; "Direct Labor Cost Amt."; Decimal)
        {
            Caption = 'Direct Labor Cost Amt.';
            AutoFormatType = 1;
        }
        field(125; "Electricity Fee Amt."; Decimal)
        {
            Caption = 'Electricity Fee Amt.';
            AutoFormatType = 1;
        }
        field(126; "Gas Fee Amt."; Decimal)
        {
            Caption = 'Gas Fee Amt.';
            AutoFormatType = 1;
        }
        field(127; "Indirect Cost Amt."; Decimal)
        {
            Caption = 'Indirect Cost Amt.';
            AutoFormatType = 1;

        }
        field(128; "Raw Material Cost Amt."; Decimal)
        {
            Caption = 'Raw Material Cost Amt.';
            AutoFormatType = 1;
        }
        field(129; "Package Material Cost Amt."; Decimal)
        {
            Caption = 'Package Material Cost Amt.';
            AutoFormatType = 1;
        }
        field(130; "Water Amt."; Decimal)
        {
            Caption = 'Water Amt.';
            AutoFormatType = 1;
        }

    }
    keys
    {
        key(Key1; "Available Invy. Name", "Entry No.")
        {
            Clustered = true;
        }

    }
}

