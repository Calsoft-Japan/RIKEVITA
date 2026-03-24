/// <summary>
/// Table RV MPS Rescheduling Batch (ID 50603)
/// FDD011 2026/02/23: New. (stephen)
/// </summary>
table 50603 "RV MPS Rescheduling Batch"
{
    DataClassification = ToBeClassified;
    Caption = 'RV MPS Rescheduling Batch';
    LookupPageId = "RV MPS Rescheduling Batch";

    fields
    {
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
