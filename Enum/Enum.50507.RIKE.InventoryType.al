/// <summary>
/// Enum RIKE Inventory Type (ID 50507).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50507 "RIKE Inventory Type"
{
    Extensible = true;
    //BLCK,DISP,DMGE,SUCS
    value(0; "BLCK") { Caption = 'BLCK'; }
    value(1; "DISP") { Caption = 'DISP'; }
    value(2; "DMGE") { Caption = 'DMGE'; }
    value(3; "SUCS") { Caption = 'SUCS'; }
}