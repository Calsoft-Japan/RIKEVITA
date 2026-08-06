query 50613 "RV Planning Receipt"
{
    Caption = 'RV Planning Receipt';
    QueryType = Normal;

    elements
    {
        dataitem(RequisitionLine; "Requisition Line")
        {
            DataItemTableFilter = Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(DueDate; "Due Date")
            {
            }
            column(Quantity; "Quantity (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
