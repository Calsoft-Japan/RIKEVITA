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
            // Header additions
            column(RV_CurrencyFilter; GetFilter("Currency Filter")) { }
            column(RV_PrintBankDetails; PrintBankDetails) { }

            // Vendor master additions
            column(RV_PaymentTermsCode; PaymentTermsCode) { }
            column(RV_VendorBankName; VendorBankName) { }
            column(RV_SwiftCode; SwiftCode) { }
            column(RV_BankAccountNo; BankAccountNo) { }
        }

        modify(Vendor)
        {
            trigger OnAfterAfterGetRecord()
            var
                VendorBankAccount: Record "Vendor Bank Account";
            begin
                Clear(PaymentTermsCode);
                Clear(VendorBankName);
                Clear(SwiftCode);
                Clear(BankAccountNo);

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

        add(TempVendortLedgEntryLoop)
        {
            // Body additions
            column(RV_RowPaymentTermsCode; PaymentTermsCode) { }
            column(RV_RowVendorBankName; VendorBankName) { }
            column(RV_RowSwiftCode; SwiftCode) { }
            column(RV_RowBankAccountNo; BankAccountNo) { }
            column(RV_RowPrintBankDetails; PrintBankDetails) { }
        }
    }

    requestpage
    {
        layout
        {
            addafter(PrintDetails)
            {
                field(PrintBankDetails; PrintBankDetails)
                {
                    ApplicationArea = All;
                    Caption = 'Print Bank Details';
                    ToolTip = 'Specifies whether vendor bank details are shown on the report.';
                }
            }
        }
    }

    var
        PaymentTermsCode: Code[20];
        VendorBankName: Text[100];
        SwiftCode: Code[20];
        BankAccountNo: Code[50];
        PrintBankDetails: Boolean;
}