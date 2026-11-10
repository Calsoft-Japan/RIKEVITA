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
            Trigger onValidate()
            Var
                Item: Record Item;
            begin
                "Item Category Code" := '';
                If Item.Get("Item No.") then
                    "Item Category Code" := Item."Item Category Code";
            end;
        }
        field(2; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
            TableRelation = "RV QC Resource Group"."QC Resource Group No.";
            NotBlank = true;
        }
        field(3; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            //editable = false;

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