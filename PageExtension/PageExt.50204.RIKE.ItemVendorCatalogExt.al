/// <summary>
/// PageExtension Rv_Item Vendor Catalog (ID 50204) extends "Item Vendor Catalog"
/// FDD002 2026/03/16: New. (Bobby.ji)
/// </summary>
pageextension 50204 "RV_Item Vendor Catalog" extends "Item Vendor Catalog"
{
    layout
    {

        addafter("Lead Time Calculation")
        {
            field("Minimum Order Quantity"; Rec."RV_Minimum Order Quantity")
            {
                Caption = 'Minimum Order Quantity';
                ApplicationArea = all;
            }
            field("Maximum Order Quantity"; Rec."RV_Maximum Order Quantity")
            {
                Caption = 'Maximum Order Quantity';
                ApplicationArea = all;
            }
        }
    }
}
