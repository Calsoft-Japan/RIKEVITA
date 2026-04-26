/// <summary>
/// pageextension RV Payment Journal Ext (ID 50113) extends "Payment Journal" page
/// FDD017 2026/04/13: New. (Liuyang)
/// </summary>
pageextension 50113 "RV Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter(Description)
        {
            field("RV_Description 2"; Rec."RV_Description 2")
            {
                Description = 'FDD017';
                ApplicationArea = All;
            }
        }

        addafter("Recipient Bank Account")
        {
            field("RV_Expat Employee"; Rec."RV_Expat Employee")
            {
                Description = 'FDD017';
                ApplicationArea = All;
            }
            field("RV_Partner Type"; Rec."RV_Partner Type")
            {
                Description = 'FDD017';
                ApplicationArea = All;
            }
            field("RV_ID No./Passport No."; Rec."RV_ID No./Passport No.")
            {
                Description = 'FDD017';
                ApplicationArea = All;
                MaskType = Concealed;
            }

        }

        addbefore("Amount (LCY)")
        {
            field("RV_Cheque No."; Rec."RV_Cheque No.")
            {
                Caption = 'Check No.';
                Description = 'FDD016';
                ApplicationArea = All;
                Editable = false;
            }

            field("RV_APV No."; Rec."RV_APV No.")
            {
                Description = 'FDD016';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addbefore(PrintCheck)
        {
            action(PrintVoucher)
            {
                Description = 'FDD017';
                Caption = 'Payment Voucher';
                ApplicationArea = All;
                Image = Print;
                Ellipsis = true;


                trigger OnAction()
                var
                    RptPayVoucher: Report "RV Payment Voucher";
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    //Report.RunModal(Report::"RV Payment Voucher", true, false, Rec);
                    GenJournalLine.Reset();
                    GenJournalLine.Copy(Rec);
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");

                    RptPayVoucher.SetTableView(GenJournalLine);
                    RptPayVoucher.RunModal();
                end;
            }
        }
        addlast(Category_Category11)
        {
            actionref(PrintCheck_PrintVoucher; PrintVoucher)
            {
            }
        }

        addlast(processing)
        {
            group(ExportExcel)
            {
                Description = 'FDD017';
                Caption = 'Export to Excel';
                Image = Excel;
                action(DomesticExp)
                {
                    ApplicationArea = All;
                    Image = Excel;
                    Caption = 'Domestic Payments (MayBank)';

                    trigger OnAction()
                    var
                        /* EmplLedgEntry: Record "Employee Ledger Entry";
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        AppliedVendLedEntry: Record "Vendor Ledger Entry";
                        AppliedEmpEntry: Page "Applied Employee Entries";
                        AppliedVendEntry: Page "Applied Vendor Entries";
                        ApplyEmpEntry: Page "Apply Employee Entries";
                        ApplyVendEntry: page "Apply Vendor Entries";
                        GenApply: Codeunit "Gen. Jnl.-Apply"; */
                        CUExportExcel: Codeunit "RV Bank Payment to Excel";
                    begin
                        if Confirm(Text001) then
                            CUExportExcel.ExportSelectedLines(Rec, ExpType::Domestic);
                        /* case Rec."Account Type" of
                            Rec."Account Type"::Vendor:
                                begin
                                    //ApplyVendorLedgerEntry(GenJnlLine);
                                    VendLedgEntry.Reset();
                                    VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                    VendLedgEntry.SetRange("Vendor No.", Rec."Account No.");
                                    VendLedgEntry.SetRange(Open, true);
                                    VendLedgEntry.SetRange("Applies-to ID", Rec."Applies-to ID");

                                    //AppliedVendLedEntry.Reset();
                                    //AppliedVendLedEntry.SetCurrentKey("Closed by Entry No.");
                                    //AppliedVendLedEntry.SetRange("Closed by Entry No.", VendLedgEntry."Entry No."); 
                                end;
                            Rec."Account Type"::Employee:
                                begin
                                    //ApplyEmployeeLedgerEntry(GenJnlLine);
                                    EmplLedgEntry.Reset();
                                    EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
                                    EmplLedgEntry.SetRange("Employee No.", Rec."Account No.");
                                    EmplLedgEntry.SetRange(Open, true);
                                    EmplLedgEntry.SetRange("Applies-to ID", Rec."Applies-to ID");
                                end;
                        end; */
                    end;
                }
                action(JompayExp)
                {
                    ApplicationArea = All;
                    Image = Excel;
                    Caption = 'Utility Payment - Jompay (MayBank)';
                    trigger OnAction()
                    var
                        CUExportExcel: Codeunit "RV Bank Payment to Excel";
                    //RptExport: Report "RV Export Payment Inv Excel";
                    //DesignTimeRptSelect: Codeunit "Design-time Report Selection";
                    begin
                        if Confirm(Text001) then
                            CUExportExcel.ExportSelectedLines(Rec, ExpType::Jompay);


                        /* DesignTimeRptSelect.SetSelectedLayout('Jompay');
                        RptExport.SetPaymentTempBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                        RptExport.Run(); */
                    end;
                }
                action(GIROExp)
                {
                    ApplicationArea = All;
                    Image = Excel;
                    Caption = 'GIRO Payments (MUFG)';
                    trigger OnAction()
                    var
                        GenJnlLine: Record "Gen. Journal Line";
                        CUExportExcel: Codeunit "RV Bank Payment to Excel";
                    begin
                        if Confirm(Text001) then
                            CUExportExcel.ExportSelectedLines(Rec, ExpType::GIRO);
                    end;
                }

            }
        }

        addlast(Promoted)
        {
            group(Category_CategoryExpExcel)
            {
                Caption = 'Export to Excel', Comment = 'Export payment invoice to excel.';

                actionref(DomesticExp_Promoted; DomesticExp)
                {
                }
                actionref(JompayExp_Promoted; JompayExp)
                {
                }
                actionref(GIROExp_Promoted; GIROExp)
                {
                }
            }
        }
    }

    var
        ExpType: Option Domestic,Jompay,GIRO;
        TEXT001: Label 'Electronic Payment Excel Template will be exported. Do you want to continue?';
}
