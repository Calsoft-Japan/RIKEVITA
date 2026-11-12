/// <summary>
/// TableExtension RV_Purch Rcpt Header (ID 50213) extends Purch. Rcpt. Header table
/// additional requirement 2026/11/12: Add RV_Department Dimension Code. (Bobby.ji)
/// </summary>
tableextension 50213 "RV Purch Rcpt Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
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
