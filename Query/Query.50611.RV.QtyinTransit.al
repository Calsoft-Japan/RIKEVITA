query 50611 "RV Qty. in Transit"
{
    Caption = 'RV Qty. in Transit';
    QueryType = Normal;

    elements
    {
        dataitem(TransferLine; "Transfer Line")
        {
            DataItemTableFilter = "Derived From Line No." = const(0);
            column(ItemNo; "Item No.")
            {
            }
            filter(ReceiptDate; "Receipt Date")
            {
            }
            column(Quantity; "Qty. in Transit (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
