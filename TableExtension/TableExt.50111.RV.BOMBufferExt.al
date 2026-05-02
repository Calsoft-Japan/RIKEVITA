/// <summary>
/// tableextension RV BOM Buffer Ext(RV_RSPO Ratio) (ID 50111).
/// FDD027 2026/05/01: New. (Liuyang)
/// </summary>
tableextension 50111 "RV BOM Buffer Ext" extends "BOM Buffer"
{
    fields
    {
        field(50100; "RV_Item No. (FP)"; Code[20])
        {
            Caption = 'Item No. (FP)';
            TableRelation = Item."No.";
        }
        field(50101; "RV_Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No.";
        }
        field(50102; "RV_Output Quantity (KG)"; Decimal)
        {
            Caption = 'Output Quantity (KG)';
        }
        field(50103; "RV_Item No. (RM)"; Code[20])
        {
            Caption = 'Item No. (RM)';
            TableRelation = Item."No.";
        }
        field(50104; "RV_Consumption Quantity (KG)"; Decimal)
        {
            Caption = 'Consumption Quantity (KG)';
        }
        field(50105; "RV_RSPO Ratio %"; Decimal)
        {
            Caption = 'RSPO Ratio %';
        }
    }
}
