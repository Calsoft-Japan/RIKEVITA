/// <summary>
/// Table RV QC Group (ID 50514)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50514 "RV QC Resource Group Apply"
{
    Caption = 'QC Resource Group Apply';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            NotBlank = true;
        }
        field(2; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
            TableRelation = "RV QC Resource Group"."QC Resource Group No.";
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }



}