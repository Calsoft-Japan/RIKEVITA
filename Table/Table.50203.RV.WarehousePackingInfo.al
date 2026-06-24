/// <summary>
/// Table RV Warehouse Packing Info. (ID 50203).
/// FDD019 2026/04/20: New. (Bobby.ji)
/// </summary>
table 50203 "RV Warehouse Packing Info."
{
    Caption = 'RV Warehouse Packing Info';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Warehouse Shipment No."; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            Description = 'FDD019';
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'FDD019';
        }
        field(3; "SO Line No."; Integer)
        {
            Caption = 'SO Line No.';
            Description = 'FDD019';
        }
        field(4; "Posted Whse. Shipment No."; Code[20])
        {
            Caption = 'Posted Whse. Shipment No.';
            Description = 'FDD019';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'FDD019';
            TableRelation = Item."No.";
        }
        field(6; "Case No."; Text[20])
        {
            Caption = 'Case No.';
            Description = 'FDD019';
        }
        field(7; "No. of Packages"; Decimal)
        {
            Caption = 'No. of Packages';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                Item.Get(Rec."Item No.");
                Rec."Gross Weight" := Rec."No. of Packages" * Item."Gross Weight";
            end;
        }
        field(8; "Contents Per Package"; Decimal)
        {
            Caption = 'Contents Per Package';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Contents UOM"; Code[10])
        {
            Caption = 'Contents UOM';
            Description = 'FDD019';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(10; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Gross Weight UOM"; Code[10])
        {
            Caption = 'Gross Weight UOM';
            Description = 'FDD019';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(13; "Measurement"; Decimal)
        {
            Caption = 'Measurement';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Measurement UOM"; Code[10])
        {
            Caption = 'Measurement UOM';
            Description = 'FDD019';
            TableRelation = "Unit of Measure".Code;
        }
    }
    keys
    {
        key(PK; "Warehouse Shipment No.", "Posted Whse. Shipment No.", "Sales Order No.", "SO Line No.")
        {
            Clustered = true;
        }
    }
}
