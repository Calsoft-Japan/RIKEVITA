query 50607 "RV Qty. on Purch. Return"
{
    Caption = 'RV Qty. on Purch. Return';
    QueryType = Normal;

    elements
    {
        dataitem(PurchLine; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const("Return Order"),
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
