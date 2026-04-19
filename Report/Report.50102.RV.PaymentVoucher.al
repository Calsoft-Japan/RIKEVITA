report 50102 "RV Payment Voucher"
{
    ApplicationArea = All;
    Caption = 'RV Payment Voucher';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            column(AmountLCY; "Amount (LCY)")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
