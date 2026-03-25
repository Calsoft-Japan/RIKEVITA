/// <summary>
/// PageExtension Rv_Vendor Item Catalog (ID 50203) extends "Vendor Item Catalog"
/// FDD002 2026/03/16: New. (Bobby.ji)
/// </summary>
pageextension 50203 "RV Vendor Item Catalog" extends "Vendor Item Catalog"
{
    layout
    {

        addafter("Lead Time Calculation")
        {
            field("Minimum Order Quantity"; Rec."RV Minimum Order Quantity")
            {
                Caption = 'Minimum Order Quantity';
                ApplicationArea = all;
            }
            field("Maximum Order Quantity"; Rec."RV Maximum Order Quantity")
            {
                Caption = 'Maximum Order Quantity';
                ApplicationArea = all;
            }
        }
    }
}
