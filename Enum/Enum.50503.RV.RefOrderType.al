/// <summary>
/// Enum RV Ref. Order Type (ID 50503).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50503 "RV Ref. Order Type"
{
    Extensible = true;
    //Purchase Order,Posted Purchase Receipt,Production Order
    value(0; "Purchase Order") { Caption = 'Purchase Order'; }
    value(1; "Posted Purchase Receipt") { Caption = 'Posted Purchase Receipt'; }
    value(2; "Production Order") { Caption = 'Production Order'; }
}