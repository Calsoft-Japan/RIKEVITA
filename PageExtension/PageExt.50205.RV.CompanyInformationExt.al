/// <summary>
/// PageExtension RV_Company Information (ID 50205) extends "Company Information"
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
pageextension 50205 "RV Company Information Ext" extends "Company Information"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field("SST Reg No."; Rec."RV_SST Reg No.")
            {
                Caption = 'SST Reg No.';
                ApplicationArea = all;
            }
            field("RESO Certificate No."; Rec."RV_RESO Certificate No.")
            {
                Caption = 'RESO Certificate No.';
                ApplicationArea = all;
            }
        }
    }
}
