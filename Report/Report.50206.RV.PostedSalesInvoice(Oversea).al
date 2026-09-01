/// <summary>
/// Report RV Posted Sales Invoice(Oversea) (ID 50206)
/// FDD018 2026/05/21: New. (Bobby.ji)
/// </summary>
report 50206 "RV PostedSalesInvoice(Oversea)"
{
    Caption = 'Sales Invoice(Oversea)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = false;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_SalesInvoice(Oversea).rdlc';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            column(Number; Number)
            {
            }
            dataitem(SalesInvoiceHeader; "Sales Invoice Header")
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.", "Bill-to Customer No.", "Sell-to Customer No.", "No. Printed";
                column(CompanyLogo; CompanyInfo.Picture)
                {
                }
                column(CompanyName; CompanyInfo.Name)
                {
                }
                column(RegistrationNo; 'Registration No. ' + CompanyInfo."RV_Registration No.")
                {
                }
                column(SSTRegNo; 'SST Reg No. ' + CompanyInfo."RV_SST Reg No.")
                {
                }
                column(CerfiticateNo; CerfiticateNo)
                {
                }
                column(ISODocumentNo; ISODocumentNo)
                {
                }
                column(ISODocVersion; ISODocVersion)
                {
                }
                column(ReportTitle; ReportTitle)
                {
                }
                column(PrintDate; Format(Today(), 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(Sales_Header_No; "No.")
                {
                }
                column(External_Document_No; "External Document No.")
                {
                }
                column(Sell_to_Customer_Name; "Sell-to Customer Name")
                {
                }
                column(Sell_to_Address; "Sell-to Address")
                {
                }
                column(Sell_to_Address2; "Sell-to Address 2")
                {
                }
                column(Sell_to_City; "Sell-to City")
                {
                }
                column(Sell_to_Post_Code; "Sell-to Post Code" + ' ' + "Sell-to City")
                {
                }
                column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
                {
                }
                column(Currency_Code; "Currency Code")
                {
                }
                column(Tranfportation; Tranfportation)
                {
                }
                column(OrderNo; OrderNo)
                {
                }
                column(FeederVessel; "RV_Feeder Vessel")
                {
                }
                column(MotherVessel; "RV_Mother Vessel")
                {
                }
                column(VIA; "RV_VIA")
                {
                }
                column(FromValue; "RV_Country of Origin")
                {
                }
                column(SailingOnOrAbout; Format("RV_SAILING ON OR ABOUT", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(Terms; Terms)
                {
                }
                dataitem(SalesInvoiceLine; "Sales Invoice Line")
                {
                    DataItemTableView = where(Type = const(Item));
                    DataItemLink = "Document No." = field("No.");
                    column(Item_No; "No.")
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    column(Description2; Description2)
                    {
                    }
                    column(Quantity; Format(Quantity) + ' ' + "Unit of Measure Code")
                    {
                    }
                    column(Quantity_Base; '(' + Format("Quantity (Base)") + ' ' + BaseUnitofMeasure + ')')
                    {
                    }
                    column(Unit_Price; UnitPrice)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Line_Discount_Amount; "Line Discount Amount")
                    {
                    }
                    column(Line_Amount; LineAmount)
                    {
                    }
                    column(SalesOrderNo; SalesOrderNo)
                    {
                    }
                    column(CustomerPO; CustomerPO)
                    {
                    }
                    column(SalesListComment; SalesListComment)
                    {
                    }
                    trigger OnAfterGetRecord()
                    var
                        RecItem: Record Item;
                        RecSalesShipmentHeader: Record "Sales Shipment Header";
                        RecItemReference: Record "Item Reference";
                    begin
                        SalesOrderNo := '';
                        CustomerPO := '';
                        FOBAmount := 0;
                        SalesListComment := '';
                        RecItem.Get("No.");
                        if "No." = RIKEVITASetup."Freight Charge Item No" then begin
                            TotalFreightCharges += "Line Amount";
                        end;

                        if RecItem.Type = RecItem.Type::"Non-Inventory" then begin
                            CurrReport.Skip();
                        end;

                        if RecItem.Type = RecItem.Type::Inventory then begin
                            RecSalesShipmentHeader.Reset();
                            RecSalesShipmentHeader.SetRange("No.", "Shipment No.");
                            if RecSalesShipmentHeader.FindFirst() then begin
                                SalesOrderNo := RecSalesShipmentHeader."Order No.";
                                CustomerPO := RecSalesShipmentHeader."External Document No.";
                            end;

                        end;
                        BaseUnitofMeasure := RecItem."RV_Supp. Unit of Measure Code";
                        CALCFIELDS("RV_Charge Type");
                        if ShowFOBPrice then begin
                            if "RV_Charge Type" = "RV_Charge Type"::FOB then begin
                                FOBAmount := "RV_Other Charge";
                            end;
                            UnitPrice := ("Line Amount" + FOBAmount) / Quantity;
                            LineAmount := "Line Amount" + FOBAmount;
                        end else begin
                            UnitPrice := "Unit Price";
                            LineAmount := Amount;
                        end;

                        RecItemReference.Reset();
                        RecItemReference.SetRange("Item No.", "No.");
                        RecItemReference.SetRange("Reference Type No.", SalesInvoiceHeader."Sell-to Customer No.");
                        if RecItemReference.FindFirst() then begin
                            Description := RecItemReference.Description;
                            Description2 := RecItemReference."Description 2";
                        end else begin
                            Description := SalesInvoiceLine.Description;
                            Description2 := SalesInvoiceLine."Description 2";
                        end;
                    end;

                }
                column(TotalFreightCharges; TotalFreightCharges)
                {
                }
                column(Ship_to_Name; "Ship-to Name")
                {
                }
                column(ShowFOBPrice; ShowFOBPrice)
                {
                }
                column(ShowExchangeRates; ShowExchangeRates)
                {
                }
                column(QRCode; QRCode)
                {
                }
                column(QRCodeText; QRCodeText)
                {
                }
                column(CurrencyInformation; CurrencyInformation)
                {
                }
                column(WorkDescription; ShowWorkDescription)
                {
                }
                column(SalesComment; SalesComment)
                {
                }
                trigger OnAfterGetRecord()
                var
                    ISODoc: Record "RV ISO Document";
                    PaymentTerms: Record "Payment Terms";
                    SalesShipmentLine: Record "Sales Shipment Line";
                    RecItemLedgerEntry: Record "Item Ledger Entry";
                    TempNo: Integer;
                    RecItem: Record Item;
                    RecSalesShipmentHeader: Record "Sales Shipment Header";
                    TempSalesShipmentHeader: Record "Sales Shipment Header" temporary;
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    TypeHelper: Codeunit "Type Helper";
                    SalesCommentLine: Record "Sales Comment Line";
                begin
                    chr10 := 10;
                    CompanyInfo.Get();
                    CompanyInfo.CalcFields(Picture);
                    CerfiticateNo := '';
                    OrderNo := '';
                    TotalFreightCharges := 0;
                    TempNo := 1;
                    SalesComment := '';
                    ISODoc.Reset();
                    ISODoc.SetRange("Report Code", 'OVERSEA INVOICE');
                    if ISODoc.FindFirst() then begin
                        ISODocumentNo := ISODoc."ISO Document No.";
                        ISODocVersion := ISODoc."ISO Doc. Version No.";
                    end;

                    PaymentTerms.Reset();
                    PaymentTerms.SetRange(Code, "Payment Terms Code");
                    if PaymentTerms.FindFirst() then begin
                        Terms := PaymentTerms.Description;
                    end;

                    SalesInvoiceLine.Reset();
                    SalesInvoiceLine.SetRange("Document No.", "No.");
                    SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
                    if SalesInvoiceLine.FindSet() then begin
                        repeat
                            RecItem.Get(SalesInvoiceLine."No.");
                            if RecItem."RV_Print RSPO No." then begin
                                CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                            end;
                            if ((TempNo < 10) and (SalesInvoiceLine."Shipment No." <> '') and (RecItem.Type = RecItem.Type::Inventory)) then begin
                                RecSalesShipmentHeader.Reset();
                                RecSalesShipmentHeader.SetRange("No.", SalesInvoiceLine."Shipment No.");
                                if RecSalesShipmentHeader.FindFirst() then begin
                                    TempSalesShipmentHeader.Reset();
                                    TempSalesShipmentHeader.SetRange("Order No.", RecSalesShipmentHeader."Order No.");
                                    if not TempSalesShipmentHeader.FindFirst() then begin
                                        if TempNo mod 5 = 0 then begin
                                            OrderNo += RecSalesShipmentHeader."Order No." + '<br>';
                                        end else begin
                                            OrderNo += RecSalesShipmentHeader."Order No." + '  ';
                                        end;
                                        TempSalesShipmentHeader.Init();
                                        TempSalesShipmentHeader."No." := RecSalesShipmentHeader."No.";
                                        TempSalesShipmentHeader."Order No." := RecSalesShipmentHeader."Order No.";
                                        TempSalesShipmentHeader.Insert();
                                        TempNo := TempNo + 1;
                                    end;
                                end;
                            end;
                        until SalesInvoiceLine.Next() = 0;
                    end;

                    if "uuid TTM" <> '' then begin
                        QRCodeText := GenerateQRCode("uuid TTM");
                    end;
                    ExchangeRate := Round(1 / "Currency Factor", 0.0001);
                    CurrencyInformation := 'EX-RATE: 1 ' + "Currency Code" + ' = RM ' + Format(ExchangeRate);
                    CALCFIELDS("Work Description");
                    "Work Description".CreateInStream(WorkDescriptionInstream, TEXTENCODING::UTF8);
                    ShowWorkDescription := TypeHelper.ReadAsTextWithSeparator(WorkDescriptionInstream, TypeHelper.LFSeparator());

                    SalesCommentLine.Reset();
                    SalesCommentLine.SetRange("No.", "No.");
                    SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Invoice);
                    SalesCommentLine.SetCurrentKey("Line No.");
                    if SalesCommentLine.FindSet() then begin
                        repeat
                            SalesComment += SalesCommentLine.Comment + Format(chr10);
                        until SalesCommentLine.Next() = 0;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    Clear(WorkDescriptionInstream);
                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 2);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowFOBPrice; ShowFOBPrice)
                    {
                        Caption = 'Show FOB Price';
                        ApplicationArea = All;
                    }
                    field(ShowExchangeRates; ShowExchangeRates)
                    {
                        Caption = 'Show Exchange Rates';
                        ApplicationArea = All;
                    }
                    field(QRCode; QRCode)
                    {
                        Caption = 'Show UUID as QR Code';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        ReportTitle: Label 'PROFORMA INVOICE';
        ISODocumentNo: Text;
        ISODocVersion: Text;
        Description: Text;
        Description2: Text;
        BaseUnitofMeasure: Text;
        CerfiticateNo: Text;
        Tranfportation: Text;
        OrderNo: Text;
        ShowFOBPrice: Boolean;
        ShowExchangeRates: Boolean;
        QRCode: Boolean;
        QRCodeText: Text;
        FOBAmount: Decimal;
        UnitPrice: Decimal;
        LineAmount: Decimal;
        Terms: Text;
        TotalFreightCharges: Decimal;
        SalesOrderNo: Text;
        CustomerPO: Text;
        CurrencyInformation: Text;
        ExchangeRate: Decimal;
        ShowWorkDescription: Text;
        WorkDescriptionInstream: InStream;
        SalesComment: Text;
        chr10: Char;
        SalesListComment: Text;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        RIKEVITASetup.Get();
    end;

    procedure GenerateQRCode(Value: Text): Text
    var
        barcodeSymbology: enum "Barcode Symbology 2D";
        barcodeFontProvider: Interface "Barcode Font Provider 2D";
        barcodeStr: Text;
    begin
        if (Value <> '') then begin
            barcodeFontProvider := enum::"Barcode Font Provider 2D"::IDAutomation2D;
            barcodeSymbology := Enum::"Barcode Symbology 2D"::"QR-Code";
            barcodeStr := barcodeFontProvider.EncodeFont(Value, barcodeSymbology);
            exit(barcodeStr);
        end;
    end;
}
