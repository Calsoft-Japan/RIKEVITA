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

            // A区：报表页眉
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }

            column(RegistrationNo; 'Registration No.: ' + CompanyInfo."Registration No.")
            {
            }
            column(ReportTitle; 'DELIVERY ORDER')
            {
            }

            // ③ Related ISO Document Information
            column(ISODocumentNo; ISODoc."ISO Document No.")
            {
            }
            column(ISODocVersion; ISODoc."ISO Doc. Version No.")
            {
            }

            // ④ Print Date
            column(PrintDate; Today())
            {
            }

            // ⑤ SOLD TO Address
            column(SoldToName; Header."Sell-to Customer Name")
            {
            }
            column(SoldToAddress; Header."Sell-to Address")
            {
            }
            column(SoldToCity; Header."Sell-to City")
            {
            }

            // ⑥ DELIVERY NO
            column(DeliveryNo; Header."No.")
            {
            }

            // ⑦ ORDER NO
            column(OrderNo; Header."Order No.")
            {
            }

            // ⑧ Customer contact name
            column(ContactName; Header."Sell-to Contact")
            {
            }

            // ⑨ TERMS
            column(Terms; PaymentTerms.Description)
            {
            }

            // B区：行数据
            dataitem(Lines; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");


                // 根据文档 2.2.3.4，需要从 Item Ledger Entry 获取 Lot No.
                column(LotNo; ILE."Lot No.")
                {
                }

                column(Description; Item.Description)
                {
                }

                column(Quantity; Lines.Quantity)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // 获取物料描述和分类账条目
                    if Item.Get(Lines."No.") then;
                end;
            }

            // C区：Ship to Address
            column(ShipToName; Header."Ship-to Name")
            {
            }
            column(ShipToAddress; Header."Ship-to Address")
            {
            }
            column(ShipToCity; Header."Ship-to City")
            {
            }

            trigger OnAfterGetRecord()
            var
                CompanyInfo: Record "Company Information";
                ISODoc: Record "RV ISO Document";
                PaymentTerms: Record "Payment Terms";
            begin
                CompanyInfo.Get();
                // 查找 ISO 文档信息 (假设 Report Code = 'DELIVERY ORDER')
                ISODoc.SetRange("Report Code", 'DELIVERY ORDER');
                if ISODoc.FindFirst() then;

                if PaymentTerms.Get(Header."Payment Terms Code") then;
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
                    /*field(PrintRSPO; PrintRSPOOption)
                    {
                        Caption = 'Print RSPO Information';
                        OptionCaption = 'Yes,No';
                    }
                    */
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        Item: Record Item;
        ILE: Record "Item Ledger Entry";
        ISODoc: Record "RV ISO Document";
        PaymentTerms: Record "Payment Terms";
        PrintRSPOOption: Option "Yes","No";
}
