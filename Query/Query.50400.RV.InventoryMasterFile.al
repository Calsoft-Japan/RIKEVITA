/// <summary>
/// Query RV Inventory Master File (ID 50400)
/// FDD010 2026/02/27: New. (Vani)
/// </summary>

query 50400 "Inventory Master File"
{
    Caption = 'Inventory Master File';
    QueryType = Normal;

    elements
    {
        dataitem(StandardCostDetail; "Standard Cost Element Details")
        {
            column(Period_Code; "Period Code") { }
            column(Item_No; "Item No.") { }
            column(Item_Description; "Item Description") { }

            filter(Period_Filter; "Period Code") { }
            filter(Item_Filter; "Item No.") { }
        }
    }
}