/// <summary>
/// TableExtension RIKE Purchase Invoice Ext (ID 50101) extends "Purch. Inv. Header" table
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
tableextension 50101 "RIKE Purchase Invoice Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; RV_ETA; Date)
        {
            Caption = 'ETA';
            DataClassification = ToBeClassified;
        }
        field(50101; RV_ETD; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(50102; "RV_Contract Month"; Enum "RV_Month")
        {
            Caption = 'Contract Month';
            DataClassification = ToBeClassified;
        }
        field(50103; "RV_Contract Year"; Integer)
        {
            Caption = 'Contract Year';
            DataClassification = ToBeClassified;
        }
    }
}