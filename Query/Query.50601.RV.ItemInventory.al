query 50601 "RV Item Inventory"
{
    Caption = 'RV Item Inventory';
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(ItemNo; "Item No.")
            {
            }
            filter(PostingDate; "Posting Date")
            {
            }
            column(Quantity; Quantity)
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
