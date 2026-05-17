/// <summary>
/// Table RV Item Trace Detail(ID 50904)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
table 50904 "RV Item Trace Detail"
{
    Caption = 'RV Item Trace Detail';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "History Entry No."; Integer)
        {
            Caption = 'History Entry No.';
            Editable = false;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            TableRelation = "Item Ledger Entry"."Entry No.";
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
            TableRelation = Vendor."No.";
        }
        field(12; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
        field(13; "Gen. Bus. Posting Group "; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group ';
            Editable = false;
        }
        field(14; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(15; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(16; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(17; "Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(18; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(20; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            Editable = false;
        }
        field(21; "Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
            Editable = false;
        }
        field(22; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            Editable = false;
        }
        field(23; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            Editable = false;
        }
        field(24; "Quantity (BUOM)"; Decimal)
        {
            Caption = 'Quantity (BUOM)';
            Editable = false;
        }
        field(25; "Quantity (KG)"; Decimal)
        {
            Caption = 'Quantity (KG)';
            Editable = false;
        }
        field(26; "Cost Amount (RM)"; Decimal)
        {
            Caption = 'Cost Amount (RM)';
            Editable = false;
        }
        field(27; "Item No. (FP)"; Code[20])
        {
            Caption = 'Item No. (FP)';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(28; "VAT. Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT. Prod. Posting Group';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "History Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}
