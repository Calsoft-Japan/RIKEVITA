/// <summary>
/// report RV Payment Voucher (ID 50102) 
/// FDD016 2026/04/22: New. (Liuyang)
/// </summary>
report 50102 "RV Payment Voucher"
{
    ApplicationArea = All;
    Caption = 'RV Payment Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\RV_PaymentVoucher.rdlc';
    dataset
    {
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";
            column(JournalTempName_GenJnlLine; "Journal Template Name")
            {
            }
            column(JournalBatchName_GenJnlLine; "Journal Batch Name")
            {
            }
            column(LineNo_GenJnlLine; "Line No.")
            {
            }
            column(Account_Type; "Account Type")
            { }
            column(Account_No_; "Account No.")
            { }
            column(RV_APV_No_; "RV_APV No.")
            { }
            column(GenJnlPostingDate; "Posting Date")
            { }
            column(GenPostDate_ddMMyy; GenPostDate)
            { }
            column(GenJnlAmount__LCY_; "Amount (LCY)")
            {
                AutoFormatExpression = GenJnlLine."Currency Code";
                AutoFormatType = 1;
            }
            column(AccountDescription; Description)
            { }

            column(GenAmtLCY; GenAmtLCY)
            { }

            column(GenJnlLine_Currency_Code; UpperCase("Currency Code"))
            { }
            column(PayToName; PayToName) { }

            dataitem(VendorLedgerEntryApplyID; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("Account No."), "Applies-to ID" = field("Applies-to ID");
                DataItemTableView = sorting("Posting Date") where("Applies-to ID" = filter('<>""'));

                column(Posting_Date_ByVID; "Posting Date")
                { }
                column(Document_No_ByVID; "Document No.")
                { }
                column(Amount_to_Apply_ByVID; "Amount to Apply")
                {
                    AutoFormatExpression = VendorLedgerEntryApplyID."Currency Code";
                    AutoFormatType = 1;
                }

                column(VendID; VendID)
                { }

                trigger OnAfterGetRecord()
                begin
                    VendID := true;
                end;
            }

            dataitem(VendorLedgerEntryApplyDoc; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("Account No."), "Document Type" = field("Applies-to Doc. Type"), "Document No." = field("Applies-to Doc. No.");
                DataItemTableView = sorting("Posting Date") where("Applies-to Doc. No." = filter('<>""'));

                column(Posting_Date_ByVDoc; "Posting Date")
                { }
                column(Document_No_ByVDoc; "Document No.")
                { }
                column(Amount_to_Apply_ByVDoc; "Amount to Apply")
                {
                    AutoFormatExpression = VendorLedgerEntryApplyDoc."Currency Code";
                    AutoFormatType = 1;
                }
                column(VendDoc; VendDoc)
                { }

                trigger OnAfterGetRecord()
                begin
                    VendDoc := true;
                end;
            }

            dataitem(EmployeeLedgerEntryApplyID; "Employee Ledger Entry")
            {
                DataItemLink = "Employee No." = field("Account No."), "Applies-to ID" = field("Applies-to ID");
                DataItemTableView = sorting("Posting Date") where("Applies-to ID" = filter('<>""'));

                column(Posting_Date_ByEID; "Posting Date")
                { }
                column(Document_No_ByEID; "Document No.")
                { }
                column(Amount_to_Apply_ByEID; "Amount to Apply")
                {
                    AutoFormatExpression = EmployeeLedgerEntryApplyID."Currency Code";
                    AutoFormatType = 1;
                }
                column(EmplID; EmplID)
                { }

                trigger OnAfterGetRecord()
                begin
                    EmplID := true;
                end;
            }

            dataitem(EmployeeLedgerEntryApplyDoc; "Employee Ledger Entry")
            {
                DataItemLink = "Employee No." = field("Account No."), "Document Type" = field("Applies-to Doc. Type"), "Document No." = field("Applies-to Doc. No.");
                DataItemTableView = sorting("Posting Date") where("Applies-to Doc. No." = filter('<>""'));

                column(Posting_Date_ByEDoc; "Posting Date")
                { }
                column(Document_No_ByEDoc; "Document No.")
                { }
                column(Amount_to_Apply_ByEDoc; "Amount to Apply")
                {
                    AutoFormatExpression = EmployeeLedgerEntryApplyDoc."Currency Code";
                    AutoFormatType = 1;
                }
                column(EmplDoc; EmplDoc)
                { }

                trigger OnAfterGetRecord()
                begin
                    EmplDoc := true;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Vend: Record Vendor;
                Empl: Record Employee;
            begin
                GenPostDate := Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>');
                GenAmtLCY := Format("Amount (LCY)", 0, '<Precision,2><Sign><Integer Thousand><Decimals>');


                case GenJnlLine."Account Type" of
                    "Gen. Journal Account Type"::Vendor:
                        begin
                            Vend.Get(GenJnlLine."Account No.");
                            PayToName := Vend.Name;
                        end;
                    "Gen. Journal Account Type"::Employee:
                        begin
                            Empl.Get(GenJnlLine."Account No.");
                            PayToName := Empl.FullName();
                        end;
                end;

                Clear(VendID);
                Clear(VendDoc);
                Clear(EmplID);
                Clear(EmplDoc);
            end;
        }
    }


    var
        AmtToApply, TotalAmt : decimal;

        GenPostDate, GenAmtLCY : Text;

        VendID, VendDoc, EmplID, EmplDoc : Boolean;
        PayToName: Text;

}
