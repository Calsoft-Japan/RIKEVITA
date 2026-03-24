/// <summary>
/// Table RV QA Shipment Lot No.(ID 50509)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50509 "RV QA Shipment Lot No."
{
    Caption = 'QA Shipment Lot No.';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
            TableRelation = "RV QA Header";
            NotBlank = true;
        }
        field(2; "COA Lot Line No."; Integer)
        {
            Caption = 'COA Lot Line No.';
        }
        field(3; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(4; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }

        field(5; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = "Unit of Measure";
        }
        field(6; "Container No."; Text[100])
        {
            Caption = 'Container No.';
        }
        field(7; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(8; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }

        field(9; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(10; "QA Status"; Enum "RV QA Status")
        {
            Caption = 'QA Status';
        }
        field(16; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.")
        {
            Clustered = true;
        }
    }

    var
}