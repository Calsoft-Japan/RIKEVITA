/// <summary>
/// Table RV MPS Rescheduling Line (ID 50604)
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
table 50604 "RV MPS Rescheduling Line"
{
    DataClassification = ToBeClassified;
    Caption = 'MPS Rescheduling Line ';

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
        }
        field(2; "Batch Line No."; Integer)
        {
            Caption = 'Batch Line No.';
        }
        field(3; GUID; Guid)
        {
            Caption = 'GUID';
        }
        field(4; "Production No."; Code[20])
        {
            Caption = 'Production No.';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(6; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(8; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
        }
        field(9; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(10; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(11; "New Starting Date"; DateTime)
        {
            Caption = 'New Starting Date';
        }
        field(12; "New Ending Date"; DateTime)
        {
            Caption = 'New Ending Date';
        }
        field(13; "Work Center No. 1"; Code[20])
        {
            Caption = 'Work Center No. 1';
        }
        field(14; "Work Center No. 2"; Code[20])
        {
            Caption = 'Work Center No. 2';
        }
        field(15; "Work Center No. 3"; Code[20])
        {
            Caption = 'Work Center No. 3';
        }
        field(16; "New Work Center No. 1"; Code[20])
        {
            Caption = 'New Work Center No. 1';
        }
        field(17; "New Work Center No. 2"; Code[20])
        {
            Caption = 'New Work Center No. 2';
        }
        field(18; "New Work Center No. 3"; Code[20])
        {
            Caption = 'New Work Center No. 3';
        }
        field(19; "Planning Status"; Enum "RV Planning Status")
        {
            Caption = 'Planning Status';
        }
        field(20; "Collect MPS Data"; Boolean)
        {
            Caption = 'Collect MPS Data';
        }
        field(21; "Export MPS Data"; Boolean)
        {
            Caption = 'Export MPS Data';
        }
        field(22; "Import MPS Data"; Boolean)
        {
            Caption = 'Import MPS Data';
        }
        field(23; "Apply Rescheduling Data"; Boolean)
        {
            Caption = 'Apply Rescheduling Data';
        }
        field(24; "Planning Date"; Date)
        {
            Caption = 'Planning Date';
        }
        field(25; "Planning Controller"; Code[20])
        {
            Caption = 'Planning Controller';
        }
        field(26; "Prod. Line No."; Integer)
        {
            Caption = 'Prod. Line No.';
        }
        field(27; Status; enum "RV MPS Rescheduling Status")
        {
            Caption = 'Error Info';
        }
        field(28; "Error Message"; Text[100])
        {
            Caption = 'Error Message';
        }
    }

    keys
    {
        key(PK; "Batch Name", "Batch Line No.")
        {
            Clustered = true;
        }
    }
}
