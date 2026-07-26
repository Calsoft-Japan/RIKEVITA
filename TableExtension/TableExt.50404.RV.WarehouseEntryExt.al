tableextension 50404 "RV Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        field(50400; "RV_SITE Dim. Code"; Code[20])
        {
            Description = 'Common Function';
            Caption = 'SITE Dimension Code';
            TableRelation = Dimension;
        }
    }
}
