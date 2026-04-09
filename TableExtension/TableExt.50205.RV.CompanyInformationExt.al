/// <summary>
/// TableExtension RV_Company Information (ID 50205) extends Company Information table
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
tableextension 50205 "RV Company Information" extends "Company Information"
{
    fields
    {
        field(50200; "RV_RESO Certificate No."; Code[50])
        {
            Caption = 'RESO Certificate No.';
            Description = 'FDD020';
        }


    }
}
