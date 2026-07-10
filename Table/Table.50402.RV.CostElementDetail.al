/// <summary>
/// Table RV Cost Element Details (ID 50402).
/// FDD034 2026/03/19: New. (Vani)
/// FDD034 2026/07/10: Update. (Bobby)
/// </summary>
table 50402 "Standard Cost Element Details"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Period Code"; Code[50])
        {
            Caption = 'Period Code';
            TableRelation = "Standard Cost Element Period"."Code";
            Description = 'FDD034';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Item"."No.";
            Description = 'FDD034';
        }
        field(4; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Description" where("No." = field("Item No.")));
            Editable = false;
            Description = 'FDD034';
        }
        field(8; "Direct Dep. Exp."; Decimal)
        {
            Caption = 'Direct Dep. Exp.';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(9; "Direct Fixed Cost"; Decimal)
        {
            Caption = 'Direct Fixed Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(10; "Direct Labor Cost"; Decimal)
        {
            Caption = 'Direct Labor Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(11; "Electricity Fee"; Decimal)
        {
            Caption = 'Electricity Fee';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(12; "Gas Fee"; Decimal)
        {
            Caption = 'Gas Fee';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(13; "Indirect Cost"; Decimal)
        {
            Caption = 'Indirect Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(14; "Raw Material Cost"; Decimal)
        {
            Caption = 'Raw Material Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(15; "Package Material Cost"; Decimal)
        {
            Caption = 'Package Material Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(16; "Water"; Decimal)
        {
            Caption = 'Water';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                CalculateTotalStandardCost();
            end;
        }
        field(17; "Total Standard Cost"; Decimal)
        {
            Caption = 'Total Standard Cost';
            Description = 'FDD034';
            DecimalPlaces = 0 : 8;
        }
    }

    keys
    {
        // Primary key: combination of "Period Code" and "Item No."
        key(PK; "Period Code", "Item No.") { Clustered = true; }
    }

    local procedure CalculateTotalStandardCost()
    begin
        Rec."Total Standard Cost" := Rec."Direct Dep. Exp." + Rec."Direct Fixed Cost" + Rec."Direct Labor Cost" + Rec."Electricity Fee" + Rec."Gas Fee" + Rec."Indirect Cost" + Rec."Raw Material Cost" + Rec."Package Material Cost" + Rec."Water";
    end;
}