/// <summary>
/// report RV Employee Ledger Entry Ext (ID 50110) table 5222 "Employee Ledger Entry"
/// FDD016 2026/04/23: New. (Liuyang)
/// </summary>
tableextension 50110 "RV Employee Ledger Entry Ext" extends "Employee Ledger Entry"
{

    keys
    {
        key(keysort; "Employee No.", "Posting Date", "Applies-to Doc. No.", "Currency Code")
        { }
    }
}
