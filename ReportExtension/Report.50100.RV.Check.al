reportextension 50100 "RV Check" extends Check
{
    RDLCLayout = '.\ReportLayout\RV_CheckWithDetail.rdlc';
    dataset
    {
        add(GenJnlLine)
        {
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
            column(TotalAmtText1; TotalAmtText[1])
            { }
            column(TotalAmtText2; TotalAmtText[2])
            { }
            column(GenAmtLCY; GenAmtLCY)
            { }
        }

        add(PrintSettledLoop)
        {
            column(AmtToApply; AmtToApply)
            {
                AutoFormatExpression = GenJnlLine."Currency Code";
                AutoFormatType = 1;
            }
        }

        add(PrintCheck)
        {
            column(TotalAmt; TotalAmt)
            {
                AutoFormatExpression = GenJnlLine."Currency Code";
                AutoFormatType = 1;
            }
        }

        modify(GenJnlLine)
        {
            trigger OnAfterAfterGetRecord()
            begin
                FormatNoText(TotalAmtText, "Amount (LCY)", "Currency Code");
                TotalAmtText[1] := TotalAmtText[1].Replace('****', '');
                GenPostDate := Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>');
                GenAmtLCY := Format("Amount (LCY)", 0, '<Precision,2><Sign><Integer Thousand><Decimals>');
            end;
        }

        modify(PrintSettledLoop)
        {
            trigger OnAfterPreDataItem()
            begin
                Clear(TotalAmt);
            end;

            trigger OnAfterAfterGetRecord()
            begin
                Clear(AmtToApply);

                case GenJnlLine."Account Type" of
                    "Gen. Journal Account Type"::Vendor:
                        begin
                            VendLedgEntry.Reset();

                            if GenJnlLine."Applies-to ID" <> '' then begin
                                VendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open);
                                VendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                                VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                            end else begin
                                VendLedgEntry.SetCurrentKey("Document No.");
                                VendLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                VendLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                VendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                            end;

                            if VendLedgEntry.FindSet() then
                                AmtToApply := VendLedgEntry."Amount to Apply";
                        end;
                    "Gen. Journal Account Type"::Employee:
                        begin
                            EmployeeLedgerEntry.Reset();

                            if GenJnlLine."Applies-to ID" <> '' then begin
                                EmployeeLedgerEntry.SetCurrentKey("Employee No.", "Applies-to ID", Open);
                                EmployeeLedgerEntry.SetRange("Employee No.", GenJnlLine."Account No.");
                                EmployeeLedgerEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                EmployeeLedgerEntry.SetRange(Open, true);
                            end else begin
                                EmployeeLedgerEntry.SetCurrentKey("Document No.");
                                EmployeeLedgerEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                EmployeeLedgerEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                EmployeeLedgerEntry.SetRange("Employee No.", GenJnlLine."Account No.");
                            end;

                            if EmployeeLedgerEntry.FindSet() then
                                AmtToApply := EmployeeLedgerEntry."Amount to Apply";
                        end;
                end;

                TotalAmt := TotalAmt + AmtToApply;
            end;
        }
    }

    var
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        Employee: Record Employee;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        AmtToApply, TotalAmt : decimal;

        TotalAmtText: array[2] of Text[80];

        GenPostDate, GenAmtLCY : Text;
}
