/// <summary>
/// TableExtension RIKE Purchase Invoice Ext (ID 50101) extends "Purch. Inv. Header" table
/// FDD003 2026/03/08: New. (Liuyang)
/// additional requirement 2026/11/12: Add RV_Department Dimension Code. (Bobby.ji)
/// </summary>
tableextension 50101 "RV Purchase Invoice Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "RV_ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = ToBeClassified;
        }
        field(50101; "RV_ETD"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(50102; "RV_Contract Month"; Enum "RV Month")
        {
            Caption = 'Contract Month';
            DataClassification = ToBeClassified;
        }
        field(50103; "RV_Contract Year"; Integer)
        {
            Caption = 'Contract Year';
            DataClassification = ToBeClassified;
        }
        field(50104; "RV_Contract No."; Text[100])
        {
            Caption = 'Contract No.';
            DataClassification = ToBeClassified;
        }
        field(50200; "RV_Department Dimension Code"; Code[20])// On-demand request
        {
            Caption = 'Department Dimension Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("RV RIKEVITA Setup"."Department Dimension Code");
        }
        field(50201; "RV_Department Code"; Code[20])// On-demand request
        {
            Caption = 'Department Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Code" = field("RV_Department Dimension Code"), "Dimension Set ID" = field("Dimension Set ID")));
        }
    }
}