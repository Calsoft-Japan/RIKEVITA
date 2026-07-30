table 50408 "RV.Inventory Valuation Line"
{
    Caption = 'Inventory Valuation Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Inventory Valuation Name"; Code[10])
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
        field(3; "Period Starting Date"; Date)
        {
            Caption = 'Period Starting Date';
        }
        field(4; "Period Ending Date"; Date)
        {
            Caption = 'Period Ending Date';
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
            TableRelation = "Dimension Value" where("Global Dimension No." = const(2));
        }
        field(8; "Segment"; Code[20])
        {
            Caption = 'Segment';
            //TableRelation = "Dimension Value" where("Global Dimension No." = const(2));
        }
        field(9; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(101; "Starting Balance Quantity"; decimal)
        {
            Caption = 'Starting Balance Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(102; "Starting Balance Amount"; decimal)
        {
            Caption = 'Starting Balance Amount';
            AutoFormatType = 1;
        }
        field(103; "Period Order Quantity"; decimal)
        {
            Caption = 'Period Order Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(104; "Period Order Amount"; decimal)
        {
            Caption = 'Period Order Amount';
            AutoFormatType = 1;
        }
        field(105; "Period Credit Quantity"; decimal)
        {
            Caption = 'Return Outward Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(106; "Period Order Credit Amount"; decimal)
        {
            Caption = 'Return Outward Amount';
            AutoFormatType = 1;
        }
        field(107; "Sample Dispose Quantity"; decimal)
        {
            Caption = 'Sample Dispose Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(108; "Sample Dispose Amount"; decimal)
        {
            Caption = 'Sample Dispose Amount';
            AutoFormatType = 1;
        }
        field(109; "Consumption Quantity"; decimal)
        {
            Caption = 'Consumption Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Consumption Amount"; decimal)
        {
            Caption = 'Consumption Amount';
            AutoFormatType = 1;
        }
        field(111; "Waste Scrap Quantity"; decimal)
        {
            Caption = 'Waste Scrap Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(112; "Waste Scrap Amount"; decimal)
        {
            Caption = 'Waste Scrap Amount';
            AutoFormatType = 1;
        }
        field(113; "Transfer Quantity"; decimal)
        {
            Caption = 'Transfer Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(114; "Transfer Amount"; decimal)
        {
            Caption = 'Transfer Amount';
            AutoFormatType = 1;
        }
        field(115; "Variance Quantity"; decimal)
        {
            Caption = 'Variance Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(116; "Variance Amount"; decimal)
        {
            Caption = 'Variance Amount';
            AutoFormatType = 1;
        }
        field(117; "Ending Balance Quantity"; decimal)
        {
            Caption = 'Ending Balance Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(118; "Ending Balance Amount"; decimal)
        {
            Caption = 'Ending Balance Amount';
            AutoFormatType = 1;
        }
    }
    keys
    {
        key(Key1; "Inventory Valuation Name", "Entry No.")
        {
            Clustered = true;
        }

    }
}

