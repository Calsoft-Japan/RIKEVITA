query 50609 "RV Qty. on Purch. Order"
{
    Caption = 'RV Qty. on Purch. Order';
    QueryType = Normal;

    elements
    {
        dataitem(PurchLine; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const(Order),
                                    Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(ExpectedReceiptDate; "Expected Receipt Date")
            {
            }
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
