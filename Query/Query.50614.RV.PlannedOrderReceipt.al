query 50614 "RV Planned Order Receipt"
{
    Caption = 'RV Planned Order Receipt';
    QueryType = Normal;

    elements
    {
        dataitem(ProdLine; "Prod. Order Line")
        {
            DataItemTableFilter = Status = const(Planned);
            column(ItemNo; "Item No.")
            {
            }
            filter(DueDate; "Due Date")
            {
            }
            column(Quantity; "Remaining Qty. (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
