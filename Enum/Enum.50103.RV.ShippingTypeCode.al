namespace RIKEVITA.RIKEVITA;

enum 50103 "RV Shipping Type Code"
{
    Extensible = true;

    value(0; "Full container load - FCL")
    {
        Caption = 'Full container load - FCL';
    }
    value(1; "Loose container load - LCL")
    {
        Caption = 'Loose container load - LCL';
    }
    value(2; "Cross border")
    {
        Caption = 'Cross border';
    }
    value(3; "Air Shipment")
    {
        Caption = 'Air Shipment';
    }
    value(4; "Local-self-collect")
    {
        Caption = 'Local-self-collect';
    }
    value(5; "Local-Delivery")
    {
        Caption = 'Local-Delivery';
    }
}
