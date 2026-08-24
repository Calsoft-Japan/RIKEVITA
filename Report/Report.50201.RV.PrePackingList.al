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
                column(ToValue; "RV_Final Destination")
                {
                }
                column(SailingOnOrAbout; Format("RV_SAILING ON OR ABOUT", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(Shipment_Method_Code; "Shipment Method Code")
                {
                }
                column(WarehouseComment; WarehouseComment)
                {
                }
                column(MARKS; MARKS)
                {
                }
                column(IsPrePacking; IsPrePacking)
                {
                }
                dataitem(WarehousePackingInfo; "RV Warehouse Packing Info.")
                {
                    DataItemTableView = where("Posted Whse. Shipment No." = filter(''));
                    DataItemLink = "Warehouse Shipment No." = field("No.");

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
                        RecWarehouseShipmentLine: Record "Warehouse Shipment Line";
                        RecWarehousePackingInfo: Record "RV Warehouse Packing Info.";
                        TempWarehousePackingInfo: Record "RV Warehouse Packing Info." temporary;
                        TempNo: Integer;
                        oldContainerNo: Text;
                        TempLotNo: Code[50];
                    begin
                        chr10 := 10;
                        LotNoNumber := 0;
                        Templine.Reset();
                        Templine.DeleteAll();
                        TempNo := 1;
                        LotNo1 := '';
                        LotNo2 := '';
                        CerfiticateNo := '';
                        oldContainerNo := '';
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

                        RecWarehouseShipmentLine.Reset();
                        RecWarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
                        if RecWarehouseShipmentLine.FindSet() then begin
                            repeat
                                if RecItem.Get(RecWarehouseShipmentLine."Item No.") then begin
                                    if RecItem."RV_Print RSPO No." then begin
                                        CerfiticateNo := 'CERFITICATE NO. ' + CompanyInfo."RV_RESO Certificate No.";
                                    end;
                                end;
                            until RecWarehouseShipmentLine.Next() = 0;
                        end;

                        RecSalesHeader.Reset();
                        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                        RecSalesHeader.SetRange("No.", "Sales Order No.");
                        if RecSalesHeader.FindFirst() then begin
                            if RecSalesHeader."External Document No." <> '' then begin
                                ExternalDocumentNo := ExternalDocumentNo + RecSalesHeader."External Document No.";
                            end;

                            //MARKS := RecSalesHeader."Sell-to Customer Name" + Format(chr10) + RecSalesHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                            /*end; else begin
                                RecSalesShipmentHeader.Reset();
                                RecSalesShipmentHeader.SetRange("Order No.", "Sales Order No.");
                                if RecSalesShipmentHeader.FindFirst() then begin
                                    MARKS := RecSalesShipmentHeader."Sell-to Customer Name" + Format(chr10) + RecSalesShipmentHeader."Sell-to City" + Format(chr10) + "Sales Order No.";
                                end;*/
                        end;
                        RecWarehousePackingInfo.Reset();
                        RecWarehousePackingInfo.SetRange("Warehouse Shipment No.", "Warehouse Shipment No.");
                        //RecWarehousePackingInfo.SetRange("Sales Order No.", "Sales Order No.");
                        RecWarehousePackingInfo.SetCurrentKey("Container No", "Lot No.");
                        if RecWarehousePackingInfo.FindSet() then begin
                            repeat
                                TempWarehousePackingInfo.Reset();
                                TempWarehousePackingInfo.SetRange("Container No", RecWarehousePackingInfo."Container No");
                                TempWarehousePackingInfo.SetRange("Lot No.", RecWarehousePackingInfo."Lot No.");
                                if TempWarehousePackingInfo.FindFirst() then begin
                                    TempWarehousePackingInfo.Quantity := TempWarehousePackingInfo.Quantity + RecWarehousePackingInfo.Quantity;
                                    TempWarehousePackingInfo.Modify();
                                end else begin
                                    TempWarehousePackingInfo.Init();
                                    TempWarehousePackingInfo."Warehouse Shipment No." := RecWarehousePackingInfo."Warehouse Shipment No.";
                                    TempWarehousePackingInfo."Sales Order No." := RecWarehousePackingInfo."Sales Order No.";
                                    TempWarehousePackingInfo."SO Line No." := RecWarehousePackingInfo."SO Line No.";
                                    TempWarehousePackingInfo."Lot No." := RecWarehousePackingInfo."Lot No.";
                                    TempWarehousePackingInfo."Line No." := RecWarehousePackingInfo."Line No.";
                                    TempWarehousePackingInfo."Item No." := RecWarehousePackingInfo."Item No.";
                                    TempWarehousePackingInfo."Container No" := RecWarehousePackingInfo."Container No";
                                    TempWarehousePackingInfo.Quantity := RecWarehousePackingInfo.Quantity;
                                    TempWarehousePackingInfo.Insert();
                                end;
                            until RecWarehousePackingInfo.Next() = 0;
                        end;
                        TempWarehousePackingInfo.Reset();
                        TempWarehousePackingInfo.SetCurrentKey("Container No");
                        if TempWarehousePackingInfo.FindSet() then begin
                            repeat
                                RecItem.Get(TempWarehousePackingInfo."Item No.");
                                if (TempWarehousePackingInfo."Container No" = '') and (LotNoNumber = 0) then begin
                                    LotNo1 += '<b>' + TempWarehousePackingInfo."Container No" + '</b><br>LOT NO. :<br>';
                                    LotNo2 += '<br><br>';
                                end;
                                if oldContainerNo <> TempWarehousePackingInfo."Container No" then begin
                                    if LotNoNumber mod 2 = 1 then begin
                                        LotNo2 += '<br><br><br>';
                                    end;
                                    LotNoNumber := 1;
                                    LotNo1 += '<b>' + TempWarehousePackingInfo."Container No" + '</b><br>LOT NO. :<br>' + RecItem.Description + '<br>' + TempWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(TempWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    LotNo2 += '<br><br>';
                                    oldContainerNo := TempWarehousePackingInfo."Container No";
                                end else begin
                                    LotNoNumber := LotNoNumber + 1;
                                    if LotNoNumber mod 2 = 0 then begin
                                        LotNo2 += RecItem.Description + '<br>' + TempWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(TempWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    end else begin
                                        LotNo1 += RecItem.Description + '<br>' + TempWarehousePackingInfo."Lot No." + ' - ' + Format(Round(abs(TempWarehousePackingInfo.Quantity), 0.1, '=')) + ' ' + RecItem."Base Unit of Measure" + '<br><br>';
                                    end;

                                end;
                            until TempWarehousePackingInfo.Next() = 0;
                        end;

                    end;
                }

                trigger OnAfterGetRecord()
                var
                    ISODoc: Record "RV ISO Document";
                    WarehousePackingInfo: Record "RV Warehouse Packing Info.";
                    TempWarehousePackingInfo: Record "RV Warehouse Packing Info." temporary;
                    TempOrderNo: Integer;
                    WarehouseCommentLine: Record "Warehouse Comment Line";
                begin
                    chr10 := 10;
                    OrderNo := '';
                    TempOrderNo := 1;
                    WarehouseComment := '';
                    MARKS := '';
                    ISODoc.Reset();
                    ISODoc.SetRange("Report Code", 'PACKING LIST');
                    if ISODoc.FindFirst() then begin
                        ISODocumentNo := ISODoc."ISO Document No.";
                        ISODocVersion := ISODoc."ISO Doc. Version No.";
                    end;

                    WarehousePackingInfo.Reset();
                    WarehousePackingInfo.SetRange("Warehouse Shipment No.", "No.");
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
                            if WarehousePackingInfo.Comment <> '' then
                                MARKS += WarehousePackingInfo.Comment + Format(chr10);
                        until WarehousePackingInfo.Next() = 0;
                    end;

                    WarehouseCommentLine.Reset();
                    WarehouseCommentLine.SetRange("No.", "No.");
                    WarehouseCommentLine.SetRange("Table Name", WarehouseCommentLine."Table Name"::"Whse. Shipment");
                    WarehouseCommentLine.SetCurrentKey("Line No.");
                    if WarehouseCommentLine.FindSet() then begin
                        repeat
                            WarehouseComment += WarehouseCommentLine.Comment + Format(chr10);
                        until WarehouseCommentLine.Next() = 0;
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 2);
                IsPrePacking := true;
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
        ReportTitle: Label 'PROFORMA PACKING LIST';
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
        WarehouseComment: Text;
        chr10: Char;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
