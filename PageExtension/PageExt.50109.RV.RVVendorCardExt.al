/// <summary>
/// Page Extension RV_Vendor Card Ext (ID 50109).
/// FDD013 2026/03/19: New (Liuyang) Adds an "ISO Certificates" action button to the Vendor Card page.
/// FDD017 2026/04/14 Liuyang Adds ID No./Passport No. field and only editable while Partner Type is Person.
/// </summary>
pageextension 50109 "RV Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        modify("Partner Type")
        {
            trigger OnAfterValidate()
            begin
                IDEditable := false;
                if Rec."Partner Type" = "Partner Type"::Person then
                    IDEditable := true
                else
                    Rec."RV_ID No./Passport No." := '';
            end;
        }
        addafter("Partner Type")
        {
            field("RV_ID No./Passport No."; Rec."RV_ID No./Passport No.")
            {
                Description = 'FDD017';
                ApplicationArea = All;
                MaskType = Concealed;
                Editable = IDEditable;
            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("Aged Accounts Payable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                RunObject = Report "RV Aged Accounts Payable Basic";
                ToolTip = 'View a list of aged remaining balances for each vendor.';
            }
        }
        addlast(Category_Report)
        {
            actionref(Aged_Accounts_Payable_Promoted; "Aged Accounts Payable") { }
        }
        addafter(Attachments)//addlast("Ven&dor")//processing
        {
            action(ISOCertificates)
            {
                ApplicationArea = All;
                Caption = 'ISO Certificates';
                Image = Certificate;
                ToolTip = 'View and manage ISO certificates registered for this vendor.';

                RunObject = Page "RV Vendor ISO Certificate List";
                RunPageLink = "Vendor No." = field("No.");

                /* trigger OnAction()
                var
                    VendorIsoCertList: Record "RV Vendor ISO Certificate List";
                    VendorIsoCertListPage: Page "RV Vendor ISO Certificate List";
                begin
                    // Pre-filter the list page to the current vendor so that only
                    // this vendor's certificates are shown when opened from the card.
                    VendorIsoCertList.SetRange("Vendor No.", Rec."No.");
                    VendorIsoCertListPage.SetTableView(VendorIsoCertList);
                    VendorIsoCertListPage.RunModal();
                end; */
            }
        }
        addlast(Category_Category9)
        {
            actionref(ISOCertificates_Promoted; ISOCertificates) { }
        }
    }

    var
        IDEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        IDEditable := false;
        if (Rec."No." <> '') and (Rec."Partner Type" = "Partner Type"::Person) then
            IDEditable := true;
    end;
}
