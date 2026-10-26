/// <summary>
/// TableExtension RIKE Purch. Rcpt. Line (ID 50500) extends Purch. Rcpt. Line table
/// FDD039 2026/10/21: New. (mike)
/// </summary>
tableextension 50500 "RV Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50500; "RV_IQC Quantity"; decimal)
        {
            Caption = 'IQC Quantity';
            Description = 'FDD014';
            DataClassification = ToBeClassified;
        }
        field(50501; "RV_IQC Status"; boolean)
        {
            Caption = 'IQC Status';
            Description = 'FDD014';
            DataClassification = ToBeClassified;
        }
    }
}
