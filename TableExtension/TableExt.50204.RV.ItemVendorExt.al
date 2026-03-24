/// <summary>
/// TableExtension RV_Item Vendor (ID 50204) extends Item Vendor table
/// FDD002 2026/03/16: New. (Bobby.ji)
/// </summary>
tableextension 50204 "RV_Item Vendor" extends "Item Vendor"
{
    fields
    {
        field(50200; "RV_Minimum Order Quantity"; Integer)
        {
            Caption = 'Minimum Order Quantity';
            Description = 'FDD002';
        }
        field(50201; "RV_Maximum Order Quantity"; Integer)
        {
            Caption = 'Maximum Order Quantity';
            Description = 'FDD002';
        }
    }
}
