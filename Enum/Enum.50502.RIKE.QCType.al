/// <summary>
/// Enum RIKE QC Type (ID 50502).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50502 "RIKE QC Type"
{
    Extensible = true;
    //IQC,PQC,FQC
    value(0; "IQC") { Caption = 'IQC'; }
    value(1; "PQC") { Caption = 'PQC'; }
    value(2; "FQC") { Caption = 'FQC'; }
}