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
    //WordMergeDataItem = "RV_COA Header";  // 

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
            column(TotalPageText; TotalPageText)
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
                    column(STRSUBSTNO_Text002_FORMAT_CurrReport_PAGENO__; StrSubstNo(Text002Txt, Format(1)))
                    {
                    }
                    column(PageCaptionLbl; PageCaptionLbl)
                    {
                    }
                    column(TransferToAddr_1_; TransferToAddr[1])
                    {
                    }
                    column(TransferFromAddr_1_; TransferFromAddr[1])
                    {
                    }
                    column(TransferToAddr_2_; TransferToAddr[2])
                    {
                    }
                    column(TransferFromAddr_2_; TransferFromAddr[2])
                    {
                    }
                    column(TransferToAddr_3_; TransferToAddr[3])
                    {
                    }
                    column(TransferFromAddr_3_; TransferFromAddr[3])
                    {
                    }
                    column(TransferToAddr_4_; TransferToAddr[4])
                    {
                    }
                    column(TransferFromAddr_4_; TransferFromAddr[4])
                    {
                    }

                    column(TransferToAddr_5_; TransferToAddr[5])
                    {
                    }

                    column(TransferFromAddr_5_; TransferFromAddr[5])
                    {
                    }
                    column(QA_Header___No__; "QA Header"."COA No.")
                    {
                    }
                    column(DateText; Format_DateText)
                    {
                    }
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(TransferToAddr_7_; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr_6_; TransferToAddr[6])
                    {
                    }
                    column(TransferToAddr_8_; TransferToAddr[8])
                    {
                    }
                    column(TransferFromAddr_7_; TransferFromAddr[7])
                    {
                    }
                    column(TransferFromAddr_6_; TransferFromAddr[6])
                    {
                    }
                    column(TransferFromAddr_8_; TransferFromAddr[8])
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "QA Header";
                        DataItemTableView = sorting(Number) where(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1_Number; DimensionLoop1.Number)
                        {
                        }
                        column(DimText_Control80; DimText)
                        {
                        }


                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.Find('-') then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();
                            /*
                            CLEAR(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo(
                                      Subst01Txt, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        Subst02Txt, DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until (DimSetEntry1.Next() = 0);
                            */
                        end;
                    }
                    dataitem("RV QA Shipment Lot No."; "RV QA Shipment Lot No.")
                    {
                        DataItemLink = "COA No." = FIELD("COA No.");
                        DataItemLinkReference = "QA Header";
                        DataItemTableView = sorting("COA No.", "COA Lot Line No.");
                        column(QAShipmentLine_Item_No; "QA Header"."Item No.")
                        {
                        }
                        column(Line_Quantity; Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UOM; UOM)
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
                        column(PRODDATE; FormatExpireDateText)
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

                            trigger OnPreDataItem()
                            begin
                                ExternalQCResults.SetRange("COA No.", "RV QA Shipment Lot No."."COA No.");//COA Lot Line No.
                                ExternalQCResults.SetRange("COA Lot Line No.", "RV QA Shipment Lot No."."COA Lot Line No.");//COA Lot Line No.

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




                                CASE DisplayMethodCharsSpec OF
                                    DisplayMethodCharsSpec::Method:
                                        begin

                                            METHODText := ExternalQCResults."QC Value";
                                            SPECIFICATIONText := '';
                                        end;
                                    DisplayMethodCharsSpec::"Chars Spec.":
                                        begin

                                            METHODText := '';
                                            SPECIFICATIONText := ExternalQCResults."Alpha. Max" + ExternalQCResults."Alpha. Min";
                                        end;
                                    DisplayMethodCharsSpec::"Method&Chars Spec.":
                                        begin

                                            METHODText := ExternalQCResults."QC Value";
                                            SPECIFICATIONText := ExternalQCResults."Alpha. Max" + ExternalQCResults."Alpha. Min";
                                        end;
                                    DisplayMethodCharsSpec::"None":
                                        begin
                                            METHODText := '';
                                            SPECIFICATIONText := '';
                                        END;
                                end;



                                resultText := ExternalQCResults."COA Value";
                                SpecLineNoText := Format(ExternalQCResults."QC External Spec. Line No.") + '.';
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //UOM := JPCK_Functions.GetUnitOfMeasureText(UOM, CurrReport.Language);
                            UOM := UOM;




                            TransferFromAddr[4] := format("RV QA Shipment Lot No.".Quantity);

                            if DateCalculation = DateCalculation::"Shelf Life By Months Without Days MMM-YYYY" then
                                FormatExpireDateText := Format("RV QA Shipment Lot No."."Expire Date", 0, '<Month Text,3>-<Year4>')
                            else if DateCalculation = DateCalculation::"Shelf Life By Months DD-MMM-YYYY" then
                                FormatExpireDateText := Format("RV QA Shipment Lot No."."Expire Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
                        end;
                    }
                    dataitem("Inventory Comment Line"; "Inventory Comment Line")
                    {
                        DataItemLink = "No." = field("COA No.");
                        DataItemLinkReference = "QA Header";
                        DataItemTableView = sorting("Document Type", "No.", "Line No.");
                        column(Inventory_Comment_Line__Inventory_Comment_Line__Comment; "Inventory Comment Line".Comment)
                        {
                        }
                        column(RemarksCaption; RemarksCaptionLbl)
                        {
                        }
                        column(Inventory_Comment_Line_Document_Type; "Document Type")
                        {
                        }
                        column(Inventory_Comment_Line_No_; "No.")
                        {
                        }
                        column(Inventory_Comment_Line_Line_No_; "Line No.")
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000Txt;
                        OutputNo += 1;
                    end;
                    //MARKS
                    TransferToAddr[1] := 'BRENNTAG';
                    TransferToAddr[2] := 'INGREDIENTS';
                    TransferToAddr[3] := 'BANGKOK';
                    TransferToAddr[4] := 'MADE IN MALAYSIA';

                    //TransferFromAddr[1] := 'RVSM2507126/602135/3094';
                    TransferFromAddr[2] := "QA Header"."Item Description";
                    TransferFromAddr[3] := "RV QA Shipment Lot No."."Container No.";
                end;

                trigger OnPreDataItem()
                begin
                    //NoOfLoops := Abs(NoOfCopies) + 1;  // PBCJP-DOC-014-210-04
                    CopyText := '';
                    SetRange(Number, 1);  // PBCJP-DOC-014-210-04
                    //SetRange(Number, 1, NoOfLoops);  // PBCJP-DOC-014-210-04
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                Format_DateText := Format(Today(), 0, '<Day,2>-<Month Text,3>-<Year4>');

                DimSetEntry1.SetRange("Dimension Set ID", 1);

                Clear(TotalPageText);

                QAShipmentLotNo.SetRange("COA No.", "COA No.");
                TotalPageText := Format(QAShipmentLotNo.COUNT);

                Clear(SalesOrderNoText);
                CollectUniqueSalesOrderNo("COA No.");



                Clear(DisplayQuantityPerLot);
                Clear(DateCalculation);
                Clear(DisplayMethodCharsSpec);


                CustCOAReportSetting.Reset();
                CustCOAReportSetting.SetRange("Customer No.", "Ship-to Customer No.");
                CustCOAReportSetting.SetRange("Ship-to Code", "Ship-to Code");
                if CustCOAReportSetting.FindFirst() then begin
                    DisplayQuantityPerLot := CustCOAReportSetting."Display Quantity Per Lot.";
                    DateCalculation := CustCOAReportSetting."Date Calculation";
                    DisplayMethodCharsSpec := CustCOAReportSetting."Display Method&Chars Spec.";

                    if (CustCOAReportSetting."Date Wording" = DateWording::"Best Before Date") then begin
                        DateWordingText := 'BEST BEFORE DATE';
                        DateWording_remarkText := 'Best Before Date';
                    end else if (CustCOAReportSetting."Date Wording" = DateWording::"Expiry Date") then begin
                        DateWordingText := 'EXPIRY DATE';
                        DateWording_remarkText := 'Expiry Date';
                    end;


                end else begin
                    CustCOAReportSetting.Reset();
                    CustCOAReportSetting.SetRange("Customer No.", "Ship-to Customer No.");
                    if CustCOAReportSetting.FindFirst() then begin
                        DisplayQuantityPerLot := CustCOAReportSetting."Display Quantity Per Lot.";
                        DateCalculation := CustCOAReportSetting."Date Calculation";
                        DisplayMethodCharsSpec := CustCOAReportSetting."Display Method&Chars Spec.";

                        if (CustCOAReportSetting."Date Wording" = DateWording::"Best Before Date") then
                            DateWordingText := 'BEST BEFORE DATE'
                        else if (CustCOAReportSetting."Date Wording" = DateWording::"Expiry Date") then
                            DateWordingText := 'EXPIRY DATE';

                    end else
                        DisplayQuantityPerLot := false;

                end;

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
                    DisplayMethodCharsSpec::"Method&Chars Spec.":
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
                    // PBCJP-DOC-014-210-04: BEGIN
                    /*
                    field(NoOf_Copies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                    
                    // PBCJP-DOC-014-210-04: END
                    field(Show_InternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    */
                }
            }
        }

        actions
        {
        }
    }
    labels
    {
    }

    trigger OnInitReport()
    var
    begin

    end;

    trigger OnPreReport()
    begin
        CurrReport.Language(1033);
    end;

    var

        DimSetEntry1: Record "Dimension Set Entry";
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        ExternalQCResults: Record "RV QA External QC Results";
        CompanyInfo: Record "Company Information";

        CustCOAReportSetting: Record "RV Cust. COA Report Setting";
        DateWording: Enum "RV Date Wording";

        DisplayMethodCharsSpec: Enum "RV Display Method Chars Spec.";


        DateWordingText: Text;

        DateWording_remarkText: Text;
        DisplayQuantityPerLot: Boolean;

        DateCalculation: Enum "RV Date Calculation";


        METHOD_Caption: Text;
        SPECIFICATION_Caption: Text;

        METHODText: Text;
        SPECIFICATIONText: Text;

        SalesOrderNoText: Text;



        //FormatAddr: Codeunit "PBCJP JPCK_Format Address";
        //JPCK_Functions: Codeunit "PBCJP JPCK_Functions";
        TransferFromAddr: array[8] of Text[100];
        TransferToAddr: array[8] of Text[100];
        //NoOfCopies: Integer;
        //NoOfLoops: Integer;
        CopyText: Text[50];
        DimText: Text;
        OldDimText: Text;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        UOM: Text[50];





        FormatExpireDateText: Text;





        resultText: Text;

        SpecLineNoText: Text;

        TotalPageText: Text;


        Format_DateText: Text;

        Text000Txt: Label 'COPY';
        Text002Txt: Label 'Page %1', Comment = '%1: Page No.';

        RemarksCaptionLbl: Label 'Remarks';
        PageCaptionLbl: Label 'Page';



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

}

