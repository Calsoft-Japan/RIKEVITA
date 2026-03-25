/// <summary>
/// TableExtension Item Journal Line Ext (ID 50105) extends "Item Journal Line" table
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
tableextension 50105 "RV Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(50100; "RV Container No."; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = ToBeClassified;
        }
    }
}
