/// <summary>
/// PageExtension RV Sales Cr Memo Subform Ext (ID 50229) extends "Sales Cr. Memo Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50229 "RV Sales Cr Memo Subform Ext" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
