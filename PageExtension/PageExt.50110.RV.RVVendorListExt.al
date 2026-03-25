/// <summary>
/// Page Extension RV_Vendor List Ext (ID 50110).
/// FDD013 2026/03/19: New (Liuyang)
/// Adds an "ISO Certificates" action button to the Vendor List page.
/// When clicked, opens the Vendor ISO Certificate List pre-filtered
/// to the currently selected vendor, satisfying the FDD requirement:
///   "Both function buttons must be linked to the same page/table
///    Vendor ISO Certificate List."
/// </summary>
pageextension 50110 "RV Vendor List Ext" extends "Vendor List"
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
                ToolTip = 'View and manage ISO certificates registered for the selected vendor.';

                trigger OnAction()
                var
                    VendorIsoCertList: Record "RV Vendor ISO Certificate List";
                    VendorIsoCertListPage: Page "RV Vendor ISO Certificate List";
                begin
                    // Pre-filter the list page to the selected vendor so that only
                    // that vendor's certificates are shown when opened from the list.
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
