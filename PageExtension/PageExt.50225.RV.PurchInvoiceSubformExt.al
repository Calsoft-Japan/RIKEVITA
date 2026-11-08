/// <summary>
/// PageExtension RV Purch Invoice Subform Ext (ID 50225) extends "Purch. Invoice Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50225 "RV PurchInvoiceSubform Ext" extends "Purch. Invoice Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
