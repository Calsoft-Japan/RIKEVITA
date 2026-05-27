/// <summary>
/// Report RV Aged Accounts Payable (ID 50400).
/// FDD030 2026/04/15: New. (Vani)
/// Custom version of standard BC Aged Accounts Payable report.
/// </summary>
report 50400 "RV Aged Accounts Payable"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\RV_AgedAccountsPayable_checked_fixed.rdlc';
    ApplicationArea = All;
    Caption = 'RIKE Aged Accounts Payable';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        // -----------------------------------------------------------------------------
        // DATASET STRUCTURE
        // Vendor                         : Main vendor loop and report header fields.
        // Vendor Ledger Entry            : Finds entries closed after the ending date and
        //                                  adds related entries into TempVendorLedgEntry.
        // OpenVendorLedgEntry            : Adds open entries up to the ending date into
        //                                  TempVendorLedgEntry.
        // CurrencyLoop                   : Prints one set of vendor ledger entries per currency.
        // TempVendortLedgEntryLoop       : Calculates aging bucket amounts row by row.
        // CurrencyTotals                 : Builds Currency Specification rows by currency.
        // -----------------------------------------------------------------------------
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Currency Filter";

            column(TodayFormatted; TodayFormatted)
            {
            }
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(NewPagePerVendor; NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate; StrSubstNo(Text006, Format(EndingDate, 0, 4)))
            {
            }
            column(SelectAgeByDuePostngDocDt; StrSubstNo(Text007, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter; TableCaption + ': ' + VendorFilter)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }

            // FDD030: Vendor filter range displayed as Trading Partner From / To.
            column(RV_TradingPartnerFrom; TradingPartnerFrom)
            {
            }
            column(RV_TradingPartnerTo; TradingPartnerTo)
            {
            }

            // FDD030: Show currency filter value in report header.
            column(RV_CurrencyFilter; CurrencyFilterTxt)
            {
            }

            // FDD030: Expose selected heading type for RDLC layout.
            column(RV_ReportHeadingType; Format(HeadingType))
            {
            }

            column(RV_CompanyDisplayName; CompanyDisplayName)
            {
            }
            column(RV_PrintedDateTime; TodayFormatted)
            {
            }

            // FDD030: User ID displayed in the report header.
            column(RV_UserID; UserId)
            {
            }

            // FDD030: Header filter text displayed near report title.
            column(RV_FilterByText; FilterByText)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }

            // FDD030: Request page option used to show/hide vendor bank details in RDLC.
            column(RV_PrintBankDetails; PrintBankDetails)
            {
            }

            // FDD030: Second title line showing report aging date.
            column(RV_AsAtDateText; 'AS AT ' + Format(EndingDate, 0, 4))
            {
            }

            column(AgingBy; AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1; StrSubstNo(Text004, SelectStr(AgingBy + 1, Text009)))
            {
            }

            column(HeaderText1; HeaderText[1])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }

            // FDD030: Added sixth aging bucket header for 4MTH+ / After 120 days.
            column(HeaderText6; HeaderText[6])
            {
            }

            // FDD030: Top aging header row: Current, 1MTH, 2MTH, 3MTH, 4MTH, 4MTH+.
            column(TopHeaderText1; TopHeaderText[1])
            {
            }
            column(TopHeaderText2; TopHeaderText[2])
            {
            }
            column(TopHeaderText3; TopHeaderText[3])
            {
            }
            column(TopHeaderText4; TopHeaderText[4])
            {
            }
            column(TopHeaderText5; TopHeaderText[5])
            {
            }
            column(TopHeaderText6; TopHeaderText[6])
            {
            }

            // FDD030: Added sixth grand total aging bucket.
            column(GrandTotalVLE6RemAmtLCY; GrandTotalVLERemaingAmtLCY[6])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE5RemAmtLCY; GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY; GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY; GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY; GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY; GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLEAmtLCY; GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }

            column(PageGroupNo; PageGroupNo)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            // FDD030: Dynamic report title for Summary / Detail layout.
            column(AgedAcctPayableCaption; ReportTitleTxt)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption; AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption; AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption; GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption; AmountLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocNoCaption)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption; FieldCaption("No."))
            {
            }
            column(VendorNameCaption; FieldCaption(Name))
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            column(VendorPhoneNoCaption; FieldCaption("Phone No."))
            {
            }
            column(VendorContactCaption; FieldCaption(Contact))
            {
            }

            // Standard BC logic: process vendor ledger entries posted after the ending date,
            // then find related closing entries posted on/before the ending date.
            // These are not printed directly; they are inserted into TempVendorLedgEntry.
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No.");
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                var
                    VendorLedgEntry: Record "Vendor Ledger Entry";
                begin
                    // Collect entries that were closed by this entry or related to this closure.
                    // The actual report lines are printed from TempVendorLedgEntryLoop, so this
                    // dataitem only prepares the temporary dataset and then skips itself.
                    VendorLedgEntry.SetCurrentKey("Closed by Entry No.");
                    VendorLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    ApplyCurrencyFilterToVendLedgEntry(VendorLedgEntry);

                    if VendorLedgEntry.FindSet(false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next() = 0;

                    if "Closed by Entry No." <> 0 then begin
                        VendorLedgEntry.SetRange("Closed by Entry No.", "Closed by Entry No.");
                        if VendorLedgEntry.FindSet(false) then
                            repeat
                                InsertTemp(VendorLedgEntry);
                            until VendorLedgEntry.Next() = 0;
                    end;

                    VendorLedgEntry.Reset();
                    VendorLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    ApplyCurrencyFilterToVendLedgEntry(VendorLedgEntry);

                    if VendorLedgEntry.FindSet(false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next() = 0;

                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", EndingDate + 1, DMY2Date(31, 12, 9999));
                    CopyDimFiltersFromVendor("Vendor Ledger Entry");
                    //Vendor.CopyFilter("Currency Filter", "Currency Code");
                    ApplyCurrencyFilterToVendLedgEntry("Vendor Ledger Entry");
                end;
            }

            // Standard BC logic: collect currently open vendor ledger entries that must be
            // included in the aging calculation as of the selected EndingDate.
            dataitem(OpenVendorLedgEntry; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No.");
                DataItemTableView = sorting("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                begin
                    // Add open entries into the temporary ledger table.
                    // For Posting Date aging, skip entries that have no Remaining Amt. (LCY).
                    if AgingBy = AgingBy::"Posting Date" then begin
                        CalcFields("Remaining Amt. (LCY)");
                        if "Remaining Amt. (LCY)" = 0 then
                            CurrReport.Skip();
                    end;

                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        SetRange("Posting Date", 0D, EndingDate);
                        SetRange("Date Filter", 0D, EndingDate);
                    end;

                    CopyDimFiltersFromVendor(OpenVendorLedgEntry);
                    //Vendor.CopyFilter("Currency Filter", "Currency Code");
                    ApplyCurrencyFilterToVendLedgEntry(OpenVendorLedgEntry);
                end;
            }

            // CurrencyLoop prints the aging rows currency by currency.
            // If Print Amounts in LCY is false, TempCurrency contains one row per currency.
            // If Print Amounts in LCY is true, a single blank/LCY currency is used.
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                PrintOnlyIfDetail = true;

                // Iterates TempVendorLedgEntry and calculates the row values shown in Section B.
                // Section B 6th bucket remains the real 4MTH+ aging bucket only.
                dataitem(TempVendortLedgEntryLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                    column(VendorName; Vendor.Name)
                    {
                    }
                    column(VendorNo; Vendor."No.")
                    {
                    }
                    column(VendorPhoneNo; Vendor."Phone No.")
                    {
                    }
                    column(VendorContactName; Vendor.Contact)
                    {
                    }

                    // FDD030: Vendor payment terms displayed in detail section.
                    column(RV_PaymentTermsCode; PaymentTermsCode)
                    {
                    }
                    column(RV_RowPrintDetails; PrintDetails)
                    {
                    }

                    column(RV_RowPrintBankDetails; PrintBankDetails)
                    {
                    }

                    // FDD030: Document Date displayed in detail section.
                    column(RV_DocumentDate; Format(VendorLedgEntryEndingDate."Document Date"))
                    {
                    }

                    // FDD030: Exchange rate displayed in detail section.
                    column(RV_ExchangeRate; ExchangeRate)
                    {
                        DecimalPlaces = 0 : 6;
                    }

                    column(RV_ExchangeRateText; ExchangeRateText)
                    {
                    }

                    // FDD030: Row-level vendor bank fields for RDLC detail scope.
                    column(RV_RowVendorBankName; VendorBankName)
                    {
                    }

                    column(RV_RowSwiftCode; VendorSwiftCode)
                    {
                    }

                    column(RV_RowBankAccountNo; VendorBankAccountNo)
                    {
                    }

                    column(RV_RowBankInfo; RowBankInfo)
                    {
                    }
                    // FDD030: Vendor bank details from Vendor Bank Account.
                    column(RV_VendorBankName; VendorBankName)
                    {
                    }
                    column(RV_VendorSwiftCode; VendorSwiftCode)
                    {
                    }
                    column(RV_VendorBankAccountNo; VendorBankAccountNo)
                    {
                    }

                    // FDD030: RM Equivalent Amount. For foreign currency entries, use Amount (LCY).
                    column(RV_RMEquivAmount; RMEquivAmount)
                    {
                        AutoFormatType = 1;
                    }

                    column(VLEEndingDateRemAmtLCY; VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmtLCY; AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY; AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY; AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY; AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY; AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }

                    // FDD030: Added sixth aging bucket amount in LCY.
                    column(AgedVendLedgEnt6RemAmtLCY; AgedVendorLedgEntry[6]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }

                    column(AgedVendLedgEnt1RemAmt; AgedVendorLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt; AgedVendorLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt; AgedVendorLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt; AgedVendorLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmt; AgedVendorLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    // FDD030: Added sixth aging bucket amount in document currency.
                    column(AgedVendLedgEnt6RemAmt; AgedVendorLedgEntry[6]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    column(VendLedgEntryEndDtAmtLCY; VendorLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate; Format(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo; DocumentNo)
                    {
                    }
                    column(VendLedgEntyEndgDtDocType; Format(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(VendLedgEntryEndDtPostgDt; Format(VendorLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(VLEEndingDateRemAmt; VendorLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt; VendorLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName; StrSubstNo(Text005, Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PeriodIndex: Integer;
                    begin
                        // Print one temporary vendor ledger entry row.
                        // This is the main calculation point for Section B: payment terms,
                        // bank details, RM equiv., remaining amounts, and aging bucket values.
                        if Number = 1 then begin
                            if not TempVendorLedgEntry.FindSet(false) then
                                CurrReport.Break();
                        end else
                            if TempVendorLedgEntry.Next() = 0 then
                                CurrReport.Break();

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;

                        // FDD030: Payment Terms is required in the detail section.
                        // Source: Vendor Payment Terms Code.
                        PaymentTermsCode := Vendor."Payment Terms Code";

                        // FDD030: Vendor bank details are displayed when Print Bank Details is enabled.
                        // Primary source is Preferred Bank Account Code.
                        // If no preferred bank exists, use the first available Vendor Bank Account.
                        Clear(VendorBankName);
                        Clear(VendorSwiftCode);
                        Clear(VendorBankAccountNo);

                        if Vendor."Preferred Bank Account Code" <> '' then begin
                            if VendorBankAccount.Get(Vendor."No.", Vendor."Preferred Bank Account Code") then begin
                                VendorBankName := VendorBankAccount.Name;
                                VendorSwiftCode := VendorBankAccount."SWIFT Code";
                                VendorBankAccountNo := VendorBankAccount."Bank Account No.";
                            end;
                        end else begin
                            VendorBankAccount.Reset();
                            VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
                            if VendorBankAccount.FindFirst() then begin
                                VendorBankName := VendorBankAccount.Name;
                                VendorSwiftCode := VendorBankAccount."SWIFT Code";
                                VendorBankAccountNo := VendorBankAccount."Bank Account No.";
                            end;
                        end;

                        // FDD030: Build one combined bank information text for RDLC.
                        // This is easier and safer than using multiple textboxes in different RDLC scopes.
                        Clear(RowBankInfo);

                        if PrintBankDetails then begin
                            if VendorBankName <> '' then
                                RowBankInfo := 'Bank Name: ' + VendorBankName;

                            if VendorSwiftCode <> '' then begin
                                if RowBankInfo <> '' then
                                    RowBankInfo += ' | ';
                                RowBankInfo += 'SWIFT: ' + VendorSwiftCode;
                            end;

                            if VendorBankAccountNo <> '' then begin
                                if RowBankInfo <> '' then
                                    RowBankInfo += ' | ';
                                RowBankInfo += 'Account No.: ' + VendorBankAccountNo;
                            end;
                        end;

                        // Standard aging calculation: detailed vendor ledger entries must be filtered
                        // by the current Vendor Ledger Entry No. before FindSet().
                        DetailedVendorLedgerEntry.Reset();
                        DetailedVendorLedgerEntry.SetRange("Vendor Ledger Entry No.", VendorLedgEntryEndingDate."Entry No.");

                        if DetailedVendorLedgerEntry.FindSet(false) then
                            repeat
                                if (DetailedVendorLedgerEntry."Entry Type" =
                                    DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") and
                                   (VendorLedgEntryEndingDate."Posting Date" > EndingDate) and
                                   (AgingBy <> AgingBy::"Posting Date")
                                then
                                    if (VendorLedgEntryEndingDate."Document Date" <= EndingDate) and
                                       (VendorLedgEntryEndingDate."Posting Date" <= EndingDate)
                                    then
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                          VendorLedgEntryEndingDate."Document Date"
                                    else
                                        if (VendorLedgEntryEndingDate."Due Date" <= EndingDate) and
                                           (AgingBy = AgingBy::"Due Date")
                                        then
                                            DetailedVendorLedgerEntry."Posting Date" :=
                                              VendorLedgEntryEndingDate."Due Date";

                                if (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) or
                                   (TempVendorLedgEntry.Open and
                                    (AgingBy = AgingBy::"Due Date") and
                                    (VendorLedgEntryEndingDate."Due Date" > EndingDate) and
                                    (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                then begin
                                    if DetailedVendorLedgerEntry."Entry Type" in
                                       [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    then begin
                                        VendorLedgEntryEndingDate.Amount :=
                                            VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Amount (LCY)" :=
                                            VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;

                                    if DetailedVendorLedgerEntry."Posting Date" <= EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" :=
                                            VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                end;
                            until DetailedVendorLedgerEntry.Next() = 0;

                        if UseExternalDocNo then
                            DocumentNo := VendorLedgEntryEndingDate."External Document No."
                        else
                            DocumentNo := VendorLedgEntryEndingDate."Document No.";

                        if VendorLedgEntryEndingDate."Remaining Amount" = 0 then
                            CurrReport.Skip();

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                begin
                                    if VendorLedgEntryEndingDate."Document Date" > EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                    end;

                                    PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                end;
                        end;

                        Clear(AgedVendorLedgEntry);

                        // FDD030: PeriodIndex now supports six aging buckets.
                        // The added bucket is index 5 = 91-120 days / 4MTH.
                        // The last bucket is index 6 = After 120 days / 4MTH+.
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" :=
                            VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" :=
                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" +=
                            VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" +=
                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        GrandTotalVLERemaingAmtLCY[PeriodIndex] +=
                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        TotalVendorLedgEntry[1].Amount +=
                            VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" +=
                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        GrandTotalVLEAmtLCY +=
                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        // FDD030: RM Equiv. shown on the report row.
                        // Current implementation uses Remaining Amt. (LCY), matching the verified report output.
                        // If the FDD is later interpreted as original Amount (LCY), change this to
                        // VendorLedgEntryEndingDate."Amount (LCY)".
                        RMEquivAmount := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        // FDD030: Exchange Rate shown on the report row.
                        // For foreign currency entries, calculate approximate exchange rate from
                        // Remaining Amt. (LCY) / Remaining Amount.
                        // For LCY entries, keep blank.
                        Clear(ExchangeRate);
                        Clear(ExchangeRateText);

                        if (VendorLedgEntryEndingDate."Currency Code" <> '') and
                           (VendorLedgEntryEndingDate."Remaining Amount" <> 0)
                        then begin
                            ExchangeRate := Abs(VendorLedgEntryEndingDate."Remaining Amt. (LCY)" / VendorLedgEntryEndingDate."Remaining Amount");
                            ExchangeRateText := Format(ExchangeRate);
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals();
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not PrintAmountInLCY then
                            TempVendorLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalVendorLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.FindSet(false) then
                            CurrReport.Break();
                    end else
                        if TempCurrency.Next() = 0 then
                            CurrReport.Break();

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if NewPagePerVendor then
                    PageGroupNo := PageGroupNo + 1;

                TempCurrency.Reset();
                TempCurrency.DeleteAll();

                TempVendorLedgEntry.Reset();
                TempVendorLedgEntry.DeleteAll();

                Clear(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }

        // Currency Specification section.
        // This section uses TempCurrency2 and TempCurrencyAmount prepared by UpdateCurrencyTotals().
        // Important: the final/total column is RV_CurrencySpecTotalAmount, not the 6th aging bucket.
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

            column(Number_CurrencyTotals; Number)
            {
            }
            column(NewPagePerVend_CurrTotal; NewPagePerVendor)
            {
            }
            column(TempCurrency2Code; TempCurrency2.Code)
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            // FDD030: Currency Specification total/balance amount by currency.
            // RDLC uses this field for the Total/Balance column in the Currency Specification section.
            // FDD030: Currency Specification total/balance amount by currency.
            // RDLC usage:
            //   - Use this for the Total/Balance column in Currency Specification.
            //   - Do NOT use AgedVendLedgEnt6RemAmtLCY6 for this total.
            // AgedVendLedgEnt6RemAmtLCY6 is reserved for the real 4MTH+ bucket.
            column(RV_CurrencySpecTotalAmount; CurrencySpecTotalAmount)
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt1RemAmtLCY1; AgedVendorLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2; AgedVendorLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3; AgedVendorLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4; AgedVendorLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5; AgedVendorLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }

            // FDD030: Added sixth currency total bucket.
            column(AgedVendLedgEnt6RemAmtLCY6; AgedVendorLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = TempCurrency2.Code;
                AutoFormatType = 1;
            }

            column(CurrencySpecificationCaption; CurrencySpecificationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // Standard BC pattern: move through the temporary currency list one currency at a time.
                if Number = 1 then begin
                    if not TempCurrency2.FindSet(false) then
                        CurrReport.Break();
                end else
                    if TempCurrency2.Next() = 0 then
                        CurrReport.Break();

                // FDD030: Build Currency Specification values for the current currency.
                // AgedVendorLedgEntry[1..6] are true aging bucket amounts only.
                // CurrencySpecTotalAmount is the separate total/balance amount for the currency.
                Clear(AgedVendorLedgEntry);
                Clear(CurrencySpecTotalAmount);

                TempCurrencyAmount.Reset();
                TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);

                if TempCurrencyAmount.FindSet(false) then
                    repeat
                        if TempCurrencyAmount.Date <> DMY2Date(31, 12, 9999) then
                            AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                                TempCurrencyAmount.Amount
                        else
                            CurrencySpecTotalAmount := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'About Aged Accounts Payable';
        AboutText = 'Analyze vendor balances at the end of each period by calculating outstanding invoice, credit memo, and payment totals in periods of equal length. Monitor unpaid invoices and prioritize payments for overdue accounts.';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies whether the aging is calculated from the due date, posting date, or document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period length used to calculate aging buckets.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies whether amounts are printed in local currency.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies whether detailed vendor ledger entries are printed.';
                    }

                    // FDD030: Added Number of Months option.
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days,Number of Months';
                        ToolTip = 'Specifies whether the aging column heading shows date interval, number of days, or number of months.';
                    }
                    field(NewPagePerVendor; NewPagePerVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies whether each vendor starts on a new page.';
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use External Document No.';
                        ToolTip = 'Specifies whether external document numbers are printed instead of internal document numbers.';
                    }

                    // FDD030: New option to control vendor bank details display in RDLC.
                    field(PrintBankDetails; PrintBankDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Bank Details';
                        ToolTip = 'Specifies whether vendor bank details are printed in the report.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate();

            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<1M>');
        end;
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        // Prepare report-level values before any dataitems run: filters, date buckets,
        // RDLC headings, dynamic title, company name, and document number caption.
        VendorFilter := FormatDocument.GetRecordFiltersWithCaptions(Vendor);

        SetTradingPartnerFilterText();

        GLSetup.Get();

        CalcDates();
        CreateHeadings();

        // FDD030: Set report title dynamically based on Print Details option.
        if PrintDetails then
            ReportTitleTxt := 'ACCOUNT PAYABLE AGING REPORT'
        else
            ReportTitleTxt := 'ACCOUNT PAYABLE AGING SUMMARY REPORT';

        TodayFormatted := Format(CurrentDateTime());
        CompanyDisplayName := COMPANYPROPERTY.DisplayName();
        CurrencyFilterTxt := Vendor.GetFilter("Currency Filter");

        FilterByText := 'Action Date';

        if UseExternalDocNo then
            DocNoCaption := ExternalDocumentNoCaptionLbl
        else
            DocNoCaption := DocumentNoCaptionLbl;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        VendorLedgEntryEndingDate: Record "Vendor Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";

        // FDD030: Required to retrieve vendor bank details.
        VendorBankAccount: Record "Vendor Bank Account";
        TradingPartnerFrom: Code[20];
        TradingPartnerTo: Code[20];

        PeriodLength: DateFormula;

        GrandTotalVLEAmtLCY: Decimal;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        UseExternalDocNo: Boolean;

        // FDD030: Added Number of Months option.
        HeadingType: Option "Date Interval","Number of Days","Number of Months";

        NewPagePerVendor: Boolean;

        // FDD030: Custom fields for payment terms, bank details, and RM equivalent amount.

        PaymentTermsCode: Code[20];
        VendorBankName: Text[100];
        VendorSwiftCode: Code[20];
        VendorBankAccountNo: Text[50];
        RMEquivAmount: Decimal;
        CurrencyFilterTxt: Text[50];
        ReportTitleTxt: Text[100];

        // FDD030: Additional RDLC support fields.
        FilterByText: Text[50];
        ExchangeRate: Decimal;
        ExchangeRateText: Text[30];
        RowBankInfo: Text[250];

        Text000: Label 'Not Due';
        AfterTok: Label 'After';
        BeforeTok: Label 'Before';
        CurrencyCode: Code[10];
        NumberOfCurrencies: Integer;
        PageGroupNo: Integer;
        TodayFormatted: Text;
        CompanyDisplayName: Text;
        DocNoCaption: Text;
        DocumentNo: Code[35];

        Text002: Label 'days';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        Text027: Label '-%1', Comment = 'Negating the period length: %1 is the period length';

        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        AgedAcctPayableCaptionLbl: Label 'Aged Accounts Payable';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
        AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
        AmountLCYCaptionLbl: Label 'Original Amount';
        DueDateCaptionLbl: Label 'Due Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentTypeCaptionLbl: Label 'Document Type';
        CurrencyCaptionLbl: Label 'Currency Code';
        TotalLCYCaptionLbl: Label 'Total (LCY)';
        CurrencySpecificationCaptionLbl: Label 'Currency Specification';

        // FDD030: Currency Specification total/balance amount by currency.
        // This is separated from aging bucket 6 so the 4MTH+ bucket remains a true aging bucket.
        CurrencySpecTotalAmount: Decimal;

        // FDD030: Arrays extended from 5 to 6 to support the additional 91-120 days / 4MTH bucket.
        TotalVendorLedgEntry: array[6] of Record "Vendor Ledger Entry";
        AgedVendorLedgEntry: array[6] of Record "Vendor Ledger Entry";
        GrandTotalVLERemaingAmtLCY: array[6] of Decimal;

        PeriodStartDate: array[6] of Date;
        PeriodEndDate: array[6] of Date;
        HeaderText: array[6] of Text[30];
        TopHeaderText: array[6] of Text[30];

        // FDD030: Request page flag to show/hide vendor bank details.
        PrintBankDetails: Boolean;

    protected var
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;
        VendorFilter: Text;
        PrintDetails: Boolean;

    /// <summary>
    /// Calculates PeriodStartDate and PeriodEndDate arrays used by GetPeriodIndex().
    /// This controls which aging bucket each vendor ledger entry falls into.
    /// </summary>
    local procedure CalcDates()
    var
        PeriodLength2: DateFormula;
        i: Integer;
    begin
        // FDD030: For Number of Days / Number of Months, use fixed aging buckets:

        if HeadingType in [HeadingType::"Number of Days", HeadingType::"Number of Months"] then begin
            PeriodStartDate[1] := EndingDate + 1;
            PeriodEndDate[1] := DMY2Date(31, 12, 9999);

            PeriodStartDate[2] := EndingDate - 30;
            PeriodEndDate[2] := EndingDate;

            PeriodStartDate[3] := EndingDate - 58;
            PeriodEndDate[3] := EndingDate - 31;

            PeriodStartDate[4] := EndingDate - 89;
            PeriodEndDate[4] := EndingDate - 59;

            PeriodStartDate[5] := EndingDate - 119;
            PeriodEndDate[5] := EndingDate - 90;

            PeriodStartDate[6] := 0D;
            PeriodEndDate[6] := EndingDate - 120;

            exit;
        end;

        // Standard BC date interval logic kept for Date Interval heading type.
        if not Evaluate(PeriodLength2, StrSubstNo(Text027, PeriodLength)) then
            Error(EnterDateFormulaErr);

        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2Date(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CalcDate(PeriodLength2, EndingDate + 1);
        end;

        for i := 2 to ArrayLen(PeriodEndDate) do begin
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
        end;

        i := ArrayLen(PeriodEndDate);
        PeriodStartDate[i] := 0D;

        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    /// <summary>
    /// Builds the RDLC aging captions: top row Current/1MTH/2MTH/... and
    /// second row Not Due/date range/day range depending on Heading Type.
    /// </summary>
    local procedure CreateHeadings()
    begin
        // FDD030: Top header row for six aging buckets.
        TopHeaderText[1] := 'Current';
        TopHeaderText[2] := '1MTH';
        TopHeaderText[3] := '2MTH';
        TopHeaderText[4] := '3MTH';
        TopHeaderText[5] := '4MTH';
        TopHeaderText[6] := '4MTH+';

        case HeadingType of
            HeadingType::"Date Interval":
                begin
                    HeaderText[1] := 'Not Due';
                    HeaderText[2] := Format(PeriodStartDate[2]) + '..' + Format(PeriodEndDate[2]);
                    HeaderText[3] := Format(PeriodStartDate[3]) + '..' + Format(PeriodEndDate[3]);
                    HeaderText[4] := Format(PeriodStartDate[4]) + '..' + Format(PeriodEndDate[4]);
                    HeaderText[5] := Format(PeriodStartDate[5]) + '..' + Format(PeriodEndDate[5]);

                    // Final bucket covers all dates before the previous bucket start date.
                    HeaderText[6] := 'Before ' + Format(PeriodStartDate[5]);
                end;

            HeadingType::"Number of Days",
            HeadingType::"Number of Months":
                begin
                    // FDD030: Fixed bucket captions required by FDD.
                    HeaderText[1] := 'Not Due';
                    HeaderText[2] := '1 - 31 days';
                    HeaderText[3] := '32 - 61 days';
                    HeaderText[4] := '62 - 92 days';
                    HeaderText[5] := '93 - 123 days';
                    HeaderText[6] := 'After 123 days';
                end;
        end;
    end;

    /// <summary>
    /// Inserts eligible Vendor Ledger Entries into TempVendorLedgEntry and prepares
    /// the TempCurrency list used by CurrencyLoop. Prevents duplicate entries by Entry No.
    /// </summary>
    local procedure InsertTemp(var VendorLedgEntry: Record "Vendor Ledger Entry")
    var
        Currency: Record Currency;
    begin
        if TempVendorLedgEntry.Get(VendorLedgEntry."Entry No.") then
            exit;

        TempVendorLedgEntry := VendorLedgEntry;
        TempVendorLedgEntry.Insert();

        if PrintAmountInLCY then begin
            Clear(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            if TempCurrency.Insert() then;
            exit;
        end;

        if TempCurrency.Get(TempVendorLedgEntry."Currency Code") then
            exit;

        if TempVendorLedgEntry."Currency Code" <> '' then
            Currency.Get(TempVendorLedgEntry."Currency Code")
        else begin
            Clear(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end;

        TempCurrency := Currency;
        TempCurrency.Insert();
    end;

    /// <summary>
    /// Returns the aging bucket index 1..6 for the supplied date.
    /// Index 1 = Current/Not Due, Index 6 = 4MTH+/oldest bucket.
    /// </summary>
    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    /// <summary>
    /// Builds temporary currency totals for the Currency Specification section.
    /// Bucket amounts are stored by PeriodStartDate; the overall currency total is
    /// stored with Date = 31/12/9999 and later exposed as RV_CurrencySpecTotalAmount.
    /// </summary>
    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert() then;

        for i := 1 to ArrayLen(TotalVendorLedgEntry) do begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := PeriodStartDate[i];

            if TempCurrencyAmount.Find() then begin
                TempCurrencyAmount.Amount :=
                    TempCurrencyAmount.Amount + TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Modify();
            end else begin
                TempCurrencyAmount."Currency Code" := CurrencyCode;
                TempCurrencyAmount.Date := PeriodStartDate[i];
                TempCurrencyAmount.Amount := TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Insert();
            end;
        end;

        TempCurrencyAmount."Currency Code" := CurrencyCode;
        TempCurrencyAmount.Date := DMY2Date(31, 12, 9999);

        if TempCurrencyAmount.Find() then begin
            TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.Modify();
        end else begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := DMY2Date(31, 12, 9999);
            TempCurrencyAmount.Amount := TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.Insert();
        end;
    end;

    /// <summary>
    /// Allows another AL object to run this report with predefined request values.
    /// </summary>
    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewNewPagePerVendor: Boolean; NewPrintBankDetails: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;

        // FDD030: Initialize Print Bank Details when report is called.
        PrintBankDetails := NewPrintBankDetails;
    end;

    /// <summary>
    /// Copies Vendor global dimension filters to Vendor Ledger Entry records so the
    /// aging result respects dimension filters entered on the request page.
    /// </summary>
    local procedure CopyDimFiltersFromVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        if Vendor.GetFilter("Global Dimension 1 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 1 Code", Vendor.GetFilter("Global Dimension 1 Filter"));

        if Vendor.GetFilter("Global Dimension 2 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 2 Code", Vendor.GetFilter("Global Dimension 2 Filter"));
    end;

    // FDD030: Vendor Filter displayed as Trading Partner From / To.
    /// <summary>
    /// Splits Vendor No. filter into Trading Partner From and To fields for RDLC.
    /// Example: VN0001..VN0020 becomes From = VN0001, To = VN0020.
    /// </summary>
    local procedure SetTradingPartnerFilterText()
    var
        VendorNoFilter: Text;
        SeparatorPos: Integer;
    begin
        Clear(TradingPartnerFrom);
        Clear(TradingPartnerTo);

        VendorNoFilter := Vendor.GetFilter("No.");

        if VendorNoFilter = '' then
            exit;

        SeparatorPos := StrPos(VendorNoFilter, '..');

        if SeparatorPos > 0 then begin
            TradingPartnerFrom := CopyStr(CopyStr(VendorNoFilter, 1, SeparatorPos - 1), 1, MaxStrLen(TradingPartnerFrom));
            TradingPartnerTo := CopyStr(CopyStr(VendorNoFilter, SeparatorPos + 2), 1, MaxStrLen(TradingPartnerTo));
        end else begin
            TradingPartnerFrom := CopyStr(VendorNoFilter, 1, MaxStrLen(TradingPartnerFrom));
            TradingPartnerTo := CopyStr(VendorNoFilter, 1, MaxStrLen(TradingPartnerTo));
        end;
    end;

    /// Applies Vendor.Currency Filter to Vendor Ledger Entry.Currency Code.
    /// LCY entries are stored as blank Currency Code in Vendor Ledger Entry, so
    /// filtering by GLSetup.LCY Code must be converted to Currency Code = ''.

    local procedure ApplyCurrencyFilterToVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        CurrencyFilter: Text;
    begin
        CurrencyFilter := Vendor.GetFilter("Currency Filter");

        if CurrencyFilter = '' then
            exit;

        // LCY entries are stored with blank Currency Code in Vendor Ledger Entry.
        if CurrencyFilter = GLSetup."LCY Code" then
            VendorLedgerEntry.SetRange("Currency Code", '')
        else
            VendorLedgerEntry.SetFilter("Currency Code", CurrencyFilter);
    end;
}

