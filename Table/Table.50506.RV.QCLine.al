/// <summary>
/// Table RV QC Line (ID 50506)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50506 "RV QC Line"
{
    Caption = 'QC Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC No."; Code[20])
        {
            Caption = 'QC No.';
            TableRelation = "RV QC Header"."QC No." where("QC Type" = field("QC Type"));
            NotBlank = true;
        }
        field(2; "QC Type"; Enum "RV QC Type")
        {
            Caption = 'QC Type';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
            trigger OnValidate()
            var
                QCParameter: Record "RV QC Parameter";
            begin
                if QCParameter.Get("QC Parameter Name") then begin
                    Type := QCParameter.Type;
                    "Value Table Type" := QCParameter."Value Table Type";
                end;
            end;
        }
        field(5; "QC Result"; Code[10])
        {
            Caption = 'QC Result';
            trigger OnValidate()
            begin
                if "Value Table Type" = "Value Table Type"::Range then begin
                    if "QC Result" = '' then
                        "Check Status" := "Check Status"::Init
                    else
                        CheckQCResultRange();
                end;
            end;
        }
        field(6; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
        field(10; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(11; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
    }
    keys
    {
        key(PK; "QC No.", "QC Type", "Line No.")
        {
            Clustered = true;
        }
    }


    procedure SetQCLineEnable(var TypeEnable: Boolean; var ValueTableTypeEnable: Boolean)
    begin

        if "QC Parameter Name" = '' then begin
            TypeEnable := true;
            ValueTableTypeEnable := true;
        end else begin
            TypeEnable := false;
            ValueTableTypeEnable := false;
        end;
    end;

    procedure CheckQCResultRange()
    var
        TempInteger: Record "Integer" temporary;// Temp
        QCSpecificationLine: Record "RV QC Specification Line";
    begin

        TempInteger.Reset();

        TempInteger.Init();
        if Evaluate(TempInteger.Number, "QC Result") then
            TempInteger.Insert()
        else
            Error('Please enter a Numeric');

        QCSpecificationLine.Reset();
        QCSpecificationLine.SetRange("QC Parameter Name", "QC Parameter Name");
        if QCSpecificationLine.FindFirst() then begin
            TempInteger.SetFilter(Number, QCSpecificationLine."Target Value ib Base UM");
        end else begin
            Error('QC Result cannot be checked because QC Specification Line do not exist.');
        end;

        if not TempInteger.IsEmpty() then
            "Check Status" := "Check Status"::PASSED
        else
            "Check Status" := "Check Status"::FAILED;
    end;
}