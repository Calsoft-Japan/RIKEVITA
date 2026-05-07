/// <summary>
/// Table RV QC Value Table (ID 50516)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50516 "RV QC Value Table"
{
    Caption = 'Value Table';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC Value Table List";
    fields
    {
        field(10; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
            NotBlank = true;
        }
        field(20; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(30; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
        field(40; "Minimum Value"; Text[50])
        {
            Caption = 'Minimum Value';
        }
        field(50; "Maximum Value"; Text[50])
        {
            Caption = 'Maximum Value';
        }
    }
    keys
    {
        key(PK; "Value Table Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Value Table Name", "Value Table Type", "Type")
        {
        }
    }
    procedure SetQCEnable(var LineEnable: Boolean; var TypeEnable: Boolean; var ValueTableTypeEnable: Boolean)
    var
        QCLine: Record "RV QC Line";
        QCParameter: Record "RV QC Parameter";
    begin

        if "Value Table Type" = "Value Table Type"::Range then
            LineEnable := false
        else
            LineEnable := true;

        QCParameter.Reset();
        QCParameter.SetRange("Value Table Name", "Value Table Name");
        if QCParameter.FindFirst() then begin
            QCLine.Reset();
            QCLine.SetRange("QC Parameter Name", QCParameter."Parameter Name");
            if QCLine.FindFirst() then begin
                TypeEnable := false;
                ValueTableTypeEnable := false;
            end else begin
                TypeEnable := true;
                ValueTableTypeEnable := true;
            end;
        end;
    end;
}