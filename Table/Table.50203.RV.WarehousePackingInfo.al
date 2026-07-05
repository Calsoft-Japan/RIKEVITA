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
        field(6; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            Description = 'FDD019';
        }
        field(7; "Container No"; Code[20])
        {
            Caption = 'Container No';
            Description = 'FDD019';
            trigger OnValidate()
            var
                WarehousePackingInfo: Record "RV Warehouse Packing Info.";
            begin
                WarehousePackingInfo.Reset();
                WarehousePackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                WarehousePackingInfo.SetRange("Sales Order No.", Rec."Sales Order No.");
                WarehousePackingInfo.SetRange("SO Line No.", Rec."SO Line No.");
                WarehousePackingInfo.SetRange("Item No.", Rec."Item No.");
                WarehousePackingInfo.SetRange("Lot No.", Rec."Lot No.");
                WarehousePackingInfo.SetRange("Container No", Rec."Container No");
                if WarehousePackingInfo.FindFirst() then begin
                    Error('For the same shipment Line, the same Lot No. and Container No. should be consolidated into a single packaging line.');
                end;
            end;
        }
        field(8; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Case No."; Text[20])
        {
            Caption = 'Case No.';
            Description = 'FDD019';
        }
        field(10; "No. of Packages"; Decimal)
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
        field(11; "Contents Per Package"; Decimal)
        {
            Caption = 'Contents Per Package';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Contents UOM"; Code[10])
        {
            Caption = 'Contents UOM';
            Description = 'FDD019';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(13; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(15; "Gross Weight UOM"; Code[10])
        {
            Caption = 'Gross Weight UOM';
            Description = 'FDD019';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(16; "Measurement"; Decimal)
        {
            Caption = 'Measurement';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Measurement UOM"; Code[10])
        {
            Caption = 'Measurement UOM';
            Description = 'FDD019';
            TableRelation = "Unit of Measure".Code;
        }
        field(18; "Lot Quantity"; Decimal)
        {
            Caption = 'Lot Quantity';
            Description = 'FDD019';
            DecimalPlaces = 0 : 5;
        }
        field(19; "Comment"; Text[80])
        {
            Caption = 'Comment';
            Description = 'FDD019';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'FDD019';
        }
    }
    keys
    {
        //key(PK; "Warehouse Shipment No.", "Posted Whse. Shipment No.", "Sales Order No.", "SO Line No.")
        key(PK; "Sales Order No.", "SO Line No.", "Lot No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
