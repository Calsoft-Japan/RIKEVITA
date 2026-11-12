/// <summary>
/// PageExtension RV Posted Purchase Receipts Ext (ID 50230) extends "Posted Purchase Receipts"
/// On-demand request: add RV_Department Dimension Code by Bobby 11/12/2026
/// </summary>
pageextension 50230 "RV PostedPurchaseReceipts Ext" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("RV_Department Dimension Code"; Rec."RV_Department Dimension Code")
            {
                Caption = 'Department Dimension Code';
                ApplicationArea = All;
            }
        }


    }

}
