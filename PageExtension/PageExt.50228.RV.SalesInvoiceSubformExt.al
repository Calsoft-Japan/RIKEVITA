/// <summary>
/// PageExtension RV Sales Invoice Subform Ext (ID 50228) extends "Sales Invoice Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50228 "RV SalesInvoiceSubform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
