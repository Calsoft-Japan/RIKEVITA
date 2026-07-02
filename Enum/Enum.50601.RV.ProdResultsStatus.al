/// <summary>
/// Enum RV Prod. Results Status (ID 50601).
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
enum 50601 "RV Prod. Results Status"
{
    Extensible = true;
    Caption = 'RV Prod. Results Status';
    value(0; Preparing) { Caption = 'Preparing'; }
    value(1; "Ready Post") { Caption = 'Ready Post'; }
    value(2; "Post Error") { Caption = 'Post Error'; }
}