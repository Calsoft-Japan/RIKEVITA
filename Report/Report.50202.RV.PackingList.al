/// <summary>
/// Report RV Packing List (ID 50202)
/// FDD020 2026/04/29: New. (Bobby.ji)
/// </summary>
report 50202 "RV Packing List Report"
{
    Caption = 'Packing List';
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

            dataitem(PostedWhseShipmentHeader; "Posted Whse. Shipment Header")
            {
                RequestFilterFields = "No.";
                column(CompanyLogo;
                CompanyInfo.Picture)
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
                column(OrderNo; OrderNo)
                {
                }
                column(PackingListNo; "No.")
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
                column(FromValue; "RV_Country of Origin")
                {
                }
                column(ToValue; "RV_Ship-to Name")
                {
                }
                column(SailingOnOrAbout; "RV_SAILING ON OR ABOUT")
                {
                }

                column(Shipment_Method_Code; "Shipment Method Code")
                {
                }
                dataitem(WarehousePackingInfo; "RV Warehouse Packing Info.")
                {
                    DataItemTableView = where("Posted Whse. Shipment No." = filter(<> ''));
                    DataItemLink = "Posted Whse. Shipment No." = field("No.");
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
                        RecPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
                        RecItemLedgerEntry: Record "Item Ledger Entry";
                        RecWarehousePackingInfo: Record "RV Warehouse Packing Info.";
                        chr10: Char;
                        TempNo: Integer;
                        oldContainerNo: Text;
                        TempOrderNo: Integer;
                    begin
                        chr10 := 10;
                        LotNoNumber := 0;
                        Templine.Reset();
                        Templine.DeleteAll();
                        TempNo := 1;
                        TempOrderNo := 1;
                        LotNo1 := '';
                        LotNo2 := '';
                        CerfiticateNo := '';
                        ExternalDocumentNo := 'CUSTOMER PO NO: ';
                        if RecItem.Get("Item No.") then begin
                            Description := RecItem.Description;
                            Description2 := RecItem."Description 2";
                            BaseUnitofMeasure := RecItem."Base Unit of Measure";
                            PackageInfo := StrSubstNo('(%1 %2 X %3 %4)',
                            "Contents Per Package", "Contents UOM", "No. of Packages", BaseUnitofMeasure);
                        end;

                        ItemSymbolSetting.Reset();
                        ItemSymbolSetting.SetRange("Item Code", "Item No.");
                        if ItemSymbolSetting.FindFirst() then begin
                        end;

                        RecPostedWhseShipmentLine.Reset();
                        RecPostedWhseShipmentLine.SetRange("No.", PostedWhseShipmentHeader."No.");
                        if RecPostedWhseShipmentLine.FindSet() then begin
                            repeat
                                if RecItem.Get(RecPostedWhseShipmentLine."Item No.") then begin
                                    if RecItem."RV_Print RSPO No." then begin
                                        CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                                    end;
                                end;
                            until RecPostedWhseShipmentLine.Next() = 0;
                        end;
                        RecSalesHeader.Reset();
                        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                        RecSalesHeader.SetRange("No.", "Sales Order No.");
                        if RecSalesHeader.FindFirst() then begin
                            if RecSalesHeader."External Document No." <> '' then begin
                                ExternalDocumentNo := 'CUSTOMER PO NO: ' + RecSalesHeader."External Document No.";
                            end;

                            MARKS := RecSalesHeader."Sell-to Customer Name" + Format(chr10) + RecSalesHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                        end else begin
                            RecSalesShipmentHeader.Reset();
                            RecSalesShipmentHeader.SetRange("Order No.", "Sales Order No.");
                            if RecSalesShipmentHeader.FindFirst() then begin
                                MARKS := RecSalesShipmentHeader."Sell-to Customer Name" + Format(chr10) + RecSalesShipmentHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                            end;
                        end;

                        RecWarehousePackingInfo.Reset();
                        RecWarehousePackingInfo.SetRange("Posted Whse. Shipment No.", "Posted Whse. Shipment No.");
                        RecWarehousePackingInfo.SetRange("Sales Order No.", "Sales Order No.");
                        RecWarehousePackingInfo.SetCurrentKey("Container No");
                        if RecWarehousePackingInfo.FindSet() then begin
                            repeat
                                RecItem.Get(RecWarehousePackingInfo."Item No.");
                                if (RecWarehousePackingInfo."Container No" = '') and (LotNoNumber = 0) then begin
                                    LotNo1 += '<b>' + RecWarehousePackingInfo."Container No" + '</b><br>LOT NO. :<br>';
                                    LotNo2 += '<br><br>';
                                end;
                                if oldContainerNo <> RecWarehousePackingInfo."Container No" then begin
                                    if LotNoNumber mod 2 = 1 then begin
                                        LotNo2 += '<br><br><br>';
                                    end;
                                    LotNoNumber := 1;
                                    LotNo1 += '<b>' + RecWarehousePackingInfo."Container No" + '</b><br>LOT NO. :<br>' + RecItem.Description + '<br>' + RecWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(RecWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    LotNo2 += '<br><br>';
                                    oldContainerNo := RecWarehousePackingInfo."Container No";
                                end else begin
                                    LotNoNumber := LotNoNumber + 1;
                                    if LotNoNumber mod 2 = 0 then begin
                                        LotNo2 += RecItem.Description + '<br>' + RecWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(RecWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    end else begin
                                        LotNo1 += RecItem.Description + '<br>' + RecWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(RecWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    end;

                                end;
                            until RecWarehousePackingInfo.Next() = 0;
                        end;

                    end;
                }

                trigger OnAfterGetRecord()
                var
                    ISODoc: Record "RV ISO Document";
                    WarehousePackingInfo: Record "RV Warehouse Packing Info.";
                    TempWarehousePackingInfo: Record "RV Warehouse Packing Info." temporary;
                    TempOrderNo: Integer;
                begin
                    OrderNo := '';
                    TempOrderNo := 1;

                    ISODoc.Reset();
                    ISODoc.SetRange("Report Code", 'PACKING LIST');
                    if ISODoc.FindFirst() then begin
                        ISODocumentNo := ISODoc."ISO Document No.";
                        ISODocVersion := ISODoc."ISO Doc. Version No.";
                    end;
                    WarehousePackingInfo.Reset();
                    WarehousePackingInfo.SetRange("Posted Whse. Shipment No.", "No.");
                    if WarehousePackingInfo.FindSet() then begin
                        repeat
                            if ((TempOrderNo < 10) and (WarehousePackingInfo."Sales Order No." <> '')) then begin
                                TempWarehousePackingInfo.Reset();
                                TempWarehousePackingInfo.SetRange("Sales Order No.", WarehousePackingInfo."Sales Order No.");
                                if not TempWarehousePackingInfo.FindFirst() then begin
                                    if TempOrderNo mod 5 = 0 then begin
                                        OrderNo += WarehousePackingInfo."Sales Order No." + '<br>';
                                    end else begin
                                        OrderNo += WarehousePackingInfo."Sales Order No." + '  ';
                                    end;
                                    TempWarehousePackingInfo.Init();
                                    TempWarehousePackingInfo."Sales Order No." := WarehousePackingInfo."Sales Order No.";
                                    TempWarehousePackingInfo."SO Line No." := WarehousePackingInfo."SO Line No.";
                                    TempWarehousePackingInfo."Lot No." := WarehousePackingInfo."Lot No.";
                                    TempWarehousePackingInfo."Line No." := WarehousePackingInfo."Line No.";
                                    TempWarehousePackingInfo.Insert();
                                    TempOrderNo := TempOrderNo + 1;
                                end;
                            end;

                        until WarehousePackingInfo.Next() = 0;
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
        ReportTitle: Label 'PACKING LIST';
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
        CerfiticateNo: Text;
        OrderNo: Text;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
