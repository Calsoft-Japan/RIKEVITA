/// <summary>
/// Query RV Item Balance by Vendor (ID 50900)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
query 50900 "RV Item Balance by Vendor"
{
    Caption = 'Item Balance by Vendor';
    QueryType = Normal;


    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(RV_Vendor_No__No_; "RV_Vendor No.")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(RV_Quantity__KG_; "RV_Quantity (Supp. UOM)")
            {
                Method = Sum;
            }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        ItemNoFilter: Text[250];

    procedure SetDate(pStartDate: Date; pEndDate: Date)
    begin
        StartDate := pStartDate;
        EndDate := pEndDate;
    end;

    procedure SetItemNoFilter(pItemNoFilter: Text[250])
    begin
        ItemNoFilter := pItemNoFilter;
    end;

    trigger OnBeforeOpen()
    begin
        SetFilter(RV_Vendor_No__No_, '<>%1', '');
        SetRange(Posting_Date, StartDate, EndDate);
        SetFilter(Item_No_, ItemNoFilter);
    end;
}
