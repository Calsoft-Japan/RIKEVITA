/// <summary>
/// Report RV RV_COA Report (ID 50500)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
report 50500 "RV_COA Report"
{
    Caption = 'COA Report';
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_COAReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("QA Header"; "RV QA Header")
        {
            DataItemTableView = sorting("COA No.");
            RequestFilterFields = "COA No.", "Ship-to Customer No.";
            RequestFilterHeading = 'COA Header';
            column(QA_Header_No; "COA No.")
            {
            }
            column(METHOD_Caption; METHOD_Caption)
            {
            }
            column(SPECIFICATION_Caption; SPECIFICATION_Caption)
            {
            }
            column(SalesOrderNoText; SalesOrderNoText)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(MARKSText_1; MARKSText[1])
                    {
                    }
                    column(MARKSText_2; MARKSText[2])
                    {
                    }
                    column(MARKSText_3; MARKSText[3])
                    {
                    }
                    column(MARKSText_4; MARKSText[4])
                    {
                    }
                    column(PRODUCTText; PRODUCTText)
                    {
                    }
                    column(DateText; Format_DateText)
                    {
                    }
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo_Name; CompanyInfo.Name)
                    {
                    }
                    column(CompanyInfo_Registration; 'Registration No. ' + CompanyInfo."Registration No.")
                    {
                    }
                    column(DisplayQuantityPerLot; DisplayQuantityPerLot)
                    {
                    }
                    column(DateWordingText; DateWordingText)
                    {
                    }
                    column(DateWording_remarkText; DateWording_remarkText)
                    {
                    }
                    column(MARKSCommentAll; MARKSCommentAll)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("RV QA Shipment Lot No."; "RV QA Shipment Lot No.")
                    {
                        DataItemLink = "COA No." = FIELD("COA No.");
                        DataItemLinkReference = "QA Header";
                        DataItemTableView = sorting("COA No.", "container No.", "Lot No.");

                        column(ContainerNo; "Container No.")//CONTAINER
                        {
                        }
                        column(Header_Quantity; HeaderQuantity)//HeaderQuantity
                        {
                        }
                        column(QAShipmentLine_Item_No; "QA Header"."Item No.")
                        {
                        }
                        column(Line_Quantity; LineQuantity)
                        {
                        }
                        column(UOM; UOM)
                        {
                        }
                        column(comment; "Comment")
                        {
                        }
                        column(QAShipmentLine_Line_No; "RV QA Shipment Lot No."."COA Lot Line No.")
                        {
                        }
                        column(Line_COANo; "COA No.")
                        {
                        }
                        column(LotNo; "lot No.")
                        {
                        }
                        column(PRODDATE; FormatManufacturingDateText)
                        {
                        }
                        column(BESTBEFOREDATE; FormatExpireDateText)
                        {
                        }
                        dataitem(ExternalQCLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ExternalQCLoop_Number; ExternalQCLoop.Number)//1
                            {
                            }
                            column(SpecLineNo; SpecLineNoText)//1
                            {
                            }
                            column(QCParameterName; ExternalQCResults."QC Parameter Name")//2
                            {
                            }
                            column(METHOD; METHODText) //3
                            {
                            }
                            column(SPECIFICATION; SPECIFICATIONText) //4
                            {
                            }
                            column(result; resultText) //5
                            {
                            }
                            column(COAlotNo; COAlotNo) //add
                            {
                            }
                            column(COAContainerNo; COAContainerNo) //add
                            {
                            }
                            trigger OnPreDataItem()
                            begin
                                ExternalQCResults.SetCurrentKey("COA No.", "COA Container No.", "COA Lot No.");
                                ExternalQCResults.SetRange("COA No.", "RV QA Shipment Lot No."."COA No.");//COA Lot Line No.
                                //ExternalQCResults.SetRange("COA Container No.", "RV QA Shipment Lot No."."Container No.");//COA Container No.
                                ExternalQCResults.SetRange("COA Lot No.", "RV QA Shipment Lot No."."Lot No.");//COA Lot No.
                                SETRANGE(Number, 1, ExternalQCResults.COUNT);
                            end;

                            trigger OnAfterGetRecord()
                            begin

                                IF Number = 1 THEN BEGIN
                                    IF ExternalQCResults.FIND('-') THEN;
                                END ELSE
                                    IF ExternalQCResults.NEXT = 0 THEN;

                                CLEAR(METHODText);
                                CLEAR(SPECIFICATIONText);
                                CLEAR(resultText);
                                CLEAR(SpecLineNoText);
                                clear(COAContainerNo);
                                clear(COAlotNo);

                                CASE DisplayMethodCharsSpec OF
                                    DisplayMethodCharsSpec::Method:
                                        begin

                                            METHODText := ExternalQCResults."QC Value";
                                            SPECIFICATIONText := '';
                                        end;
                                    DisplayMethodCharsSpec::"Chars Spec.":
                                        begin

                                            METHODText := '';
                                            IF (ExternalQCResults."Alpha. Min" <> '') OR (ExternalQCResults."Alpha. Max" <> '') THEN
                                                SPECIFICATIONText := ExternalQCResults."Alpha. Min" + '..' + ExternalQCResults."Alpha. Max";
                                        end;
                                    DisplayMethodCharsSpec::"Method &Chars Spec.":
                                        begin

                                            METHODText := ExternalQCResults."QC Value";
                                            IF (ExternalQCResults."Alpha. Min" <> '') OR (ExternalQCResults."Alpha. Max" <> '') THEN
                                                SPECIFICATIONText := ExternalQCResults."Alpha. Min" + '..' + ExternalQCResults."Alpha. Max";
                                        end;
                                    DisplayMethodCharsSpec::"None":
                                        begin
                                            METHODText := '';
                                            SPECIFICATIONText := '';
                                        END;
                                end;

                                resultText := ExternalQCResults."COA Value";
                                COAlotNo := ExternalQCResults."COA Lot No.";
                                COAContainerNo := ExternalQCResults."COA Container No.";
                                SpecLineNoText := Format(Number) + '.';
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            UOM := UOM;

                            Clear(HeaderQuantity);
                            Clear(ContainerNo);
                            Clear(LineQuantity);
                            Clear(QtyCalculated);
                            Clear(FormatExpireDateText);
                            Clear(FormatManufacturingDateText);

                            if not Item.get("QA Header"."Item No.") then
                                Item.Init();

                            "RV QA Shipment Lot No.".CalcFields("Container Quantity", "Container Qty. (Base)");
                            LineQuantity := Format("RV QA Shipment Lot No."."Qty. (Base)") + ' ' + Item."Base Unit of Measure";
                            ContainerNo := "RV QA Shipment Lot No."."Container No.";

                            Clear(UOMMgt);
                            Clear(QtyCalculated);
                            if "RV QA Shipment Lot No."."Qty. (Base)" <> 0 then
                                QtyCalculated := Round("RV QA Shipment Lot No.".Quantity / "RV QA Shipment Lot No."."Qty. (Base)", UOMMgt.QtyRndPrecision());

                            HeaderQuantity := 'NET ' +
                            format("RV QA Shipment Lot No."."Container Quantity") +
                            ' KG (NET ' +
                            format(QtyCalculated) + ' ' +
                            "RV QA Shipment Lot No.".UOM + ' x ' +
                            format("RV QA Shipment Lot No."."Container Qty. (Base)") + ' ' +
                            Item."Base Unit of Measure" + ')';

                            /*
                            Sample data: “NET 400.00 KG(NET 20.00 KG x 20 CTN)”.
                            Sample data: “NET 100.00 KG(NET 25.00 KG x 4 BAG)”.
                            Data Logic:
                            “NET” is fix information. 
                            “400.00” is calculated results by Base UOM. 
                            “KG” is Item’s Base UOM.
                            ”(NET “ is fix information.
                            “20.00” is the  “Qty. per UOM” of UM field get from “Shipment Lot No. List”.  
                            “KG” is Item’s Base UOM.
                            ”x” is fix information.
                            “20” is the “Qty.” of “Shipment Lot No. List”. 
                            “CTN” is   UM field of “Shipment Lot No. List”.
                            */
                            //FormatManufacturingDateText
                            if DateCalculation = DateCalculation::"Shelf Life By Months Without Days MMM-YYYY" then begin
                                FormatManufacturingDateText := Format("RV QA Shipment Lot No."."Manufacturing Date", 0, '<Month Text,3>-<Year4>');
                            end else if DateCalculation = DateCalculation::"Shelf Life By Months DD-MMM-YYYY" then begin
                                FormatManufacturingDateText := Format("RV QA Shipment Lot No."."Manufacturing Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
                            end;
                            //FormatExpireDateText
                            if DateCalculation = DateCalculation::"Shelf Life By Months Without Days MMM-YYYY" then begin //Dec-2025
                                FormatExpireDateText := Format("RV QA Shipment Lot No."."Expire Date", 0, '<Month Text,3>-<Year4>');
                            end else if DateCalculation = DateCalculation::"Shelf Life By Months DD-MMM-YYYY" then begin //16-Sep-2025
                                CASE ExpiredDateCalclogic of
                                    ExpiredDateCalclogic::"By days": //16-Sep-2025
                                        begin
                                            FormatExpireDateText := Format("RV QA Shipment Lot No."."Expire Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
                                        end;
                                    ExpiredDateCalclogic::"By month": //Dec-2025
                                        begin
                                            FormatExpireDateText := Format("RV QA Shipment Lot No."."Expire Date", 0, '<Month Text,3>-<Year4>');
                                        end;
                                    ExpiredDateCalclogic::"By month + end of the month": //31-Sep-2025
                                        begin
                                            FormatExpireDateText := Format(CalcDate('+CM', "RV QA Shipment Lot No."."Expire Date"), 0, '<Day,2>-<Month Text,3>-<Year4>');
                                        end;
                                end;
                            end;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        OutputNo += 1;
                    end;
                    PRODUCTText := "QA Header"."Item Description";
                end;

                trigger OnPreDataItem()
                begin
                    CopyText := '';
                    SetRange(Number, 1);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //ClearData
                ClearData();

                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                QAShipmentLotNo.SetRange("COA No.", "COA No.");

                //SalesOrderNoText
                Clear(SalesOrderNoText);
                CollectUniqueSalesOrderNo("COA No.");
                CollectAllMARKSComment("COA No.");

                Clear(PRODUCTText);
                Clear(MARKSText);
                Clear(MARKSList);

                //MARKSText
                if "Mark" <> '' then begin
                    MARKSList := "Mark".Split(TypeHelper.LFSeparator());
                    if MARKSList.Get(1, MARKSText[1]) then;
                    if MARKSList.Get(2, MARKSText[2]) then;
                    if MARKSList.Get(3, MARKSText[3]) then;
                    if MARKSList.Get(4, MARKSText[4]) then;
                end;

                //MARKS
                //MARKSText[1] := 'BRENNTAG';
                //MARKSText[2] := 'INGREDIENTS';
                //MARKSText[3] := 'BANGKOK';
                //MARKSText[4] := 'MADE IN MALAYSIA';

                Clear(DisplayQuantityPerLot);
                Clear(DateCalculation);
                Clear(DisplayMethodCharsSpec);
                Clear(DateWordingText);
                Clear(DateWording_remarkText);

                CustCOAReportSetting.Reset();
                CustCOAReportSetting.SetRange("Customer No.", "Ship-to Customer No.");
                CustCOAReportSetting.SetRange("Ship-to Code", "Ship-to Code");
                if CustCOAReportSetting.FindFirst() then begin
                    DisplayQuantityPerLot := CustCOAReportSetting."Display Quantity Per Lot.";
                    DisplayMethodCharsSpec := CustCOAReportSetting."Display Method&Chars Spec.";
                    DateCalculation := CustCOAReportSetting."Date Calculation";
                    ExpiredDateCalclogic := CustCOAReportSetting."Expired Date Calc. logic";
                    //DateWording
                    if (CustCOAReportSetting."Date Wording" = DateWording::"Best Before Date") then begin
                        DateWordingText := 'BEST BEFORE DATE';
                        DateWording_remarkText := 'Best Before Date';
                    end else if (CustCOAReportSetting."Date Wording" = DateWording::"Expiry Date") then begin
                        DateWordingText := 'EXPIRY DATE';
                        DateWording_remarkText := 'Expiry Date';
                    end;

                    //"Display COA Date"
                    if (CustCOAReportSetting."Display COA Date" = DisplayCOADate::"COA Created Date") then
                        Format_DateText := Format("QA Header"."COA Created Date", 0, '<Day,2>-<Month Text,3>-<Year4>')
                    else if (CustCOAReportSetting."Display COA Date" = DisplayCOADate::"COA Print Date") then
                        Format_DateText := Format(WorkDate(), 0, '<Day,2>-<Month Text,3>-<Year4>');

                end else begin
                    CustCOAReportSetting.Reset();
                    CustCOAReportSetting.SetRange("Customer No.", "Ship-to Customer No.");
                    if CustCOAReportSetting.FindFirst() then begin
                        DisplayQuantityPerLot := CustCOAReportSetting."Display Quantity Per Lot.";
                        DisplayMethodCharsSpec := CustCOAReportSetting."Display Method&Chars Spec.";
                        DateCalculation := CustCOAReportSetting."Date Calculation";
                        ExpiredDateCalclogic := CustCOAReportSetting."Expired Date Calc. logic";

                        //DateWording
                        if (CustCOAReportSetting."Date Wording" = DateWording::"Best Before Date") then begin
                            DateWordingText := 'BEST BEFORE DATE';
                            DateWording_remarkText := 'Best Before Date';
                        end else if (CustCOAReportSetting."Date Wording" = DateWording::"Expiry Date") then begin
                            DateWordingText := 'EXPIRY DATE';
                            DateWording_remarkText := 'Expiry Date';
                        end;
                        //"Display COA Date"
                        if (CustCOAReportSetting."Display COA Date" = DisplayCOADate::"COA Created Date") then
                            Format_DateText := Format("QA Header"."COA Created Date", 0, '<Day,2>-<Month Text,3>-<Year4>')
                        else if (CustCOAReportSetting."Display COA Date" = DisplayCOADate::"COA Print Date") then
                            Format_DateText := Format(WorkDate(), 0, '<Day,2>-<Month Text,3>-<Year4>');

                    end else begin
                        DisplayQuantityPerLot := false;
                        Error('Please Setup RV Cust. COA Report Setting.');
                    end;
                end;

                //DisplayMethodCharsSpec
                CASE DisplayMethodCharsSpec OF
                    DisplayMethodCharsSpec::Method:
                        begin
                            METHOD_Caption := 'METHOD';
                            SPECIFICATION_Caption := '';
                        end;
                    DisplayMethodCharsSpec::"Chars Spec.":
                        begin
                            METHOD_Caption := '';
                            SPECIFICATION_Caption := 'SPECIFICATION';
                        end;
                    DisplayMethodCharsSpec::"Method &Chars Spec.":
                        begin
                            METHOD_Caption := 'METHOD';
                            SPECIFICATION_Caption := 'SPECIFICATION';
                        end;
                    DisplayMethodCharsSpec::"None":
                        begin
                            METHOD_Caption := '';
                            SPECIFICATION_Caption := '';
                        END;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        CurrReport.Language(1033);
    end;

    var

        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        UOMMgt: Codeunit "Unit of Measure Management";

        ExternalQCResults: Record "RV QA External QC Results";
        CompanyInfo: Record "Company Information";
        CustCOAReportSetting: Record "RV Cust. COA Report Setting";
        DateWording: Enum "RV Date Wording";
        DisplayCOADate: Enum "RV Display COA Date";
        DisplayMethodCharsSpec: Enum "RV Display Method Chars Spec.";
        DateWordingText: Text;
        DateWording_remarkText: Text;
        DisplayQuantityPerLot: Boolean;
        DateCalculation: Enum "RV Date Calculation";
        ExpiredDateCalclogic: Enum "RV Expired Date Calc. logic";
        METHOD_Caption: Text;
        SPECIFICATION_Caption: Text;
        METHODText: Text;
        ContainerNo: Text;
        HeaderQuantity: Text;
        LineQuantity: Text;
        QtyCalculated: Decimal;
        SPECIFICATIONText: Text;
        SalesOrderNoText: Text;
        MARKSText: array[4] of Text;
        MARKSList: List of [Text];
        TypeHelper: Codeunit "Type Helper";
        CopyText: Text[50];
        OutputNo: Integer;
        UOM: Text[50];
        Item: Record Item;
        FormatExpireDateText: Text;
        FormatManufacturingDateText: Text;
        resultText: Text;
        SpecLineNoText: Text;
        COAlotNo: Text;
        COAContainerNo: Text;
        PRODUCTText: Text;
        Format_DateText: Text;
        MARKSCommentAll: Text;

    procedure CollectUniqueSalesOrderNo(ParCOANO: Code[20])
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        SalesOrderNoList: List of [Code[20]];
        SONo: Code[20];
        i: Integer;
    begin
        QAShipmentLotNo.SetRange("COA No.", ParCOANO);
        if QAShipmentLotNo.FindSet() then
            repeat
                //Collect unique entries
                if not SalesOrderNoList.Contains(QAShipmentLotNo."Sales Order No.") then
                    SalesOrderNoList.Add(QAShipmentLotNo."Sales Order No.");
            until QAShipmentLotNo.Next() = 0;

        //Read and show each enique Customer No.
        foreach SONo in SalesOrderNoList do begin
            i += 1;
            if i = 1 then
                SalesOrderNoText := SONo
            else
                SalesOrderNoText += '/' + SONo;

        end;
    end;

    procedure CollectAllMARKSComment(ParCOANO: Code[20])
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        LineComment: Text;
    begin
        Clear(MARKSCommentAll);

        QAShipmentLotNo.SetRange("COA No.", ParCOANO);
        if QAShipmentLotNo.FindSet() then
            repeat
                LineComment := QAShipmentLotNo."Comment";
                if LineComment <> '' then begin
                    if MARKSCommentAll <> '' then
                        MARKSCommentAll += TypeHelper.LFSeparator();
                    MARKSCommentAll += LineComment;
                end;
            until QAShipmentLotNo.Next() = 0;
    end;

    procedure ClearData()
    begin
        Clear(DateWordingText);
        Clear(DateWording_remarkText);
        Clear(DisplayQuantityPerLot);
        Clear(METHOD_Caption);
        Clear(SPECIFICATION_Caption);
        Clear(METHODText);
        Clear(ContainerNo);
        Clear(HeaderQuantity);
        Clear(LineQuantity);
        Clear(QtyCalculated);
        Clear(SPECIFICATIONText);
        Clear(SalesOrderNoText);
        Clear(MARKSText);
        Clear(MARKSList);
        Clear(FormatExpireDateText);
        Clear(resultText);
        COAlotNo := '';
        Clear(SpecLineNoText);
        Clear(PRODUCTText);
        Clear(Format_DateText);
        Clear(UOM);
        Clear(MARKSCommentAll);
    end;
}

