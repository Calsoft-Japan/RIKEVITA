/// <summary>
/// Enum RIKE QC Status (ID 50505).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50505 "RIKE QC Status"
{
    Extensible = true;
    //Analyzing,Checked,Approved,Rejected
    value(0; "Analyzing") { Caption = 'Analyzing'; }
    value(1; "Checked") { Caption = 'Checked'; }
    value(2; "Approved") { Caption = 'Approved'; }
    value(3; "Rejected") { Caption = 'Rejected'; }
}