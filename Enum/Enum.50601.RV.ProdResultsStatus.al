/// <summary>
/// Enum RV Prod. Results Status (ID 50601).
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
enum 50601 "RV Prod. Results Status"
{
    Extensible = true;
    Caption = 'RV Prod. Results Status';
    value(0; Preparing) { Caption = 'Preparing'; }
    value(1; "Pending Approve") { Caption = 'Pending Approve'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
    value(4; "Ready Post") { Caption = 'Ready Post'; }
    value(5; "Post Error") { Caption = 'Post Error'; }
}