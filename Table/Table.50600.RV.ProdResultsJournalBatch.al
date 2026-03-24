/// <summary>
/// Table RV Prod. Results Journal Batch (ID 50600)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
table 50600 "RV Prod. Results Journal Bat"
{
    DataClassification = ToBeClassified;
    Caption = 'RV Prod. Results Journal Batch';
    LookupPageID = "RV Prod. Results Journal Bat";

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

    trigger OnDelete()
    var
        prodResultsJournalLine: Record "RV Prod. Result Journal Line";
    begin
        prodResultsJournalLine.SetRange("Batch Name", Name);
        prodResultsJournalLine.DeleteAll();
    end;
}