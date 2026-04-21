/// <summary>
/// Table RV Item Symbol Setting (ID 50202).
/// FDD019 2026/04/20: New. (Bobby.ji)
/// </summary>
table 50202 "RV Item Symbol Setting"
{
    Caption = 'RV Item Symbol Setting';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            Description = 'FDD019';
        }
        field(2; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Description = 'FDD019';
        }
        field(3; "Symbol Display Packing List"; Boolean)
        {
            Caption = 'Symbol Display Packing List';
            Description = 'FDD019';
        }
        field(4; "Item Symbol Image"; MediaSet)
        {
            Caption = 'Item Symbol Image';
            Description = 'FDD019';
        }
    }
    keys
    {
        key(PK; "Item Code")
        {
            Clustered = true;
        }
    }
}
