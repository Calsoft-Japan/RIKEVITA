/// <summary>
/// Report RV Sales Invoice(Oversea) (ID 50205)
/// FDD018 2026/05/21: New. (Bobby.ji)
/// </summary>
report 50205 "RV Sales Invoice(Oversea)"
{
    Caption = 'Sales Invoice(Oversea)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = false;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_SalesInvoice(Oversea).rdlc';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Document Type", "No.", "Bill-to Customer No.", "Sell-to Customer No.", "No. Printed";
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(RegistrationNo; 'Registration No. ' + CompanyInfo."Registration No.")
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
            column(PrintDate; Format(Today(), 0, '<Day,2>/<Month,2>/<Year,4>'))
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
            column(SailingOnOrAbout; Format("RV_SAILING ON OR ABOUT", 0, '<Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(Terms; Terms)
            {
            }
            dataitem(SalesLine; "Sales Line")
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
                trigger OnAfterGetRecord()
                var
                    RecItem: Record Item;
                    RecSalesShipmentHeader: Record "Sales Shipment Header";
                    RecItemReference: Record "Item Reference";
                begin
                    SalesOrderNo := '';
                    CustomerPO := '';
                    FOBAmount := 0;
                    RecItem.Get("No.");
                    if RecItem.Type = RecItem.Type::Inventory then begin
                        RecSalesShipmentHeader.Reset();
                        RecSalesShipmentHeader.SetRange("No.", "Shipment No.");
                        if RecSalesShipmentHeader.FindFirst() then begin
                            SalesOrderNo := RecSalesShipmentHeader."Order No.";
                            CustomerPO := RecSalesShipmentHeader."External Document No.";
                        end;

                    end;
                    BaseUnitofMeasure := RecItem."Base Unit of Measure";
                    CALCFIELDS("RV_Charge Type");
                    if ShowFOBPrice then begin
                        if "RV_Charge Type" = "RV_Charge Type"::FOB then begin
                            FOBAmount := "RV_Other Charge";
                        end;
                        UnitPrice := "Line Amount" + FOBAmount;
                        LineAmount := ("Line Amount" + FOBAmount) / Quantity;
                    end else begin
                        UnitPrice := "Unit Price";
                        LineAmount := Amount;
                    end;

                    if "No." = RIKEVITASetup."Freight Charge Item No" then begin
                        TotalFreightCharges := TotalFreightCharges + "Line Amount";
                    end;
                    RecItemReference.Reset();
                    RecItemReference.SetRange("Item No.", "No.");
                    RecItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                    if RecItemReference.FindFirst() then begin
                        Description := RecItemReference.Description;
                        Description2 := RecItemReference."Description 2";
                    end else begin
                        Description := SalesLine.Description;
                        Description2 := SalesLine."Description 2";
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
            trigger OnAfterGetRecord()
            var
                ISODoc: Record "RV ISO Document";
                PaymentTerms: Record "Payment Terms";
                SalesShipmentLine: Record "Sales Shipment Line";
                RecItemLedgerEntry: Record "Item Ledger Entry";
                TempNo: Integer;
                RecItem: Record Item;
                RecSalesShipmentHeader: Record "Sales Shipment Header";
                SalesLine: Record "Sales Line";
                TypeHelper: Codeunit "Type Helper";
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
                CerfiticateNo := '';
                TempNo := 1;
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

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("Shipment No.", '<>%1', '');
                if SalesLine.FindSet() then begin
                    repeat
                        RecSalesShipmentHeader.Reset();
                        RecSalesShipmentHeader.SetRange("No.", SalesLine."Shipment No.");
                        if RecSalesShipmentHeader.FindFirst() then begin
                            if TempNo mod 5 = 0 then begin
                                OrderNo += RecSalesShipmentHeader."Order No." + '<br>';
                            end else begin
                                OrderNo += RecSalesShipmentHeader."Order No." + '  ';
                            end;
                            TempNo := TempNo + 1;
                            if TempNo > 10 then
                                break;
                        end;
                    until SalesLine.Next() = 0;
                end;

                if "uuid TTM" <> '' then begin
                    QRCodeText := GenerateQRCode("uuid TTM");
                end;
                ExchangeRate := Round(1 / "Currency Factor", 0.0001);
                CurrencyInformation := 'EX-RATE: 1 ' + "Currency Code" + ' = RM ' + Format(ExchangeRate);
                CALCFIELDS("Work Description");
                "Work Description".CreateInStream(WorkDescriptionInstream, TEXTENCODING::UTF8);
                ShowWorkDescription := TypeHelper.ReadAsTextWithSeparator(WorkDescriptionInstream, TypeHelper.LFSeparator());


            end;

            trigger OnPostDataItem()
            begin
                Clear(WorkDescriptionInstream);
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
                }
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        PaymentTerms: Record "Payment Terms";
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
