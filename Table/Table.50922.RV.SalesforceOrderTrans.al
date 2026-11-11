/// <summary>
/// Table RV Salesforce Order Transaction (ID 50922).
/// FDD004 2026/11/07: New. (Shawn)
/// </summary>
table 50922 "RV Salesforce Order Trans."
{
    Caption = 'Salesforce Order Transaction';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            autoIncrement = true;
        }
        field(2; "Staging Entry No."; Integer)
        {
            Caption = 'Staging Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "RV Salesforce Order Staging"."Entry No.";
        }
        field(3; "Transaction Type"; Enum "RV Salesforce Trans Type")
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Action Type"; Enum "RV Salesforce Action Type")
        {
            Caption = 'Action Type';
            DataClassification = ToBeClassified;
        }

        field(5; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = ToBeClassified;
        }
        field(6; "CR No."; Code[20])
        {
            Caption = 'CR No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(8; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(9; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(11; "Bill-to Customer Name"; Text[100])
        {
            Caption = 'Bill-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Bill-to Customer No.")));
        }
        field(12; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(13; "Ship-to Customer Name"; Text[100])
        {
            Caption = 'Ship-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Ship-to Address".Name where("Customer No." = field("Sell-to Customer No."),
                                                            Code = field("Ship-to Code")));
        }
        field(14; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
        }
        field(15; "ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = ToBeClassified;
        }
        field(16; "ETD"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(17; "RVM PIC"; Code[20])
        {
            Caption = 'RVM PIC';
            DataClassification = ToBeClassified;
        }
        field(18; "Salesforce Remarks"; Text[250])
        {
            Caption = 'Salesforce Remarks';
            DataClassification = ToBeClassified;
        }
        field(19; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(20; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(21; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(22; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(23; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(24; "Status"; Enum "RV Salesforce Trans Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(25; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = ToBeClassified;
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
