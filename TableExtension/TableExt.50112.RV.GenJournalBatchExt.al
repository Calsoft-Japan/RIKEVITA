/// <summary>
/// TableExtension RV Gen. Journal Batch Ext (ID 50112) extends "Gen. Journal Batch" table
/// FDD017 2026/05/18: New. (Liuyang)
/// </summary>
tableextension 50112 "RV Gen. Journal Batch Ext" extends "Gen. Journal Batch"
{
    fields
    {
        field(50100; "RV_Export Type"; Option)
        {
            Caption = 'Export Template File';
            DataClassification = ToBeClassified;
            OptionMembers = BookTrans,Domestic,Jompay,GIRO;
            OptionCaption = 'Book Transfer Own Account (MayBank),Domestic Payments (MayBank),Utility Payment - Jompay (MayBank),GIRO Payments (MUFG)';
        }
    }
}
