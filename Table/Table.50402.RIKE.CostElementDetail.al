/// <summary>
/// Table RV Cost Element Details (ID 50402).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
table 50402 "RIKE Cost Element Details"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Period Code"; Code[20])
        {
            Caption = 'Period Code';
            TableRelation = "Standard Cost Element Period"."Code";
        }
        field(2; "Site"; Code[10])
        {
            Caption = 'Site';
            TableRelation = "Dimension Value".code
                where("Dimension Code" = const('ACC_SITE'));
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Item"."No.";
        }
        field(4; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Description" where("No." = field("Item No.")));
            Editable = false;
        }
        field(5; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
            Editable = false;
        }
        field(6; "Cost Element Code"; Code[20])
        {
            Caption = 'Cost Element Code';
            TableRelation = "RIKE Cost Element Category"."Code";
        }
        field(7; "Cost"; Decimal)
        {
            Caption = 'Cost';
        }
    }

    keys
    {
        // Primary key: combination of "Period Code", "Site", "Item No." and "Cost Element Code"
        key(PK; "Period Code", "Site", "Item No.", "Cost Element Code") { Clustered = true; }
        key(SortKey; "Period Code", "Site", "Item No.") { }
    }
}