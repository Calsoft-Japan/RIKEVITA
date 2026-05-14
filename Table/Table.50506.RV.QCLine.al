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
                    Type := Type::" ";
                    "Value Table Type" := "Value Table Type"::" ";
                end;
            end;
        }
        field(5; "QC Result"; Text[50])
        {
            Caption = 'QC Result';
            TableRelation =
            if ("Value Table Type" = const("List")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Single")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"))
            else
            if ("Value Table Type" = const("Table")) "RV QC List Value"."List Value" where("Value Table Name" = field("Value Table Name"));
            //ValidateTableRelation = false;
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
        TempInteger: Record "Integer" temporary;// Temp
        Temptext: Record "RV QC Value Table" temporary;// Temp
        //QCSpecificationLine: Record "RV QC Specification Line";
        QCValueTable: Record "RV QC Value Table";
        QCListValue: Record "RV QC List Value";
        QCParameter: Record "RV QC Parameter";

        TempMaxValue: Decimal;
        TempMinValue: Decimal;
    begin
        //clear Temptext
        Temptext.Reset();
        Temptext.DeleteAll();

        //clear TempInteger
        TempInteger.Reset();
        TempInteger.DeleteAll();

        Clear(TempMaxValue);
        Clear(TempMinValue);

        if QCParameter.Get("QC Parameter Name") then begin
            QCValueTable.Reset();
            QCValueTable.SetRange("Value Table Name", QCParameter."Value Table Name");
            if QCValueTable.FindFirst() then begin

                CASE QCValueTable.Type OF
                    (QCValueTable.Type::Alphanumeric):
                        begin

                            CASE QCValueTable."Value Table Type" OF
                                (QCValueTable."Value Table Type"::Range):
                                    begin

                                        Temptext.Reset();

                                        Temptext.Init();
                                        Temptext."Value Table Name" := "QC Result";
                                        Temptext.Insert();

                                        if (QCValueTable."Minimum Value" <> '') and (QCValueTable."Maximum Value" <> '') then begin
                                            Temptext.SetRange("Value Table Name", QCValueTable."Minimum Value", QCValueTable."Maximum Value");
                                        end
                                        else if (QCValueTable."Minimum Value" <> '') then begin
                                            Temptext.SetFilter("Value Table Name", '%1..', QCValueTable."Minimum Value");
                                        end
                                        else if (QCValueTable."Maximum Value" <> '') then begin
                                            Temptext.SetFilter("Value Table Name", '..%1', QCValueTable."Maximum Value");
                                        end;

                                        //Error('QC Result cannot be checked because QC Specification Line do not exist.');

                                        if not Temptext.IsEmpty() then
                                            "Check Status" := "Check Status"::PASSED
                                        else
                                            "Check Status" := "Check Status"::FAILED;
                                    end;
                                (QCValueTable."Value Table Type"::Single):
                                    begin
                                        //None
                                    end;
                                (QCValueTable."Value Table Type"::Table):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                                (QCValueTable."Value Table Type"::List):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                            END;

                        end;
                    (QCValueTable.Type::Numeric):
                        begin

                            TempInteger.Reset();

                            TempInteger.Init();
                            if Evaluate(TempInteger.Number, "QC Result") then
                                TempInteger.Insert()
                            else
                                Error('Please enter a Numeric.');

                            CASE QCValueTable."Value Table Type" OF
                                (QCValueTable."Value Table Type"::Range):
                                    begin

                                        if Evaluate(TempMinValue, QCValueTable."Minimum Value") then;
                                        if Evaluate(TempMaxValue, QCValueTable."Maximum Value") then;

                                        if (QCValueTable."Minimum Value" <> '') and (QCValueTable."Maximum Value" <> '') then begin
                                            TempInteger.SetRange(Number, TempMinValue, TempMaxValue);
                                        end
                                        else if (QCValueTable."Minimum Value" <> '') then begin
                                            TempInteger.SetFilter(Number, '%1..', TempMinValue);
                                        end
                                        else if (QCValueTable."Maximum Value" <> '') then begin
                                            TempInteger.SetFilter(Number, '..%1', TempMaxValue);
                                        end;

                                        //Error('QC Result cannot be checked because QC Specification Line do not exist.');

                                        if not TempInteger.IsEmpty() then
                                            "Check Status" := "Check Status"::PASSED
                                        else
                                            "Check Status" := "Check Status"::FAILED;

                                    end;
                                (QCValueTable."Value Table Type"::Single):
                                    begin
                                        //None
                                    end;
                                (QCValueTable."Value Table Type"::Table):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                                (QCValueTable."Value Table Type"::List):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                            END;

                        end;
                    (QCValueTable.Type::Blooean):
                        begin
                            if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                "Check Status" := QCListValue."Check Status"
                            else
                                "Check Status" := "Check Status"::Init;
                        end;
                    (QCValueTable.Type::" "):
                        begin

                            CASE QCValueTable."Value Table Type" OF
                                (QCValueTable."Value Table Type"::Range):
                                    begin
                                        //None
                                    end;
                                (QCValueTable."Value Table Type"::Single):
                                    begin
                                        //None
                                    end;
                                (QCValueTable."Value Table Type"::Table):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                                (QCValueTable."Value Table Type"::List):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", "QC Result") then
                                            "Check Status" := QCListValue."Check Status"
                                        else
                                            "Check Status" := "Check Status"::Init;
                                    end;
                            END;
                        end;
                END;
            end;
        end;
    end;
}