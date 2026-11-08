/// <summary>
/// PageExtension RV Purchase Return Order Subform Ext (ID 50224) extends "Purchase Return Order Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50224 "RV PurchReturnOrderSubform Ext" extends "Purchase Return Order Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
