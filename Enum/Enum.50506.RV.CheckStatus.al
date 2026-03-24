/// <summary>
/// Enum RV Check Status (ID 50506).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50506 "RV Check Status"
{
    Extensible = true;
    //Init,PASSED,FAILED
    value(0; "Init") { Caption = 'Init'; }
    value(1; "PASSED") { Caption = 'PASSED'; }
    value(2; "FAILED") { Caption = 'FAILED'; }
}