/// <summary>
/// Table RV TempTextDecimal (ID 50518)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50518 "RV TempTextDecimal"
{
    Caption = 'TempTextDecimal';
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Value Text"; Text[50])
        {
            Caption = 'Value Text';
        }
        field(20; "Value Decimal"; Decimal)
        {
            Caption = 'Value Decimal';
        }

    }
    keys
    {
        key(PK; "Value Text")
        {
            Clustered = true;
        }
    }
}