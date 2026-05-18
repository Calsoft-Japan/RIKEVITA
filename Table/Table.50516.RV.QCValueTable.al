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
            trigger OnValidate()
            begin
                if "Value Table Type" <> xRec."Value Table Type" then begin
                    Clear("Type");
                    Clear("Minimum Value");
                    Clear("Maximum Value");
                end;
            end;
        }
        field(30; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
        field(40; "Minimum Value"; Text[50])
        {
            Caption = 'Minimum Value';
            trigger OnValidate()
            begin
                if "Type" = "Type"::Alphanumeric then
                    ValidateAlphanumeric("Minimum Value")
                else
                    ValidateNumeric("Minimum Value");
            end;
        }
        field(50; "Maximum Value"; Text[50])
        {
            Caption = 'Maximum Value';
            trigger OnValidate()
            begin
                if "Type" = "Type"::Alphanumeric then
                    ValidateAlphanumeric("Maximum Value")
                else
                    ValidateNumeric("Maximum Value");
            end;
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
    trigger OnDelete()
    var
        QCListValue: Record "RV QC List Value";
    begin
        QCListValue.Reset();
        QCListValue.LockTable();
        QCListValue.SetRange("Value Table Name", Rec."Value Table Name");
        QCListValue.DeleteAll(true);
    end;

    procedure SetQCEnable(var LineEnable: Boolean; var ValueEnable: Boolean; var TypeEnable: Boolean; var ValueTableTypeEnable: Boolean)
    var
        QCLine: Record "RV QC Line";
        QCParameter: Record "RV QC Parameter";
        QCListValue: Record "RV QC List Value";
    begin

        if "Value Table Type" = "Value Table Type"::Range then begin
            LineEnable := false;
            ValueEnable := true;
        end else begin
            LineEnable := true;
            ValueEnable := false;
        end;


        TypeEnable := true;
        ValueTableTypeEnable := true;

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

        if ValueTableTypeEnable then begin
            if "Value Table Name" = '' then begin
                ValueTableTypeEnable := true;
            end else begin
                QCListValue.Reset();
                QCListValue.SetRange("Value Table Name", "Value Table Name");
                if QCListValue.FindFirst() then
                    ValueTableTypeEnable := false
                else
                    ValueTableTypeEnable := true;
            end;
        end;
    end;

    procedure ValidateAlphanumeric(InputValue: Text)
    var
        RemainingText: Text;
    begin
        RemainingText := DelChr(InputValue, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
        if RemainingText <> '' then
            Error('Please enter a Alphanumeric.');
    end;


    procedure ValidateNumeric(InputText: Text)
    var
        ResultDecimal: Decimal;
    begin
        if Evaluate(ResultDecimal, InputText) then begin
            if ResultDecimal < 0 then
                Error('The input value cannot be negative.');
        end else begin
            Error('Please enter a Numeric.');
        end;
    end;
}