/// <summary>
/// TableExtension RV_ITEM (ID 50200) extends Item table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
tableextension 50200 "RV ITEM" extends "Item"
{
    fields
    {
        field(50200; "RV RSPO"; Boolean)
        {
            Caption = 'RSPO';
            Description = 'FDD027';
        }
        field(50201; "RV Expiration Base Date (RM)"; Option)
        {
            Caption = 'Expiration Base Date (RM)';
            Description = 'FDD001';
            OptionCaption = ' ,Manufacture Date,Posting Date';
            OptionMembers = " ","Manufacture Date","Posting Date";
        }

    }
}
