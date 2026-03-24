/// <summary>
/// Query RV Prod. Result Journal Line G (ID 50600)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
query 50600 "RV Prod. Result Journal Line G"
{
    Caption = 'RV Prod. Result Journal Line G';
    QueryType = Normal;

    elements
    {
        dataitem(RVProdResultJournalLine; "RV Prod. Result Journal Line")
        {
            column(Status; Status)
            {
            }
            column(ProdOrderNo; "Prod. Order No.")
            {
            }
            column(ProdOrderLineNo; "Prod. Order Line No.")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
