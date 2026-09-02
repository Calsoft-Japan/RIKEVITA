/// <summary>
/// Report RV Delivery Order (ID 50200)
/// FDD020 2026/04/09: New. (Bobby.ji)
/// </summary>
report 50200 "RV Delivery Order Report"
{
    Caption = 'Delivery Order Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = false;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_DeliveryOrderReport.rdlc';

    dataset
    {
        dataitem(Header; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "Sell-to Customer No.";

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
            column(PrintDate; Format(Today(), 0, '<Day,2>-<Month text,3>-<Year,2>'))
            {
            }
            column(SellToName; Header."Sell-to Customer Name")
            {
            }
            column(SellToAddress; Header."Sell-to Address")
            {
            }
            column(SellToAddress2; Header."Sell-to Address 2")
            {
            }
            column(SellToPostCode; Header."Sell-to Post Code" + ' ' + Header."Sell-to City")
            {
            }
            column(SellToCountry; Header."Sell-to Country/Region Code")
            {
            }
            column(DeliveryNo; Header."No.")
            {
            }
            column(OrderNo; Header."Order No.")
            {
            }
            column(ContactName; Header."Sell-to Contact")
            {
            }
            column(Terms; Terms)
            {
            }
            column(CustomerOrderNo; Header."External Document No.")
            {

            }
            column(ShipToName; Header."Ship-to Name")
            {
            }
            column(ShipToAddress; Header."Ship-to Address")
            {
            }
            column(ShipToAddress2; Header."Ship-to Address 2")
            {
            }
            column(ShipToPostCode; Header."Ship-to Post Code" + Header."Ship-to City")
            {
            }
            column(ShipToCountry; Header."Ship-to Country/Region Code")
            {
            }
            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Item_No; SalesShipmentLine."No.") { }
                column(LotNo; LotNo)
                {
                }
                column(Description; Description)
                {
                }
                column(Description2; Description2)
                {
                }
                column(PackageInfo; PackageInfo)
                {
                }
                column(Quantity; QuantityKGValue)
                {
                }
                trigger OnAfterGetRecord()
                var
                    RecItemLedgerEntry: Record "Item Ledger Entry";
                    RecItem: Record Item;
                    ItemUOM: Record "Item Unit of Measure";
                    QtyperUnitofMeasure: Decimal;
                begin
                    LotNo := '';
                    QuantityKGValue := '';
                    TotalQuantityKG := 0;
                    PackageInfo := '';

                    if RecItem.Get(SalesShipmentLine."No.") then begin
                        if RecItem."RV_Print RSPO No." then begin
                            CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                        end;
                        Description := RecItem.Description;
                        Description2 := RecItem."Description 2";
                    end;

                    ItemBUOM := RecItem."RV_Supp. Unit of Measure Code";

                    RecItemLedgerEntry.Reset();
                    RecItemLedgerEntry.SetRange("Document No.", "Document No.");
                    RecItemLedgerEntry.SetRange("Entry Type", RecItemLedgerEntry."Entry Type"::Sale);
                    RecItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
                    RecItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                    if RecItemLedgerEntry.FindSet() then begin
                        repeat
                            LotNo += RecItemLedgerEntry."Lot No." + ' - ' + Format(Abs(RecItemLedgerEntry.Quantity)) + ' ' + ItemBUOM + '<br>';
                            if (ItemUOM.Get(SalesShipmentLine."No.", 'KG') and (ItemUOM."Qty. per Unit of Measure" <> 0)) then begin
                                QuantityKGValue += Format(Abs(RecItemLedgerEntry.Quantity / ItemUOM."Qty. per Unit of Measure")) + ' KG <br>';
                                TotalQuantityKG += Abs(RecItemLedgerEntry.Quantity / ItemUOM."Qty. per Unit of Measure");
                            end else begin
                                QuantityKGValue += '  KG <br>';
                                TotalQuantityKG += 0;
                            end;

                        until RecItemLedgerEntry.Next() = 0;
                    end;

                    if TotalQuantityKG <> 0 then begin
                        QtyperUnitofMeasure := Round(1 / RecItemLedgerEntry."Qty. per Unit of Measure", 0.00001, '=');
                        PackageInfo := StrSubstNo('(%1 %2 X %3 %4 = %5 %6)',
                                        Round(TotalQuantityKG / QtyperUnitofMeasure, 0.01, '='), ItemBUOM, Round(QtyperUnitofMeasure, 0.01, '='), RecItemLedgerEntry."Unit of Measure Code", TotalQuantityKG, RecItemLedgerEntry."Unit of Measure Code");
                    end;

                end;
            }
            trigger OnAfterGetRecord()
            var
                ISODoc: Record "RV ISO Document";
                PaymentTerms: Record "Payment Terms";
                SalesShipmentLine: Record "Sales Shipment Line";
                RecItemLedgerEntry: Record "Item Ledger Entry";
                TempNo: Integer;
                RecItem: Record Item;
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
                CerfiticateNo := '';
                LotNo := '';
                ItemBUOM := '';

                ISODoc.Reset();
                ISODoc.SetRange("Report Code", 'DELIVERY ORDER');
                if ISODoc.FindFirst() then begin
                    ISODocumentNo := ISODoc."ISO Document No.";
                    ISODocVersion := ISODoc."ISO Doc. Version No.";
                end;

                if PaymentTerms.Get(Header."Payment Terms Code") then begin
                    Terms := PaymentTerms.Description;
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

                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        ISODocumentNo: Text;
        ISODocVersion: Text;
        Terms: Text;
        Description: Text;
        Description2: Text;
        LotNo: Text;
        TotalQuantityKG: Decimal;
        QuantityKGValue: Text;
        PackageInfo: Text;
        ItemBUOM: Text;
        CerfiticateNo: Text;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;
}
