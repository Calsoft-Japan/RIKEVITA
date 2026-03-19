/// <summary>
/// Page Extension RV_Vendor Card Ext (ID 50109).
/// FDD013 2026/03/19: New (Liuyang)
/// Adds an "ISO Certificates" action button to the Vendor Card page.
/// When clicked, opens the Vendor ISO Certificate List pre-filtered
/// to the current vendor, satisfying the FDD requirement:
///   "When accessed through the Vendor card, this page must be
///    automatically filtered by Vendor."
/// </summary>
pageextension 50109 "RV_Vendor Card Ext" extends "Vendor Card"
{
    actions
    {
        addlast(processing)
        {
            action(ISOCertificates)
            {
                ApplicationArea = All;
                Caption = 'ISO Certificates';
                Image = Certificate;
                ToolTip = 'View and manage ISO certificates registered for this vendor.';

                trigger OnAction()
                var
                    VendorIsoCertList: Record "RV_Vendor ISO Certificate List";
                    VendorIsoCertListPage: Page "RV_Vendor ISO Certificate List";
                begin
                    // Pre-filter the list page to the current vendor so that only
                    // this vendor's certificates are shown when opened from the card.
                    VendorIsoCertList.SetRange("Vendor No.", Rec."No.");
                    VendorIsoCertListPage.SetTableView(VendorIsoCertList);
                    VendorIsoCertListPage.RunModal();
                end;
            }
        }
        addlast(Promoted)
        {
            actionref(ISOCertificates_Promoted; ISOCertificates) { }
        }
    }
}
