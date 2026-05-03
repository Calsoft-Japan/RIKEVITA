/// <summary>
/// Table Order Listing. (FDD026).
/// FDD026 2026/05/02: New. (Stephen)
/// </summary>
enum 50607 "RV SO Reserve Status"
{
    Extensible = true;

    value(0; "Ordered")
    {
        Caption = 'Ordered';
    }
    value(1; Reserved)
    {
        Caption = 'Reserved';
    }
    value(2; "Partial Reserved")
    {
        Caption = 'Partial Reserved';
    }

}
