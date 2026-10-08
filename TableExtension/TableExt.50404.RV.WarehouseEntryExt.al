tableextension 50404 "RV Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        field(50400; "RV_Inventory Owner Code"; Code[20])
        {
            Description = 'Common Function';
            Caption = 'Inventory Owner Code';
            //TableRelation = "Dimension Value";
        }
        field(50401; "RV Owner Code"; Code[20])
        {
            Caption = 'Owner Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1 | 2));
        }
    }
}
