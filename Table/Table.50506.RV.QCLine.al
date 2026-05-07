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
        field(5; "QC Result"; Text[50])
        {
            Caption = 'QC Result';
            trigger OnValidate()
            begin
                if "QC Result" = '' then
                    "Check Status" := "Check Status"::Init
                else
                    CheckQCResultRange("QC Result", "Check Status", "QC Parameter Name");
            end;

            trigger OnLookup()
            var
                ValueTableType: Enum "RV Value Table Type";
                //ValueTable: Record "RV QC Value Table";


                QCListValue: Record "RV QC List Value";
            //QCListValuePage: Page "RV QC List Value";
            begin
                if Rec."Value Table Type" in [ValueTableType::List, ValueTableType::Single, ValueTableType::Table] then begin
                    //Clear(QCListValuePage);
                    QCListValue.Reset();
                    QCListValue.SetRange("Value Table Name", "Value Table Name");

                    if (Page.RunModal(Page::"RV QC List Value List", QCListValue) = Action::LookupOK) then begin
                        "QC Result" := QCListValue."List Value";
                        "Check Status" := QCListValue."Check Status";
                        Modify();
                    end;

                    //QCListValuePage.SetTableView(QCListValue);
                    //QCListValuePage.LookupMode(true);
                    //if (QCListValuePage.RunModal() = Action::LookupOK) then begin
                    /*
                    if (Page.RunModal(Page::"RV QC List Value", QCListValue) = Action::LookupOK) then begin
                        //QCListValuePage.GetRecord(QCListValue);
                        "QC Result" := QCListValue."List Value";
                        "Check Status" := QCListValue."Check Status";
                        Modify();
                    end;
                    */
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
    /*
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
    */
    procedure CheckQCResultRange(QCResult: Text[50]; var CheckStatus: Enum "RV Check Status"; QCParameterName: Code[20])
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


        if QCParameter.Get(QCParameterName) then begin
            QCValueTable.Reset();
            QCValueTable.SetRange("Value Table Name");
            if QCValueTable.FindFirst() then begin

                CASE QCValueTable.Type OF
                    (QCValueTable.Type::Alphanumeric):
                        begin

                            CASE QCValueTable."Value Table Type" OF
                                (QCValueTable."Value Table Type"::Range):
                                    begin

                                        Temptext.Reset();

                                        Temptext.Init();
                                        Temptext."Value Table Name" := QCResult;
                                        Temptext.Insert();

                                        Temptext.SetRange("Value Table Name", QCValueTable."Minimum Value", QCValueTable."Maximum Value");

                                        //Error('QC Result cannot be checked because QC Specification Line do not exist.');

                                        if not Temptext.IsEmpty() then
                                            CheckStatus := CheckStatus::PASSED
                                        else
                                            CheckStatus := CheckStatus::FAILED;

                                    end;
                                (QCValueTable."Value Table Type"::Single):
                                    begin

                                    end;
                                (QCValueTable."Value Table Type"::Table):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", QCResult) then
                                            CheckStatus := QCListValue."Check Status"
                                        else
                                            CheckStatus := CheckStatus::Init;
                                    end;
                                (QCValueTable."Value Table Type"::List):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", QCResult) then
                                            CheckStatus := QCListValue."Check Status"
                                        else
                                            CheckStatus := CheckStatus::Init;
                                    end;
                            END;

                        end;
                    (QCValueTable.Type::Numeric):
                        begin

                            TempInteger.Reset();

                            TempInteger.Init();
                            if Evaluate(TempInteger.Number, QCResult) then
                                TempInteger.Insert()
                            else
                                Error('Please enter a Numeric.');

                            CASE QCValueTable."Value Table Type" OF
                                (QCValueTable."Value Table Type"::Range):
                                    begin

                                        if Evaluate(TempMinValue, QCValueTable."Minimum Value") then;
                                        if Evaluate(TempMaxValue, QCValueTable."Maximum Value") then;

                                        TempInteger.SetRange(Number, TempMinValue, TempMaxValue);

                                        //Error('QC Result cannot be checked because QC Specification Line do not exist.');

                                        if not TempInteger.IsEmpty() then
                                            "Check Status" := "Check Status"::PASSED
                                        else
                                            "Check Status" := "Check Status"::FAILED;

                                    end;
                                (QCValueTable."Value Table Type"::Single):
                                    begin

                                    end;
                                (QCValueTable."Value Table Type"::Table):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", QCResult) then
                                            CheckStatus := QCListValue."Check Status"
                                        else
                                            CheckStatus := CheckStatus::Init;
                                    end;
                                (QCValueTable."Value Table Type"::List):
                                    begin
                                        if QCListValue.Get(QCValueTable."Value Table Name", QCResult) then
                                            CheckStatus := QCListValue."Check Status"
                                        else
                                            CheckStatus := CheckStatus::Init;
                                    end;
                            END;

                        end;
                    (QCValueTable.Type::Blooean):
                        begin
                            if QCListValue.Get(QCValueTable."Value Table Name", QCResult) then
                                CheckStatus := QCListValue."Check Status"
                            else
                                CheckStatus := CheckStatus::Init;
                        end;
                    (QCValueTable.Type::" "):
                        begin

                        end;
                END;
            end;
        end;
    end;
}