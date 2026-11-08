
/// <summary>
/// PageExtension RV Purchase Quote Subform Ext (ID 50223) extends "Purchase Quote Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50223 "RV Purchase Quote Subform Ext" extends "Purchase Quote Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
