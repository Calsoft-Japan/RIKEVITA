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
                column(Measurement; Measurement)
                {
                }
                column(Symbol_Display_Packing_List; ItemSymbolSetting."Symbol Display Packing List")
                {
                }
                column(Symbol_Picture; ItemSymbolSetting."Item Symbol Image")
                {
                }

                column(External_Document_No; ExternalDocumentNo) { }
                trigger OnAfterGetRecord()
                var
                    RecItem: Record Item;
                    RecSalesHeader: Record "Sales Header";
                    tmpBlob: Codeunit "Temp Blob";
                    InStr: InStream;
                    OutStr: OutStream;
                begin
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
                end;
            }

            trigger OnAfterGetRecord()
            var
                ISODoc: Record "RV ISO Document";
                WarehouseShipmentLine: Record "Warehouse Shipment Line";
                SalesInvoiceHeader: Record "Sales Invoice Header";
            begin
                //CompanyInfo.Get();
                //CompanyInfo.CalcFields(Picture);

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
                    SalesInvoiceHeader.SetRange("No.", WarehouseShipmentLine."Source No.");
                    if SalesInvoiceHeader.FindFirst() then begin

                        FromValue := SalesInvoiceHeader."RV_Country of Origin";
                        ToValue := SalesInvoiceHeader."Ship-to Name";
                        SailingOnOrAbout := Format(SalesInvoiceHeader."RV_SAILING ON OR ABOUT");
                    end;
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
        ItemSymbolImageBlob: Codeunit "Temp Blob";

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
