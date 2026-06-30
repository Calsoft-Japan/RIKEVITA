/// <summary>
/// Report RV Posted Sales Invoice(Local) (ID 50204)
/// FDD021 2026/05/20: New. (Bobby.ji)
/// </summary>
report 50204 "RV Posted Sales Invoice(Local)"
{
    Caption = 'Sales Invoice(Local)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = false;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_SalesInvoice(Local).rdlc';

    dataset
    {
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
            column(RegistrationNo; 'Registration No. ' + CompanyInfo."Registration No.")
            {
            }
            column(SSTRegNo; 'SST Reg No. ' + CompanyInfo."RV_SST Reg No.")
            {
            }
            column(CerfiticateNo; CerfiticateNo)
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(ISODocumentNo; ISODocumentNo)
            {
            }
            column(ISODocVersion; ISODocVersion)
            {
            }
            column(PrintDate; Format(Today(), 0, '<Day,2>-<Month text,3>-<Year,2>'))
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
            column(Sell_to_Post_Code; "Sell-to Post Code" + ' ' + "Sell-to City")
            {
            }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            {
            }
            column(Tranfportation; Tranfportation)
            {
            }
            column(OrderNo; OrderNo)
            {
            }
            column(FromValue; "RV_Country of Origin")
            {
            }
            column(SailingOnOrAbout; Format("RV_SAILING ON OR ABOUT", 0, '<Day,2>-<Month text,3>-<Year,2>'))
            {
            }
            column(Terms; "Payment Terms Code")
            {
            }
            column(QRCode; QRCode)
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
                column(Unit_Price; "Unit Price")
                {
                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(Total_VAT_Base_Amount; "VAT Base Amount" * "VAT %")
                {
                }
                trigger OnAfterGetRecord()
                var
                    RecItem: Record Item;
                begin
                    RecItem.Get("No.");
                    Description := RecItem.Description;
                    Description2 := RecItem."Description 2";
                    BaseUnitofMeasure := RecItem."Base Unit of Measure";
                end;

            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address2; "Ship-to Address 2")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code" + ' ' + "Ship-to City")
            {
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
            }
            column(RIKEVITASetup1; 'Name: ' + CompanyInfo."Name" + '. ID No. ' + RIKEVITASetup."ID No.")
            {
            }
            column(RIKEVITASetup2; 'Bank: ' + RIKEVITASetup."MYR Bank Name" + '. A/C No: ' + RIKEVITASetup."MYR Bank Account No." + '(MYR)')
            {
            }
            column(RIKEVITASetup3; 'Bank: ' + RIKEVITASetup."USD Bank Name" + '. A/C No: ' + RIKEVITASetup."USD Bank Account No." + '(USD)')
            {
            }
            column(QRCodeText; QRCodeText) { }
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
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
                CerfiticateNo := '';

                ISODoc.Reset();
                ISODoc.SetRange("Report Code", 'LOCAL INVOICE');
                if ISODoc.FindFirst() then begin
                    ISODocumentNo := ISODoc."ISO Document No.";
                    ISODocVersion := ISODoc."ISO Doc. Version No.";
                end;

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                if SalesLine.FindSet() then begin
                    repeat
                        RecItem.Get(SalesLine."No.");
                        if RecItem."RV_Print RSPO No." then begin
                            CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                        end;
                    until SalesLine.Next() = 0;
                end;

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("Shipment No.", '<>%1', '');
                if SalesLine.FindFirst() then begin
                    RecSalesShipmentHeader.Reset();
                    RecSalesShipmentHeader.SetRange("No.", SalesLine."Shipment No.");
                    if RecSalesShipmentHeader.FindFirst() then begin
                        Tranfportation := RecSalesShipmentHeader."Shipment Method Code";
                        OrderNo := RecSalesShipmentHeader."Order No.";
                    end;
                end;

                if "uuid TTM" <> '' then begin
                    QRCodeText := GenerateQRCode("uuid TTM");
                end;
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
        ReportTitle: Label 'Pro Forma Invoice';
        ISODocumentNo: Text;
        ISODocVersion: Text;
        Description: Text;
        Description2: Text;
        BaseUnitofMeasure: Text;
        CerfiticateNo: Text;
        Tranfportation: Text;
        OrderNo: Text;
        QRCode: Boolean;
        QRCodeText: Text;

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
