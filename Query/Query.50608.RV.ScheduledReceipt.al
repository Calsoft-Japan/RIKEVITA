query 50608 "RV Scheduled Receipt"
{
    Caption = 'RV Scheduled Receipt';
    QueryType = Normal;

    elements
    {
        dataitem(ProdLine; "Prod. Order Line")
        {
            DataItemTableFilter = Status = filter("Firm Planned" | Released);
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
