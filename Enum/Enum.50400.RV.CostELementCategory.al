/// <summary>
/// Enum RIKE Cost Element Category (ID 50400).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
enum 50400 "RIKE Cost Element Category"
{
    Extensible = true;

    value(0; Blank)
    {
        Caption = ' ';
    }
    value(1; RawMaterial)
    {
        Caption = 'Raw Material';
    }
    value(2; PackageMaterial)
    {
        Caption = 'Package Material';
    }
    value(3; Energy)
    {
        Caption = 'Energy';
    }
    value(4; Water)
    {
        Caption = 'Water';
    }
    value(5; Process)
    {
        Caption = 'Process';
    }
}