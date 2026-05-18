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
            DataItemTableFilter = "Source Type" = const(Vendor);
            column(Item_No_; "Item No.")
            {
            }
            column(Source_No_; "Source No.")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(RV_Quantity__KG_; "RV_Quantity (KG)")
            {
                Method = Sum;
            }
            filter(Posting_Date; "Posting Date")
            {
            }

            dataitem(Value_Entry; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = ItemLedgerEntry."Entry No.";
                SqlJoinType = InnerJoin;

                column(Cost_Amount__Actual_; "Cost Amount (Actual)")
                {
                    Method = Sum;
                }

            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;

    procedure SetDate(pStartDate: Date; pEndDate: Date)
    begin
        StartDate := pStartDate;
        EndDate := pEndDate;
    end;

    trigger OnBeforeOpen()
    begin
        SetRange(Posting_Date, StartDate, EndDate);

    end;
}
