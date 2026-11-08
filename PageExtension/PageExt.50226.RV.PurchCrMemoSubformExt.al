/// <summary>
/// PageExtension RV Purch Cr Memo Subform Ext (ID 50226) extends "Purch. Cr. Memo Subform"
/// additional requirement 2026/11/08: Display VAT Prod. Posting Group. (Bobby.ji)
/// </summary>
pageextension 50226 "RV Purch Cr Memo Subform Ext" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

    }

}
