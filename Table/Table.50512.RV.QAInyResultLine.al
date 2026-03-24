/// <summary>
/// Table RV QA Iny. Result Line (ID 50512)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50512 "RV QA Iny. Result Line"
{
    Caption = 'QA Iny. Result Line';
    DataClassification = CustomerContent;
    fields
    {

        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
            TableRelation = "RV QA Header";
            NotBlank = true;
        }
        field(2; "COA Lot Line No."; Integer)
        {
            Caption = 'COA Lot Line No.';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Inventory Type"; Enum "RV Inventory Type")
        {
            Caption = 'Inventory Type';
        }
        field(8; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(9; "Classification"; Enum "RV QC Standard Type")
        {
            Caption = 'Classification';
        }
        field(10; "Comment"; Text[150])
        {
            Caption = 'Comment';
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
}