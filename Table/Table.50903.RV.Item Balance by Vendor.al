/// <summary>
/// Table RV Item Balance by Vendor(ID 50903)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
table 50903 "RV Item Balance by Vendor"
{
    Caption = 'RV Item Balance by Vendor';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "History Entry No."; Integer)
        {
            Caption = 'History Entry No.';
            Editable = false;
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
        field(13; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(14; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(15; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(21; "Opening Balance (BUOM)"; Decimal)
        {
            Caption = 'Opening Balance (BUOM)';
            Editable = false;
        }
        field(22; "Closing Balance (BUOM)"; Decimal)
        {
            Caption = 'Closing Balance (BUOM)';
            Editable = false;
        }
        field(23; "Opening Balance (KG)"; Decimal)
        {
            Caption = 'Opening Balance (KG)';
            Editable = false;
        }
        field(24; "Closing Balance (KG)"; Decimal)
        {
            Caption = 'Closing Balance (KG)';
            Editable = false;
        }
        field(25; "Opening Balance (RM)"; Decimal)
        {
            Caption = 'Opening Balance (RM)';
            Editable = false;
        }
        field(26; "Closing Balance (RM)"; Decimal)
        {
            Caption = 'Closing Balance (RM)';
            Editable = false;
        }
        field(31; "Note"; Text[250])
        {
            Caption = 'Note';
        }

    }
    keys
    {
        key(PK; "History Entry No.", "Vendor No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
