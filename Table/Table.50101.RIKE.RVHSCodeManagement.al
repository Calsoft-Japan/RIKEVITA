/// <summary>
/// Table RV_HS Code Management (ID 50101)
/// FDD039 2026/03/09: New. (Liuyang)
/// </summary>
table 50101 "RV_HS Code Management"
{
    Caption = 'RV_HS Code Management';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            NotBlank = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            TableRelation = Item.Description;
        }
        field(4; Description2; Text[100])
        {
            Caption = 'Description2';
            TableRelation = Item."Description 2";
        }
        field(5; "Prev. HS Code"; Text[100])
        {
            Caption = 'Prev. HS Code';
        }
        field(6; "Latest HS Code"; Text[100])
        {
            Caption = 'Latest HS Code';
        }
        field(7; "State Custom Ref"; Text[100])
        {
            Caption = 'State Custom Ref';
        }
        field(8; "HQ Custom Ref"; Text[100])
        {
            Caption = 'HQ Custom Ref';
        }
        field(9; "HQ Code Expiry Date"; Date)
        {
            Caption = 'HQ Code Expiry Date';
        }
        field(10; SeqNo; Integer)
        {
            Caption = 'SeqNo';
            InitValue = 0;
        }
        field(11; "FTA Schema"; Text[100])
        {
            Caption = 'FTA Schema';
        }
        field(12; "Application ID"; Text[100])
        {
            Caption = 'Application ID';
        }
        field(13; "Approval Date"; DateTime)
        {
            Caption = 'Approval Date';
        }
        field(14; "Expired App ID"; Text[100])
        {
            Caption = 'Expired App ID';
        }
        field(15; "Expired Date"; Date)
        {
            Caption = 'Expired Date';
        }
        field(16; "Origin Criteria"; Text[100])
        {
            Caption = 'Origin Criteria';
        }
        field(17; "Origin Criterial %"; Decimal)
        {
            Caption = 'Origin Criterial %';
            DecimalPlaces = 2;
        }
        field(18; Link; Text[2048])
        {
            Caption = 'Link';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    [InherentPermissions(PermissionObjectType::TableData, Database::"RV_HS Code Management", 'r')]
    procedure GetNextEntryNo(): Integer
    var
        SequenceNoMgt: Codeunit "Sequence No. Mgt.";
    begin
        exit(SequenceNoMgt.GetNextSeqNo(DATABASE::"RV_HS Code Management"));
    end;

    [InherentPermissions(PermissionObjectType::TableData, Database::"RV_HS Code Management", 'r')]
    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;
}
