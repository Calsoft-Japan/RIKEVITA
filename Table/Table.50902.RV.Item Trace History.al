/// <summary>
/// Table RV Item Trace History(ID 50902)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
table 50902 "RV Item Trace History"
{
    Caption = 'RV Item Trace History';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(3; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(4; "Collected On"; DateTime)
        {
            Caption = 'Collected On';
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
