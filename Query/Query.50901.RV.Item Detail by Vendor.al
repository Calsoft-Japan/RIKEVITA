/// <summary>
/// Query RV Item Detail by Vendor (ID 50901)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
query 50901 "RV Item Detail by Vendor"
{
    Caption = 'Item Detail by Vendor';
    QueryType = Normal;


    elements
    {
        dataitem(ItemTraceDetail; "RV Item Trace Detail")
        {
            column(Item_No_; "Item No.")
            {
            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(Quantity__BUOM_; "Quantity (BUOM)")
            {
                Method = Sum;

            }
            column(Quantity__KG_; "Quantity (KG)")
            {
                Method = Sum;

            }
            column(Cost_Amount__RM_; "Cost Amount (RM)")
            {
                Method = Sum;

            }
            filter(History_Entry_No_; "History Entry No.")
            {
            }

        }
    }

    var
        HistoryEntryNo: Integer;

    procedure SetHistEntryNo(pHistEntryNo: Integer)
    begin
        HistoryEntryNo := pHistEntryNo;
    end;

    trigger OnBeforeOpen()
    begin
        SetRange(History_Entry_No_, HistoryEntryNo);

    end;
}
