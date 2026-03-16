/// <summary>
/// TableExtension Item Ledger Entry Ext (ID 50104) extends "Item Ledger Entry" table
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
tableextension 50104 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; "RV_Container No."; Code[20])
        {
            Caption = 'RV_Container No.';
            DataClassification = ToBeClassified;
        }
    }
}
