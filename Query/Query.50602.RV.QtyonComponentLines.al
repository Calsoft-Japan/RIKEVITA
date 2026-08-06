query 50602 "RV Qty. on Component Lines"
{
    Caption = 'RV Qty. on Component Lines';
    QueryType = Normal;

    elements
    {
        dataitem(ProdOrderComponent; "Prod. Order Component")
        {
            DataItemTableFilter = status = filter(Planned .. Released);
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
