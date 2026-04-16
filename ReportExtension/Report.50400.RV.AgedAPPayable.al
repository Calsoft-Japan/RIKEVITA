/// <summary>
/// ReportExtension RIKE Aged AP payable
/// FDD002 2026/04/15: New. (VANi)
/// </summary>
reportextension 50400 "RV Aged AP Ext" extends "Aged Accounts Payable"
{
    dataset
    {
        add(Vendor)
        {
            column(VendorBankName; VendorBankName) { }
            column(SwiftCode; SwiftCode) { }
            column(BankAccountNo; BankAccountNo) { }
            column(PaymentTermsCode; PaymentTermsCode) { }
        }

        modify(Vendor)
        {
            trigger OnAfterAfterGetRecord()
            var
                VendorBankAccount: Record "Vendor Bank Account";
            begin
                Clear(VendorBankName);
                Clear(SwiftCode);
                Clear(BankAccountNo);
                Clear(PaymentTermsCode);

                PaymentTermsCode := "Payment Terms Code";

                if PrintBankDetails then begin
                    VendorBankAccount.SetRange("Vendor No.", "No.");
                    if VendorBankAccount.FindFirst() then begin
                        VendorBankName := VendorBankAccount.Name;
                        SwiftCode := VendorBankAccount."SWIFT Code";
                        BankAccountNo := VendorBankAccount."Bank Account No.";
                    end;
                end;
            end;
        }

        add("Vendor Ledger Entry")
        {
            column(RMEquivalent; "Amount (LCY)") { }
        }
    }

    requestpage
    {
        layout
        {
            addlast(Options)
            {
                field(PrintBankDetails; PrintBankDetails)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        VendorBankName: Text[100];
        SwiftCode: Code[20];
        BankAccountNo: Code[50];
        PaymentTermsCode: Code[20];
        PrintBankDetails: Boolean;
}