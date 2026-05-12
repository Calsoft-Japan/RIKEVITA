/// <summary>
/// Report RV Packing List (ID 50201)
/// FDD020 2026/04/29: New. (Bobby.ji)
/// </summary>
report 50201 "RV Pre Packing List Report"
{
    Caption = 'Pre Packing List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = false;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/RV_PerPackingList.rdlc';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            column(Number; Number)
            {
            }

            dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
            {
                RequestFilterFields = "No.";
                column(CompanyLogo;
                CompanyInfo.Picture)
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
                column(InvoiceNo; InvoiceNo)
                {
                }
                column(PackingListNo; PackingListNo)
                {
                }
                column(ConsigneeName; "RV_Consignee Name")
                {
                }
                column(ConsigneeAddress; "RV_Consignee Address")
                {
                }
                column(ConsigneeAddress2; "RV_Consignee Address 2")
                {
                }
                column(ConsigneePostCode; "RV_Consignee Post Code" + ' ' + "RV_Consignee City")
                {
                }
                column(ConsigneeCountryRegion; "RV_Consignee Country/Region")
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
                column(FromValue; FromValue)
                {
                }
                column(ToValue; ToValue)
                {
                }
                column(SailingOnOrAbout; SailingOnOrAbout)
                {
                }
                column(Shipment_Method_Code; "Shipment Method Code")
                {
                }
                dataitem(WarehousePackingInfo; "RV Warehouse Packing Info.")
                {
                    DataItemLink = "Warehouse Shipment No." = field("No.");
                    column(MARKS; MARKS)
                    {
                    }
                    column(Case_No; "Case No.")
                    {
                    }
                    column(Item_No; "Item No.")
                    {
                    }
                    column(Sales_Order_No; "Sales Order No.")
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    column(Description2; Description2)
                    {
                    }
                    column(Package_Info; PackageInfo)
                    {
                    }
                    column(No_of_Packages; "No. of Packages")
                    {
                    }
                    column(No_of_Packages2; BaseUnitofMeasure)
                    {
                    }
                    column(Contents_Per_Package; "Contents Per Package")
                    {
                    }
                    column(Contents_UOM; "Contents UOM")
                    {
                    }
                    column(Net_Weight; "Net Weight")
                    {
                    }
                    column(Gross_Weight; "Gross Weight")
                    {
                    }
                    column(Gross_Weight_UOM; "Gross Weight UOM")
                    {
                    }
                    column(Measurement; Measurement)
                    {
                    }
                    column(Measurement_UOM; "Measurement UOM")
                    {
                    }
                    column(Symbol_Display_Packing_List; ItemSymbolSetting."Symbol Display Packing List")
                    {
                    }
                    column(Symbol_Picture; ItemSymbolSetting."Item Symbol Image")
                    {
                    }

                    column(External_Document_No; ExternalDocumentNo) { }
                    column(Entry_No; EntryNo) { }
                    column(LotNo1; LotNo1) { }
                    column(LotNo2; LotNo2) { }

                    trigger OnAfterGetRecord()
                    var
                        RecItem: Record Item;
                        RecSalesHeader: Record "Sales Header";
                        RecSalesShipmentHeader: Record "Sales Shipment Header";
                        RecReservationEntry: Record "Reservation Entry";
                        chr10: Char;
                        TempNo: Integer;
                        oldContainerNo: Text;
                    begin
                        chr10 := 10;
                        LotNoNumber := 0;
                        Templine.Reset();
                        Templine.DeleteAll();
                        TempNo := 1;
                        LotNo1 := '';
                        LotNo2 := '';
                        if RecItem.Get("Item No.") then begin
                            Description := RecItem.Description;
                            Description2 := RecItem."Description 2";
                            BaseUnitofMeasure := RecItem."Base Unit of Measure";
                            PackageInfo := StrSubstNo('(%1 %2 X %3 %4)',
                            "Net Weight", "Contents UOM", "No. of Packages", BaseUnitofMeasure);
                        end;

                        ItemSymbolSetting.Reset();
                        ItemSymbolSetting.SetRange("Item Code", "Item No.");
                        if ItemSymbolSetting.FindFirst() then begin
                        end;

                        RecSalesHeader.Reset();
                        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                        RecSalesHeader.SetRange("No.", "Sales Order No.");
                        if RecSalesHeader.FindFirst() then begin
                            if RecSalesHeader."External Document No." <> '' then begin
                                ExternalDocumentNo := 'CUSTOMER PO NO: ' + RecSalesHeader."External Document No.";
                            end;
                        end;

                        RecSalesHeader.Reset();
                        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                        RecSalesHeader.SetRange("No.", "Sales Order No.");
                        if RecSalesHeader.FindFirst() then begin
                            MARKS := RecSalesHeader."Sell-to Customer Name" + Format(chr10) + RecSalesHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                        end else begin
                            RecSalesShipmentHeader.Reset();
                            RecSalesShipmentHeader.SetRange("Order No.", "Sales Order No.");
                            if RecSalesShipmentHeader.FindFirst() then begin
                                MARKS := RecSalesShipmentHeader."Sell-to Customer Name" + Format(chr10) + RecSalesShipmentHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                            end;
                        end;

                        RecReservationEntry.Reset();
                        //RecReservationEntry.SetRange("Reservation Status", RecReservationEntry."Reservation Status"::Tracking);
                        RecReservationEntry.SetFilter("Lot No.", '<>%1', '');
                        RecReservationEntry.SetRange("Source ID", "Sales Order No.");
                        RecReservationEntry.SetRange("Source Type", 37);
                        if RecReservationEntry.FindSet() then begin
                            repeat
                                Templine.Init();
                                Templine."Entry No." := TempNo;
                                Templine."RV_Container No." := RecReservationEntry."RV_Container No.";
                                Templine.Description := Description2;
                                Templine."Lot No." := RecReservationEntry."Lot No.";
                                Templine."Quantity (Base)" := RecReservationEntry."Qty. to Invoice (Base)";
                                Templine."Location Code" := RecItem."Base Unit of Measure";
                                Templine.Insert();
                                TempNo := TempNo + 1;
                            until RecReservationEntry.Next() = 0;
                            Templine.Reset();
                            Templine.SetCurrentKey("RV_Container No.");
                            if Templine.FindSet() then begin
                                repeat
                                    EntryNo := Templine."Entry No.";
                                    if (Templine."RV_Container No." = '') and (LotNoNumber = 1) then begin
                                        LotNo1 += '<b>' + Templine."RV_Container No." + '</b><br>LOT NO. :<br>';
                                    end;
                                    if oldContainerNo <> Templine."RV_Container No." then begin
                                        LotNoNumber := 1;
                                        LotNo1 += '<b>' + Templine."RV_Container No." + '</b><br>LOT NO. :<br>' + Templine.Description + '<br>' + Templine."Lot No." + ' - ' + Format(abs(Templine."Qty. to Invoice (Base)")) + ' ' + Templine."Location Code" + '<br>';
                                        LotNo2 += '<br><br>';
                                        oldContainerNo := Templine."RV_Container No.";
                                    end else begin
                                        LotNoNumber := LotNoNumber + 1;
                                        if LotNoNumber mod 2 = 0 then begin
                                            LotNo1 += Templine.Description + '<br>' + Templine."Lot No." + ' - ' + Format(abs(Templine."Qty. to Invoice (Base)")) + ' ' + Templine."Location Code" + '<br>';
                                        end else
                                            LotNo2 += Templine.Description + '<br>' + Templine."Lot No." + ' - ' + Format(abs(Templine."Qty. to Invoice (Base)")) + ' ' + Templine."Location Code" + '<br>';
                                    end;
                                until Templine.Next() = 0;
                            end;

                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    ISODoc: Record "RV ISO Document";
                    WarehouseShipmentLine: Record "Warehouse Shipment Line";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    ISODoc.Reset();
                    ISODoc.SetRange("Report Code", 'PACKING LIST');
                    if ISODoc.FindFirst() then begin
                        ISODocumentNo := ISODoc."ISO Document No.";
                        ISODocVersion := ISODoc."ISO Doc. Version No.";
                    end;
                    WarehouseShipmentLine.Reset();
                    WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
                    if WarehouseShipmentLine.FindFirst() then begin
                        SalesInvoiceHeader.Reset();
                        SalesInvoiceHeader.SetRange("Order No.", WarehouseShipmentLine."Source No.");
                        if SalesInvoiceHeader.FindFirst() then begin

                            FromValue := SalesInvoiceHeader."RV_Country of Origin";
                            ToValue := SalesInvoiceHeader."Ship-to Name";
                            SailingOnOrAbout := Format(SalesInvoiceHeader."RV_SAILING ON OR ABOUT");
                        end;
                    end;

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

                }
            }
        }
    }
    var
        ItemSymbolSetting: Record "RV Item Symbol Setting";
        CompanyInfo: Record "Company Information";
        IsPrePacking: Boolean;
        ReportTitle: Label 'PRE PACKING LIST';
        ISODocumentNo: Text;
        ISODocVersion: Text;
        InvoiceNo: Text;
        PackingListNo: Text;
        FromValue: Text;
        ToValue: Text;
        SailingOnOrAbout: Text;
        Description: Text;
        Description2: Text;
        PackageInfo: Text;
        BaseUnitofMeasure: Text;
        ShipmentMethodCode: Text;
        ExternalDocumentNo: Text;
        MARKS: Text;
        LotNo1: Text;
        LotNo2: Text;
        LotNoNumber: Integer;
        Templine: Record "Tracking Specification" temporary;
        EntryNo: Integer;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
