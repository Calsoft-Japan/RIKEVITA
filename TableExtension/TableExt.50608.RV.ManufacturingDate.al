tableextension 50608 "RV Lot No. Information" extends "Lot No. Information"
{
    fields
    {
        field(50400; "RV_Sub Lot No."; code[30])
        {
            Caption = 'Sub Lot No.';
            Description = 'FDD006';
        }
        field(50600; "RV_Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
            Description = 'FDD006';
        }

    }
}
