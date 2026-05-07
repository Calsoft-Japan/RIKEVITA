/// <summary>
/// Table Order Listing. (FDD026).
/// FDD026 2026/05/02: New. (Stephen)
/// </summary>
table 50608 "RV Order Listing"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Blanket Sales Order No."; Code[20])
        {
            Caption = 'Blanket Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Blanket Sales Order Line No."; Integer)
        {
            Caption = 'Blanket Sales Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const("Order"));
        }
        field(5; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            tableRelation = Item."No.";
        }
        field(8; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(9; "Order Qty. (UOM)"; Decimal)
        {
            Caption = 'Order Qty. (UOM)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(10; "Order Unit of Measure"; Code[10])
        {
            Caption = 'Order Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(11; "Order Qty. (Base)"; Decimal)
        {
            Caption = 'Order Qty. (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(12; "Order Qty. (KG)"; Decimal)
        {
            Caption = 'Order Qty. (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(13; "Reserved Qty. (UOM)"; Decimal)
        {
            Caption = 'Reserved Qty. (UOM)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(14; "Reserved Qty. (KG)"; Decimal)
        {
            Caption = 'Reserved Qty. (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(15; "Prod. Order No."; Text[250])
        {
            Caption = 'Prod. Order No.';
            DataClassification = ToBeClassified;
        }
        field(16; "Prod. Order Line No."; Text[250])
        {
            Caption = 'Prod. Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(17; "Transfer Order No."; Text[250])
        {
            Caption = 'Transfer Order No.';
            DataClassification = ToBeClassified;
        }
        field(18; "Transfer Order Line No."; Text[250])
        {
            Caption = 'Transfer Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(19; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }

        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }

        field(21; "Ship-to Customer Name"; Text[100])
        {
            Caption = 'Ship-to Customer Name';
            DataClassification = ToBeClassified;
        }

        field(22; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
            DataClassification = ToBeClassified;
        }
        field(23; "Status"; Enum "RV SO Reserve Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }

        field(24; "ETD"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(25; "ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = ToBeClassified;
        }
        field(26; "Order Lead Time (Days)"; Integer)
        {
            Caption = 'Order Lead Time (Days)';
            DataClassification = ToBeClassified;
        }
        field(27; "Packing Date"; Date)
        {
            Caption = 'Packing Date';
            DataClassification = ToBeClassified;
        }
        field(28; "ECR Date"; Date)
        {
            Caption = 'ECR Date';
            DataClassification = ToBeClassified;
        }
        field(29; "Holding Requirement"; Date)
        {
            Caption = 'Holding Requirement';
            DataClassification = ToBeClassified;
        }
        field(40; "Holding Requirement 1"; DateFormula)
        {
            Caption = 'Holding Requirement';
            DataClassification = ToBeClassified;
        }
        field(30; "Bypass Holding Requirement"; Boolean)
        {
            Caption = 'Bypass Holding Requirement';
            DataClassification = ToBeClassified;
        }

        field(31; "Packing Line"; Code[20])
        {
            Caption = 'Packing Line No.';
            DataClassification = ToBeClassified;
        }
        field(32; "Closing Date & Time"; DateTime)
        {
            Caption = 'Closing Date & Time';
            DataClassification = ToBeClassified;
        }
        field(42; "Closing Date & Time 2"; Date)
        {
            Caption = 'Closing Date & Time';
            DataClassification = ToBeClassified;
        }
        field(33; "Order Age (Days)"; Integer)
        {
            Caption = 'Order Age (Days)';
            DataClassification = ToBeClassified;
        }
        field(34; "SI Received Date"; Date)
        {
            Caption = 'SI Received Date';
            DataClassification = ToBeClassified;
        }
        field(35; Comment; Text[250])
        {
            Caption = 'Comment';
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
