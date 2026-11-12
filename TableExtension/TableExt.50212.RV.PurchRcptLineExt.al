/// <summary>
/// TableExtension RV_Purch. Rcpt. Line (ID 50212) extends Purch. Rcpt. Line table
/// additional requirement 2026/10/30: Add the following field. (Bobby.ji)
/// </summary>
tableextension 50212 "RV Purch. Rcpt. Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {

        field(50200; "RV_Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Description = 'additional requirement';
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor."Name" WHERE("No." = FIELD("Buy-from Vendor No.")));
        }
    }
}
