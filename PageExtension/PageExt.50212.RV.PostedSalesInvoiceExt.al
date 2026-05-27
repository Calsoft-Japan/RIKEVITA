/// <summary>
/// PageExtension RV Sales Invoice (ID 50212) extends "Sales Invoice"
/// FDD021 2026/05/11: New. (Bobby.ji)
/// </summary>
pageextension 50212 "RV Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {

    }
    actions
    {
        addbefore(SendCustom)
        {
            action("SalesInvoiceLocal")
            {
                Caption = 'Sales Invoice(Local)';
                Image = ViewPage;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ReportRec: Record "Sales Invoice Header";
                begin
                    ReportRec.Reset();
                    ReportRec.SetRange("No.", Rec."No.");
                    //ReportRec.SetRange("Document Type", ReportRec."Document Type"::Invoice);
                    Report.Run(50204, TRUE, FALSE, ReportRec);
                end;
            }
            action("SalesInvoiceOversea")
            {
                Caption = 'Sales Invoice (Oversea)';
                Image = ViewPage;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ReportRec: Record "Sales Invoice Header";
                begin
                    ReportRec.Reset();
                    ReportRec.SetRange("No.", Rec."No.");
                    Report.Run(50206, TRUE, FALSE, ReportRec);
                end;
            }
        }
        addafter("SendCustom_Promoted")
        {
            actionref("SalesInvoiceLocal_Promoted"; "SalesInvoiceLocal")
            {
            }
            actionref("SalesInvoiceOversea_Promoted"; "SalesInvoiceOversea")
            {
            }
        }
    }
}
