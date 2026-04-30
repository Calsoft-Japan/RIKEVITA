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
    RDLCLayout = './ReportLayout/RV_PackingList.rdlc';

    dataset
    {
        dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
        {
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
            trigger OnAfterGetRecord()
            var
                ISODoc: Record "RV ISO Document";
                WarehouseShipmentLine: Record "Warehouse Shipment Line";
                SalesHeader: Record "Sales Header";
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
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", WarehouseShipmentLine."Source No.");
                    if SalesHeader.FindFirst() then begin
                        //FromValue := SalesHeader."RV_Country of Origin";
                        ToValue := SalesHeader."Ship-to Name";
                        SailingOnOrAbout := SalesHeader."RV_SAILING ON OR ABOUT";
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
