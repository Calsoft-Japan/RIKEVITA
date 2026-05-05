/// <summary>
/// table RV_RSPO Ratio (ID 50105).
/// FDD027 2026/05/01: New. (Liuyang)
/// </summary>
table 50105 "RV_RSPO Ratio"
{
    Caption = 'RV_RSPO Ratio';
    DataClassification = ToBeClassified;

    fields
    {

        field(50100; "Item No. (FP)"; Code[20])
        {
            Caption = 'Item No. (FP)';
            TableRelation = Item."No.";
        }
        field(50101; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No.";
        }
        field(50102; "Output Quantity (KG)"; Decimal)
        {
            Caption = 'Output Quantity (KG)';
        }
        field(50103; "Item No. (RM)"; Code[20])
        {
            Caption = 'Item No. (RM)';
            TableRelation = Item."No.";
        }
        field(50104; "Consumption Quantity (KG)"; Decimal)
        {
            Caption = 'Consumption Quantity (KG)';
        }
        field(50105; "RSPO Ratio %"; Decimal)
        {
            Caption = 'RSPO Ratio %';
        }
    }
    keys
    {
        key(PK; "Item No. (FP)", "Item No. (RM)")
        {
            Clustered = true;
        }
    }

}
