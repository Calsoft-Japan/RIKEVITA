/// <summary>
/// codeunit RV Bank Payment to Excel (ID 50104) 
/// FDD017 2026/04/13: New. (Liuyang)
/// </summary>
codeunit 50104 "RV Bank Payment to Excel"
{
    trigger OnRun()
    begin
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartRow, RowNo : Integer;

    procedure ExportSelectedLines(var GenJournalLine: Record "Gen. Journal Line"; ExpTye: Option Domestic,Jompay,GIRO)
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Create Header Row
        case ExpTye of
            ExpTye::Domestic:
                CreateDomesticExcelHeader();
            ExpTye::Jompay:
                CreateJompayExcelHeader();
            ExpTye::GIRO:
                CreateGIROExcelHeader();
        end;


        if GenJournalLine.FindSet() then
            repeat
                ProcessJournalLine(GenJournalLine, ExpTye);
            until GenJournalLine.Next() = 0;

        // Generate and Download Excel File
        TempExcelBuffer.CreateNewBook('BankExport');
        TempExcelBuffer.WriteSheet('Payments', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Bank_Payment_Export.xlsx');
        TempExcelBuffer.OpenExcel();
    end;

    local procedure ProcessJournalLine(GenJnlLine: Record "Gen. Journal Line"; ExpTye: Option Domestic,Jompay,GIRO)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        IsApplied: Boolean;
    begin
        IsApplied := false;

        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::Vendor:
                begin
                    // Scenario A: 1-to-Many Application (using Apply Entries)
                    VendorLedgerEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                    VendorLedgerEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
                    if VendorLedgerEntry.FindSet() then begin
                        IsApplied := true;
                        repeat
                            case ExpTye of
                                ExpTye::Domestic:
                                    WriteDomesticExcelRow(GenJnlLine, VendorLedgerEntry);
                                ExpTye::Jompay:
                                    WriteJompayExcelRow(GenJnlLine, VendorLedgerEntry);
                                ExpTye::GIRO:
                                    WriteGIROExcelRow(GenJnlLine, VendorLedgerEntry);
                            end;
                        until VendorLedgerEntry.Next() = 0;
                    end;

                    // Scenario B: 1-to-1 Application (directly on the journal line)
                    if (not IsApplied) and (GenJnlLine."Applies-to Doc. No." <> '') then begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                        VendorLedgerEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                        VendorLedgerEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                        if VendorLedgerEntry.FindFirst() then begin
                            IsApplied := true;
                            case ExpTye of
                                ExpTye::Domestic:
                                    WriteDomesticExcelRow(GenJnlLine, VendorLedgerEntry);
                                ExpTye::Jompay:
                                    WriteJompayExcelRow(GenJnlLine, VendorLedgerEntry);
                                ExpTye::GIRO:
                                    WriteGIROExcelRow(GenJnlLine, VendorLedgerEntry);
                            end;
                        end;
                    end;

                    // Scenario C: Payment on account (No application yet)
                    if not IsApplied then begin
                        Clear(VendorLedgerEntry);
                        case ExpTye of
                            ExpTye::Domestic:
                                WriteDomesticExcelRow(GenJnlLine, VendorLedgerEntry);
                            ExpTye::Jompay:
                                WriteJompayExcelRow(GenJnlLine, VendorLedgerEntry);
                            ExpTye::GIRO:
                                WriteGIROExcelRow(GenJnlLine, VendorLedgerEntry);
                        end;
                    end;
                end;

            GenJnlLine."Account Type"::Employee:
                begin
                    // Employee lines are output 1-to-1
                    Clear(VendorLedgerEntry);
                    case ExpTye of
                        ExpTye::Domestic:
                            WriteDomesticExcelRow(GenJnlLine, VendorLedgerEntry);
                        ExpTye::Jompay:
                            WriteJompayExcelRow(GenJnlLine, VendorLedgerEntry);
                    //ExpTye::GIRO:
                    //    WriteGIROExcelRow(GenJnlLine, VendorLedgerEntry); //GIRO is just for international Vendor
                    end;
                end;
        end;
    end;

    local procedure CreateDomesticExcelHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Payment Mode', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Value Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Reference Number', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transaction Amount (RM)', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Credit Account Number', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Beneficiary Name 1', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Beneficiary Name 2', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Beneficiary Name 3', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('New NIRC', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Old NIRC', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Business Registration No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Police/Army ID/Passport No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Beneficiary Bank Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Email', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Advice Detail', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Debit Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Credit Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Joint Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Joint New ID No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Joint Old ID No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Joint Business Reg. No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Joint Police/Army ID/Passport No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose of Transfer', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Other Purpose of Transfer', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Rentas Instruction to Bank', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Email 2', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Email 3', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        // Add more header columns as needed
    end;

    local procedure CreateJompayExcelHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Value Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transaction Amount (RM)', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Biller Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Reference -1', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Reference -2', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        // Add more header columns as needed
    end;

    local procedure CreateGIROExcelHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AccNo.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Value Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Segment Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BeneBank', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bene_AccNo', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BeneName', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Other Payment Details', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BeneID', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Recipient Reference', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NewIC', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OldIC', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BusinessNo', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Police_ArmyID_Passport', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPF_BatchDate', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPFNo', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PayerID', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Applicant Email', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Beneficiary Email', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Ref', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Desc', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Payment Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        // Add more header columns as needed
    end;

    local procedure WriteDomesticExcelRow(GenJnlLine: Record "Gen. Journal Line"; VLE: Record "Vendor Ledger Entry")
    var
        AppliedAmt: Decimal;
        Vend: Record Vendor;
        Empl: Record Employee;
        EmplLedgEntry: Record "Employee Ledger Entry";
        BankAcctNo, RegNo, PassportNo, Name1, Name2, Name3, Email, Advice : Text;
    begin
        PassportNo := '';
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) then begin
            Vend.Get(GenJnlLine."Account No.");
            BankAcctNo := Vend."Preferred Bank Account Code";
            Name1 := CopyStr(Vend.Name, 1, 40);
            Name2 := CopyStr(Vend.Name, 41, 80);
            Name3 := CopyStr(Vend.Name, 81, 100);
            RegNo := Vend."Registration Number";
            Email := vend."E-Mail";
            Advice := VLE.Description;
            if Vend."Partner Type" = Vend."Partner Type"::Person then
                PassportNo := Vend."RV_ID No./Passport No."
        end
        else if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee) then begin
            Empl.Get(GenJnlLine."Account No.");
            BankAcctNo := Empl."Bank Account No.";
            Name1 := CopyStr(Empl.FullName(), 1, 40);
            Name2 := CopyStr(Empl.FullName(), 41, 80);
            Name3 := CopyStr(Empl.FullName(), 81, 100);
            RegNo := '';
            Email := Empl."E-Mail";
            Advice := GenJnlLine.Description + GenJnlLine."RV_Description 2";
            if Empl."RV_Expat Employee" then
                PassportNo := Empl."RV_ID No./Passport No.";
        end;


        TempExcelBuffer.NewRow();

        // 1. Payment Journal Info
        TempExcelBuffer.AddColumn(GenJnlLine."Payment Method Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(GenJnlLine."Posting Date", 0, '<Closing><Day,2><Month,2><Year4>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        // 2. Applied Invoice Info
        AppliedAmt := GenJnlLine."Amount (LCY)";
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and (VLE."Document No." <> '') then begin
            // Calculate the specific applied amount for this VLE
            VLE.CalcFields("Amount to Apply");
            AppliedAmt := VLE."Amount to Apply";
            if AppliedAmt = 0 then
                AppliedAmt := VLE."Amount (LCY)"; // Fallback if Amount to apply isn't set manually
        end else if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee) then begin
            EmplLedgEntry.Reset();
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", GenJnlLine."Account No.");
            EmplLedgEntry.SetRange(Open, true);
            EmplLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
            if EmplLedgEntry.FindFirst() then begin
                EmplLedgEntry.CalcFields("Amount to Apply");
                AppliedAmt := EmplLedgEntry."Amount to Apply";
                if AppliedAmt = 0 then
                    AppliedAmt := EmplLedgEntry."Amount (LCY)";
            end else begin
                EmplLedgEntry.Reset();
                EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
                EmplLedgEntry.SetRange("Employee No.", GenJnlLine."Account No.");
                EmplLedgEntry.SetRange(Open, true);
                EmplLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                if EmplLedgEntry.FindSet() then
                    repeat
                        EmplLedgEntry.CalcFields("Amount to Apply");
                        if EmplLedgEntry."Amount to Apply" <> 0 then
                            AppliedAmt += EmplLedgEntry."Amount to Apply"
                        else
                            AppliedAmt += EmplLedgEntry."Amount (LCY)";
                    until EmplLedgEntry.Next() = 0;
            end;
        end;
        TempExcelBuffer.AddColumn(Abs(AppliedAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);


        TempExcelBuffer.AddColumn(BankAcctNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Name1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Name2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Name3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RegNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PassportNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GenJnlLine."Recipient Bank Account", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Email, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Advice, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);//<Applied Invoice Description>
        TempExcelBuffer.AddColumn(Name1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure WriteJompayExcelRow(GenJnlLine: Record "Gen. Journal Line"; VLE: Record "Vendor Ledger Entry")
    var
        AppliedAmt: Decimal;
        EmplLedgEntry: Record "Employee Ledger Entry";
        Vend: Record Vendor;
        Empl: Record Employee;
        Name1: Text;
    begin
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) then begin
            Vend.Get(GenJnlLine."Account No.");
            Name1 := Vend.Name;
        end
        else begin
            Empl.Get(GenJnlLine."Account No.");
            Name1 := Empl.FullName();
        end;

        AppliedAmt := GenJnlLine."Amount (LCY)";
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and (VLE."Document No." <> '') then begin
            // Calculate the specific applied amount for this VLE
            VLE.CalcFields("Amount to Apply");
            AppliedAmt := VLE."Amount to Apply";
            if AppliedAmt = 0 then
                AppliedAmt := VLE."Amount (LCY)"; // Fallback if Amount to apply isn't set manually
        end else if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee) then begin
            EmplLedgEntry.Reset();
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", GenJnlLine."Account No.");
            EmplLedgEntry.SetRange(Open, true);
            EmplLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
            if EmplLedgEntry.FindFirst() then begin
                EmplLedgEntry.CalcFields("Amount to Apply");
                AppliedAmt := EmplLedgEntry."Amount to Apply";
                if AppliedAmt = 0 then
                    AppliedAmt := EmplLedgEntry."Amount (LCY)";
            end else begin
                EmplLedgEntry.Reset();
                EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
                EmplLedgEntry.SetRange("Employee No.", GenJnlLine."Account No.");
                EmplLedgEntry.SetRange(Open, true);
                EmplLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                if EmplLedgEntry.FindSet() then
                    repeat
                        EmplLedgEntry.CalcFields("Amount to Apply");
                        if EmplLedgEntry."Amount to Apply" <> 0 then
                            AppliedAmt += EmplLedgEntry."Amount to Apply"
                        else
                            AppliedAmt += EmplLedgEntry."Amount (LCY)";
                    until EmplLedgEntry.Next() = 0;
            end;
        end;

        TempExcelBuffer.NewRow();

        // 1. Payment Journal Info
        TempExcelBuffer.AddColumn(Format(GenJnlLine."Posting Date", 0, '<Closing><Day,2><Month,2><Year4>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Abs(AppliedAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        TempExcelBuffer.AddColumn(Name1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GenJnlLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GenJnlLine."Your Reference", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;


    local procedure WriteGIROExcelRow(GenJnlLine: Record "Gen. Journal Line"; VLE: Record "Vendor Ledger Entry")
    var
        AppliedAmt: Decimal;
        CompanyInfo: Record "Company Information";
        RVSetup: Record "RV RIKEVITA Setup";
        Vend: Record Vendor;
        VnBank: Record "Vendor Bank Account";
        CompanyName: Text;
        CompanyBankAccountNo: Text;
        BankAcctNo, Email : Text;
    begin
        if CompanyInfo.Get() then begin
            CompanyName := CompanyInfo.Name;
            CompanyBankAccountNo := CompanyInfo."Bank Account No.";
        end;

        RVSetup.Reset();
        RVSetup.FindFirst();

        Vend.Get(GenJnlLine."Account No.");
        VnBank.Get(Vend."No.", Vend."Preferred Bank Account Code");
        BankAcctNo := VnBank.Code + VnBank.Name;

        if RVSetup."MUFG PIC 1" <> '' then
            Email := RVSetup."MUFG PIC 1" + ';';
        if RVSetup."MUFG PIC 2" <> '' then
            Email += RVSetup."MUFG PIC 2" + ';';
        if RVSetup."MUFG PIC 3" <> '' then
            Email += RVSetup."MUFG PIC 3";

        AppliedAmt := GenJnlLine."Amount (LCY)";
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and (VLE."Document No." <> '') then begin
            // Calculate the specific applied amount for this VLE
            VLE.CalcFields("Amount to Apply");
            AppliedAmt := VLE."Amount to Apply";
            if AppliedAmt = 0 then
                AppliedAmt := VLE."Amount (LCY)"; // Fallback if Amount to apply isn't set manually
        end;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyBankAccountNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(GenJnlLine."Posting Date", 0, '<Year4><Month,2><Day,2><Closing>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);//<Segment Code> dimension code setting to RIKEVITA Setup
        TempExcelBuffer.AddColumn(BankAcctNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(VnBank."Bank Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vend.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RVSetup."Recipient Ref. Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vend."Registration Number", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Email, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vend."E-Mail", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(VLE."Applies-to Doc. No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(VLE."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AppliedAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;


    #region load from local file or presaved template in RV Setup table

    procedure LoadBankTemplate(var BankTemplateBlobRef: Codeunit "Temp Blob")//Upload manully from local template file
    var
        FileInStream: InStream;
        BlobOutStream: OutStream;
        FileName: Text;
        UploadMsg: Label 'Please select the Bank Excel Template';
        FilterTxt: Label 'Excel Files (*.xlsx)|*.xlsx';
    begin
        // 1. Prompt the user to upload the Excel file
        if UploadIntoStream(UploadMsg, '', FilterTxt, FileName, FileInStream) then begin

            // 2. Clear any existing data in the Temp Blob just in case
            Clear(BankTemplateBlobRef);

            // 3. Create an OutStream to write into the Temp Blob
            BankTemplateBlobRef.CreateOutStream(BlobOutStream);

            // 4. Copy the uploaded file's data (InStream) into the Temp Blob (OutStream)
            CopyStream(BlobOutStream, FileInStream);

            Message('Template %1 loaded successfully.', FileName);
        end else
            Error('Template upload was cancelled.');
    end;

    procedure LoadBankTemplateFromSetup(var BankTemplateBlobRef: Codeunit "Temp Blob"; ExpType: Option Domestic,Jompay,GIRO)//Load from Blob
    var
        BankExportSetup: Record "RV RIKEVITA Setup"; // setup table
        SetupInStream: InStream;
        BlobOutStream: OutStream;
    begin
        // Get the setup record
        BankExportSetup.Get();

        case ExpType of
            ExpType::Domestic:
                begin
                    BankExportSetup.CalcFields("Demostic Excel Template");

                    if not BankExportSetup."Demostic Excel Template".HasValue() then
                        Error('No Excel template has been uploaded to the setup table.');

                    // Create an InStream to read from the setup table
                    BankExportSetup."Demostic Excel Template".CreateInStream(SetupInStream);
                end;
            ExpType::Jompay:
                begin
                    BankExportSetup.CalcFields("Jompay Excel Template");

                    if not BankExportSetup."Jompay Excel Template".HasValue() then
                        Error('No Excel template has been uploaded to the setup table.');

                    // Create an InStream to read from the setup table
                    BankExportSetup."Jompay Excel Template".CreateInStream(SetupInStream);
                end;
            ExpType::GIRO:
                begin
                    BankExportSetup.CalcFields("GIRO Excel Template");

                    if not BankExportSetup."GIRO Excel Template".HasValue() then
                        Error('No Excel template has been uploaded to the setup table.');

                    // Create an InStream to read from the setup table
                    BankExportSetup."GIRO Excel Template".CreateInStream(SetupInStream);
                end;
        end;
        // Create an OutStream to write into your Temp Blob
        BankTemplateBlobRef.CreateOutStream(BlobOutStream);

        // Copy the data
        CopyStream(BlobOutStream, SetupInStream);
    end;

    procedure ExportToTemplate(var GenJournalLine: Record "Gen. Journal Line"; ExpTye: Option Domestic,Jompay,GIRO)
    var

        TempExcelBuffer: Record "Excel Buffer" temporary;
        BankTemplateBlobRef: Codeunit "Temp Blob";
    // Load the bank template from a setup table or Media field
    begin
        // 1. Load template binary into TempBlob
        //LoadBankTemplate(BankTemplateBlobRef);
        LoadBankTemplateFromSetup(BankTemplateBlobRef, ExpTye);

        // 2. Open the template into Excel Buffer for editing
        TempExcelBuffer.OpenBookStream(
            BankTemplateBlobRef.CreateInStream(),
            'Sheet1');      // Sheet name in the bank template

        // 3. Write fixed header cells by exact row/column coordinate
        // WriteCell(TempExcelBuffer, 5, 2, Format(TempBuffer."Posting Date"));   // B5
        // WriteCell(TempExcelBuffer, 8, 3, TempBuffer."Account Name");            // C8
        // WriteCell(TempExcelBuffer, 8, 4, TempBuffer."Beneficiary Bank Account");// D8

        // 4. Write repeating invoice lines starting at row 10
        StartRow := 10;
        WriteInvoiceLines(TempExcelBuffer, GenJournalLine, StartRow, ExpTye);

        // 5. Download the filled Excel
        //DownloadExcel(TempExcelBuffer);
        TempExcelBuffer.CreateNewBook('BankExport');
        TempExcelBuffer.WriteSheet('Payments', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Bank_Payment_Export.xlsx');
        TempExcelBuffer.OpenExcel();

    end;

    local procedure WriteCell(var ExcelBuffer: Record "Excel Buffer"; RowNo: Integer; ColNo: Integer; CellValue: Text)
    begin
        ExcelBuffer.Init();
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColNo);
        ExcelBuffer."Cell Value as Text" := CopyStr(CellValue, 1, 250);
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        if not ExcelBuffer.Insert() then
            ExcelBuffer.Modify();
    end;

    local procedure WriteInvoiceLines(var ExcelBuffer: Record "Excel Buffer"; var GenJournalLine: Record "Gen. Journal Line"; StartRow: Integer; ExpTye: Option Domestic,Jompay,GIRO)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CurrentRow: Integer;
    begin
        CurrentRow := StartRow;
        GenJournalLine.Reset();
        if GenJournalLine.FindSet() then
            repeat
                WriteCell(ExcelBuffer, CurrentRow, 2, GenJournalLine."Payment Method Code");
                WriteCell(ExcelBuffer, CurrentRow, 3, Format(GenJournalLine."Due Date"));
                WriteCell(ExcelBuffer, CurrentRow, 4, Format(GenJournalLine."Amount (LCY)"));
                WriteCell(ExcelBuffer, CurrentRow, 5, GenJournalLine."Description");
                CurrentRow += 1;
            until GenJournalLine.Next() = 0;
    end;

    #endregion
}
