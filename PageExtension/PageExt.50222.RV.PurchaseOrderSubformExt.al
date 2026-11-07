
/// <summary>
/// PageExtension RV Purchase Order Subform Ext (ID 50222) extends "Purchase Order Subform"
/// additional requirement 2026/11/07: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50222 "RV Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
