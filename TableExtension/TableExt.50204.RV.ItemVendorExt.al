/// <summary>
/// TableExtension RV_Item Vendor (ID 50204) extends Item Vendor table
/// FDD002 2026/03/16: New. (Bobby.ji)
/// </summary>
tableextension 50204 "RV Item Vendor" extends "Item Vendor"
{
    fields
    {
        field(50200; "RV_Minimum Order Quantity"; Decimal)
        {
            Caption = 'Minimum Order Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
        }
        field(50201; "RV_Maximum Order Quantity"; Decimal)
        {
            Caption = 'Maximum Order Quantity';
            Description = 'FDD002';
            DecimalPlaces = 0 : 5;
        }
    }
}
