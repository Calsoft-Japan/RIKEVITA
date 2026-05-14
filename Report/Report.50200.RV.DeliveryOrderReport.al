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
            /*
                        dataitem(Lines; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(CustomerOrderNo; Header."External Document No.")
                            {

                            }
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
                            column(Quantity; QuantityValue)
                            {
                            }
                            trigger OnPreDataItem()
                            begin
                                SetRange(Number, 1, Templine.Count);
                            end;

                            trigger OnAfterGetRecord()
                            var
                                RecItem: Record Item;
                            begin

                                if Number = 1 then begin
                                    Templine.FindFirst();
                                end else begin
                                    Templine.Next();
                                end;

                                if RecItem.Get(Templine."Item No.") then begin
                                    Description := RecItem.Description;
                                    Description2 := RecItem."Description 2";
                                end;
                                ItemBUOM := RecItem."Base Unit of Measure";
                                PackageInfo := StrSubstNo('(%1 %2 X %3 %4 = %5 %6)',
                                    Templine."Quantity (Base)" / Templine."Qty. per Unit of Measure", Templine."Location Code", Templine."Qty. per Unit of Measure", ItemBUOM, Templine."Quantity (Base)", ItemBUOM);

                            end;
                        }
            */
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
                column(Quantity; Format(Abs(QuantityKGValue)) + 'KG')
                {
                }
                trigger OnAfterGetRecord()
                var
                    RecItemLedgerEntry: Record "Item Ledger Entry";
                    RecItem: Record Item;
                    ItemUOM: Record "Item Unit of Measure";
                begin
                    LotNo := '';
                    QuantityValue := 0;
                    QuantityKGValue := 0;
                    if RecItem.Get(SalesShipmentLine."No.") then begin
                        if RecItem."RV_Print RSPO No." then begin
                            CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                        end;
                    end;
                    if RecItem.Get(Templine."Item No.") then begin
                        Description := RecItem.Description;
                        Description2 := RecItem."Description 2";
                    end;
                    ItemBUOM := RecItem."Base Unit of Measure";

                    RecItemLedgerEntry.Reset();
                    RecItemLedgerEntry.SetRange("Document No.", "Document No.");
                    RecItemLedgerEntry.SetRange("Entry Type", RecItemLedgerEntry."Entry Type"::Sale);
                    RecItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
                    RecItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                    if RecItemLedgerEntry.FindSet() then begin
                        repeat
                            QuantityValue += RecItemLedgerEntry.Quantity;
                            if ItemUOM.Get(SalesShipmentLine."No.", 'KG') then begin
                                QuantityKGValue += RecItemLedgerEntry.Quantity / ItemUOM."Qty. per Unit of Measure";
                            end;
                        until RecItemLedgerEntry.Next() = 0;
                    end;

                    RecItemLedgerEntry.Reset();
                    RecItemLedgerEntry.SetRange("Document No.", "Document No.");
                    RecItemLedgerEntry.SetRange("Entry Type", RecItemLedgerEntry."Entry Type"::Sale);
                    RecItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
                    RecItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                    if RecItemLedgerEntry.FindSet() then begin
                        repeat
                            LotNo += RecItemLedgerEntry."Lot No." + ' - ' + Format(Abs(QuantityValue) * RecItemLedgerEntry."Qty. per Unit of Measure") + ItemBUOM + '<br>';
                        until RecItemLedgerEntry.Next() = 0;
                    end;
                    QtyperUnitofMeasure := 0;
                    if RecItemLedgerEntry."Qty. per Unit of Measure" <> 0 then begin
                        QtyperUnitofMeasure := Round(1 / RecItemLedgerEntry."Qty. per Unit of Measure", 1, '=');
                    end;
                    AValue := 0;
                    if QtyperUnitofMeasure <> 0 then
                        AValue := Abs(QuantityKGValue) / QtyperUnitofMeasure;
                    PackageInfo := StrSubstNo('(%1 %2 X %3 %4 = %5 %6)',
                                            AValue, ItemBUOM, QtyperUnitofMeasure, RecItemLedgerEntry."Unit of Measure Code", Abs(QuantityKGValue), RecItemLedgerEntry."Unit of Measure Code");
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
                /*
                                Templine.Reset();
                                Templine.DeleteAll();
                                TempNo := 1;
                                SalesShipmentLine.Reset();
                                SalesShipmentLine.SetRange("Document No.", "No.");
                                SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
                                if SalesShipmentLine.FindSet() then begin
                                    repeat
                                        if RecItem.Get(SalesShipmentLine."No.") then begin
                                            if RecItem."RV_Print RSPO No." then begin
                                                CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                                            end;
                                        end;

                                        RecItemLedgerEntry.Reset();
                                        RecItemLedgerEntry.SetRange("Document No.", "No.");
                                        RecItemLedgerEntry.SetRange("Entry Type", RecItemLedgerEntry."Entry Type"::Sale);
                                        RecItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
                                        RecItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                                        if RecItemLedgerEntry.FindSet() then begin
                                            repeat
                                                Templine.Reset();
                                                Templine.SetRange("Item No.", RecItemLedgerEntry."Item No.");
                                                Templine.SetRange("Lot No.", RecItemLedgerEntry."Lot No.");
                                                Templine.SetRange("Location Code", RecItemLedgerEntry."Unit of Measure Code");
                                                if Templine.FindFirst() then begin
                                                    Templine."Quantity (Base)" += RecItemLedgerEntry.Quantity;
                                                    Templine.Modify();
                                                end else begin
                                                    RecItem.Get(RecItemLedgerEntry."Item No.");
                                                    Templine.Init();
                                                    Templine."Entry No." := TempNo;
                                                    Templine."Item No." := RecItemLedgerEntry."Item No.";
                                                    Templine."Quantity (Base)" := RecItemLedgerEntry.Quantity;
                                                    Templine."Lot No." := RecItemLedgerEntry."Lot No.";
                                                    Templine."Location Code" := RecItemLedgerEntry."Unit of Measure Code";
                                                    Templine."Qty. per Unit of Measure" := RecItemLedgerEntry."Qty. per Unit of Measure";
                                                    Templine.Insert();
                                                    TempNo := TempNo + 1;
                                                end;
                                            until RecItemLedgerEntry.Next() = 0;
                                            Templine.Reset();
                                            Templine.SetRange("Item No.", RecItemLedgerEntry."Item No.");
                                            Templine.SetRange("Lot No.", RecItemLedgerEntry."Lot No.");
                                            Templine.SetRange("Location Code", RecItemLedgerEntry."Unit of Measure Code");
                                            if Templine.FindSet() then begin
                                                repeat
                                                    if RecItem.Get(Templine."Item No.") then begin
                                                        ItemBUOM := RecItem."Base Unit of Measure";
                                                    end;
                                                    //QuantityValue += ;
                                                    LotNo += Templine."Lot No." + '-' + Format(Abs(Templine."Quantity (Base)")) + ItemBUOM + '<br>';

                                                until Templine.Next() = 0;
                                            end;
                                        end;
                                    until SalesShipmentLine.Next() = 0;
                                    Templine.Reset();
                                end;
                */
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
        Item: Record Item;
        ISODocumentNo: Text;
        ISODocVersion: Text;
        Terms: Text;
        Description: Text;
        Description2: Text;
        LotNo: Text;
        QuantityValue: Decimal;
        QuantityKGValue: Decimal;
        QtyperUnitofMeasure: Decimal;
        AValue: Decimal;
        Templine: Record "Tracking Specification" temporary;
        PackageInfo: Text;
        ItemBUOM: Text;
        CerfiticateNo: Text;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;
}
