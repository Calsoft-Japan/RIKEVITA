/// <summary>
/// PageExtension RV Sales Return Order Subform Ext (ID 50227) extends "Sales Return Order Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50227 "RV SalesReturnOrderSubform Ext" extends "Sales Return Order Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
