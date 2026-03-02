/// <summary>
/// Table RIKE QC Iny. Result Line (ID 50507)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50507 "RIKE QC Iny. Result Line"
{
    Caption = 'QC Iny. Result Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC No."; Code[20])
        {
            Caption = 'QC No.';
            TableRelation = "RIKE QC Header"."QC No." where("QC Type" = field("QC Type"));
            NotBlank = true;
        }
        field(2; "QC Type"; Enum "RIKE QC Type")
        {
            Caption = 'QC Type';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Inventory Type"; Enum "RIKE Inventory Type")
        {
            Caption = 'Inventory Type';
        }
        field(5; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(6; "Classification"; Enum "RIKE QC Standard Type")
        {
            Caption = 'Classification';
        }
        field(7; "Comment"; Text[150])
        {
            Caption = 'Comment';
        }
    }
    keys
    {
        key(PK; "QC No.", "QC Type", "Line No.")
        {
            Clustered = true;
        }
    }

    var
}