table 50615 "RV Item Site Production Master"
{
    Caption = 'Item Site Production Master';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Site Code"; Code[20])
        {
            Caption = 'Site Code';
            tableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(3; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header"."No.";
        }
        field(4; "BOM No."; Code[20])
        {
            Caption = 'BOM No.';
            TableRelation = "Production BOM Header"."No.";
        }
    }

    keys
    {
        key(PK; "Item No.", "Site Code")
        {
            Clustered = true;
        }
    }
}