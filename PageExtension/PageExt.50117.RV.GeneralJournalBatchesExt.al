/// <summary>
/// pageextension RV General Journal Batches Ext (ID 50117) extends "General Journal Batches" page
/// FDD017 2026/05/18: New. (Liuyang)
/// </summary>
pageextension 50117 "RV General Journal Batches Ext" extends "General Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("RV_Export Type"; Rec."RV_Export Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
