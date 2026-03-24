/// <summary>
/// Enum RV Ref. Order Type QA (ID 50508).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50508 "RV Ref. Order Type QA"
{
    Extensible = true;
    //"Posted Whse. Shipment","Warehouse Shipment"
    value(0; "Posted Whse. Shipment") { Caption = 'Posted Whse. Shipment'; }
    value(1; "Warehouse Shipment") { Caption = 'Warehouse Shipment'; }
}