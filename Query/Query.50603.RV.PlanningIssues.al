query 50603 "RV Planning Issues"
{
    Caption = 'RV Planning Issues';
    QueryType = Normal;

    elements
    {
        dataitem(ProdOrderComponent; "Planning Component")
        {
            DataItemTableFilter = "Planning Line Origin" = const(" ");
            column(ItemNo; "Item No.")
            {
            }
            filter(DueDate; "Due Date")
            {
            }
            column(Quantity; "Expected Quantity (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
