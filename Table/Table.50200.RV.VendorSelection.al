/// <summary>
/// Table RV Vendor Selection (ID 50200).
/// FDD002 2026/03/18: New. (Bobby.ji)
/// </summary>
table 50200 "RV Vendor Selection"
{
    Caption = 'RV Vendor Selection';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            Description = 'FDD002';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'FDD002';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'FDD002';
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Description = 'FDD002';
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            Description = 'FDD002';
        }
        field(6; "Total Split Quantity"; Decimal)
        {
            Caption = 'Total Split Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("RV Vendor Selection"."Quantity to Order" where("Journal Batch Name" = field("Journal Batch Name"), "Line No." = field("Line No."), "Item No." = field("Item No.")));
        }
        field(7; "Balance Quantity"; Decimal)
        {
            Caption = 'Balance Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Description = 'FDD002';
            trigger OnValidate()
            var
                ItemVendor: Record "Item Vendor";
            begin
                ItemVendor.Reset();
                ItemVendor.SetRange("Item No.", Rec."Item No.");
                ItemVendor.SetRange("Vendor No.", Rec."Vendor No.");
                if ItemVendor.FindFirst() then begin
                    "Minimum Order Quantity" := ItemVendor."RV Minimum Order Quantity";
                    "Maximum Order Quantity" := ItemVendor."RV Maximum Order Quantity";
                end;
            end;
        }
        field(9; "Minimum Order Quantity"; Decimal)
        {
            Caption = 'Minimum Order Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Maximum Order Quantity"; Decimal)
        {
            Caption = 'Maximum Order Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Quantity to Order"; Decimal)
        {
            Caption = 'Quantity to Order';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                Rec.CalcFields("Total Split Quantity");
            end;
        }
        field(12; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Description = 'FDD002';
        }
    }
    keys
    {
        key(PK; "Journal Batch Name", "Line No.", "Item No.", "Vendor No.")
        {
            Clustered = true;
        }
    }
}
