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
                QCListValue: Record "RV QC List Value";

            begin
                Clear(Type);
                Clear("Value Table Type");
                Clear("Value Table Name");
                Clear("QC Result");
                Clear("Check Status");

                if QCParameter.Get("QC Parameter Name") then begin
                    QCParameter.CalcFields(Type, "Value Table Type");
                    Type := QCParameter.Type;
                    "Value Table Type" := QCParameter."Value Table Type";
                    "Value Table Name" := QCParameter."Value Table Name";

                    if "Value Table Type" = "Value Table Type"::Single then begin
                        QCListValue.Reset();
                        QCListValue.SetRange("Value Table Name", QCParameter."Value Table Name");
                        if QCListValue.FindFirst() then begin
                            "QC Result" := QCListValue."List Value";
                            "Check Status" := QCListValue."Check Status";
                        end;
                    end;
                end else begin
                    Clear(Type);
                    Clear("Value Table Type");
                end;
            end;
        }
        field(5; "QC Result"; Text[50])
        {
            Caption = 'QC Result';
            TableRelation =
            if ("Value Table Type" = const("List")) "RV Specification Value Setting"."List Value" where("QC Specification Name" = field("QC Specification Name"), "QC Parameter Name" = field("QC Parameter Name"), "Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Single")) "RV Specification Value Setting"."List Value" where("QC Specification Name" = field("QC Specification Name"), "QC Parameter Name" = field("QC Parameter Name"), "Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Table")) "RV Specification Value Setting"."List Value" where("QC Specification Name" = field("QC Specification Name"), "QC Parameter Name" = field("QC Parameter Name"), "Value Table Name" = field("Value Table Name"));

            trigger OnValidate()
            begin
                if "QC Result" = '' then
                    "Check Status" := "Check Status"::Init
                else
                    CheckQCResultRange();
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
        field(12; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
            TableRelation = "RV QC Specification";
        }
        field(100; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
            NotBlank = true;
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
        TempDecimal: Record "RV TempTextDecimal" temporary;// Temp
        Temptext: Record "RV TempTextDecimal" temporary;// Temp
        QCSpecLine: Record "RV QC Specification Line";
        SpecValueSetting: Record "RV Specification Value Setting";

        TempMaxValue: Decimal;
        TempMinValue: Decimal;
    begin
        //clear Temptext
        Temptext.Reset();
        Temptext.DeleteAll();

        //clear TempDecimal
        TempDecimal.Reset();
        TempDecimal.DeleteAll();

        Clear(TempMaxValue);
        Clear(TempMinValue);

        //if QCParameter.Get("QC Parameter Name") then begin
        //QCValueTable.Reset();
        //QCValueTable.SetRange("Value Table Name", QCParameter."Value Table Name");
        if QCSpecLine.Get("QC Specification Name", "QC Parameter Name") then begin

            CASE QCSpecLine.Type OF
                (QCSpecLine.Type::Alphanumeric):
                    begin
                        CASE QCSpecLine."Value Table Type" OF
                            (QCSpecLine."Value Table Type"::Range):
                                begin

                                    //ValidateAlphanumeric
                                    ValidateAlphanumeric("QC Result");

                                    Temptext.Reset();

                                    Temptext.Init();
                                    Temptext."Value Text" := "QC Result";
                                    Temptext.Insert();

                                    if (QCSpecLine."Minimum Value" <> '') and (QCSpecLine."Maximum Value" <> '') then begin
                                        Temptext.SetRange("Value Text", QCSpecLine."Minimum Value", QCSpecLine."Maximum Value");
                                    end
                                    else if (QCSpecLine."Minimum Value" <> '') then begin
                                        Temptext.SetFilter("Value Text", '%1..', QCSpecLine."Minimum Value");
                                    end
                                    else if (QCSpecLine."Maximum Value" <> '') then begin
                                        Temptext.SetFilter("Value Text", '..%1', QCSpecLine."Maximum Value");
                                    end;

                                    //Error('QC Result cannot be checked because QC Specification Line do not exist.');

                                    if not Temptext.IsEmpty() then
                                        "Check Status" := "Check Status"::PASSED
                                    else
                                        "Check Status" := "Check Status"::FAILED;
                                end;
                            (QCSpecLine."Value Table Type"::Single):
                                begin
                                    //None
                                end;
                            (QCSpecLine."Value Table Type"::Table):
                                begin
                                    if SpecValueSetting.Get("QC Specification Name", "QC Parameter Name", QCSpecLine."Value Table Name", "QC Result") then
                                        "Check Status" := SpecValueSetting."Check Status"
                                    else
                                        "Check Status" := "Check Status"::Init;
                                end;
                            (QCSpecLine."Value Table Type"::List):
                                begin
                                    if SpecValueSetting.Get("QC Specification Name", "QC Parameter Name", QCSpecLine."Value Table Name", "QC Result") then
                                        "Check Status" := SpecValueSetting."Check Status"
                                    else
                                        "Check Status" := "Check Status"::Init;
                                end;
                        END;

                    end;
                (QCSpecLine.Type::Numeric):
                    begin
                        CASE QCSpecLine."Value Table Type" OF
                            (QCSpecLine."Value Table Type"::Range):
                                begin

                                    //ValidateNumeric
                                    ValidateNumeric("QC Result");

                                    TempDecimal.Reset();

                                    TempDecimal.Init();
                                    TempDecimal."Value Text" := 'Temp';
                                    if Evaluate(TempDecimal."Value Decimal", "QC Result") then
                                        TempDecimal.Insert()
                                    else
                                        Error('Please enter a Numeric.');

                                    if Evaluate(TempMinValue, QCSpecLine."Minimum Value") then;
                                    if Evaluate(TempMaxValue, QCSpecLine."Maximum Value") then;

                                    if (QCSpecLine."Minimum Value" <> '') and (QCSpecLine."Maximum Value" <> '') then begin
                                        TempDecimal.SetRange("Value Decimal", TempMinValue, TempMaxValue);
                                    end
                                    else if (QCSpecLine."Minimum Value" <> '') then begin
                                        TempDecimal.SetFilter("Value Decimal", '%1..', TempMinValue);
                                    end
                                    else if (QCSpecLine."Maximum Value" <> '') then begin
                                        TempDecimal.SetFilter("Value Decimal", '..%1', TempMaxValue);
                                    end;

                                    if not TempDecimal.IsEmpty() then
                                        "Check Status" := "Check Status"::PASSED
                                    else
                                        "Check Status" := "Check Status"::FAILED;

                                end;
                            (QCSpecLine."Value Table Type"::Single):
                                begin
                                    //None
                                end;
                            (QCSpecLine."Value Table Type"::Table):
                                begin
                                    if SpecValueSetting.Get("QC Specification Name", "QC Parameter Name", QCSpecLine."Value Table Name", "QC Result") then
                                        "Check Status" := SpecValueSetting."Check Status"
                                    else
                                        "Check Status" := "Check Status"::Init;
                                end;
                            (QCSpecLine."Value Table Type"::List):
                                begin
                                    if SpecValueSetting.Get("QC Specification Name", "QC Parameter Name", QCSpecLine."Value Table Name", "QC Result") then
                                        "Check Status" := SpecValueSetting."Check Status"
                                    else
                                        "Check Status" := "Check Status"::Init;
                                end;
                        END;

                    end;
            END;
        end;
        //end;
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