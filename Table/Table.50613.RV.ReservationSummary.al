/// <summary>
/// Table RV Reservation Summary (ID 50613).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50613 "RV Reservation Summary"
{
    Caption = 'RV Reservation Summary';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Summary Type"; Text[100])
        {
            Caption = 'Summary Type';
        }
        field(3; "Total Quantity"; Decimal)
        {
            Caption = 'Total Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(4; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(7; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(8; "Query No."; Integer)
        {
            Caption = 'Query No.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
