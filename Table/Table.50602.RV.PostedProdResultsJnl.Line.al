/// <summary>
/// Table RV Posted Prod. Results Jnl. Line (ID 50602)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
table 50602 "RV Pst. Prod. Res. Jnl. Line"
{
    DataClassification = ToBeClassified;
    Caption = 'RV Posted Prod. Results Jnl. Line';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "RV Prod. Results Journal Bat"."Name";
            NotBlank = true;
        }
        field(3; "Journal Line No."; Integer)
        {
            Caption = 'Journal Line No.';
        }
        field(4; "Data Type"; Enum "RV Prod. Results Data Type")
        {
            Caption = 'Data Type';
        }
        field(5; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No.";
        }
        field(6; "Output Item No."; Code[20])
        {
            Caption = 'Output Item No.';
            TableRelation = Item."No.";
        }
        field(7; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No."
                            WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                  "Routing No." = FIELD("Routing No."),
                                  "Routing Reference No." = field("Prod. Order Line No."),
                                  Status = CONST(Released));
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(9; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";
        }
        field(10; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = IF ("Data Type" = CONST("Planned Output")) "Item Unit of Measure".code where("Item No." = FIELD("Output Item No."))
            ELSE IF ("Data Type" = CONST("Adjust Output")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Output Item No."))
            ELSE IF ("Data Type" = CONST("Planned Consumption")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Output Item No."))
            ELSE IF ("Data Type" = CONST("Adjust Consumption")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Output Item No."));
        }
        field(13; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(15; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(16; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }
        field(17; "Status"; Enum "RV Prod. Results Status")
        {
            Caption = 'Status';
        }
        field(18; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE("Prod. Order No." = FIELD("Prod. Order No."), Status = CONST(Released));
        }
        field(19; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
        }
        field(20; "Prod. Order Comp. Line No."; Integer)
        {
            Caption = 'Prod. Order Comp. Line No.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}