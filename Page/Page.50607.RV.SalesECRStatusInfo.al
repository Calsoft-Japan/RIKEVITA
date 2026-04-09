page 50607 "RV Sales ECR Status Info."
{
    ApplicationArea = All;
    Caption = 'ECR Calculation Details';
    PageType = List;
    SourceTable = "RV Sales ECR Status Info.";
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("SO Line No."; Rec."SO Line No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SO Line No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Shipment Method"; Rec."Shipment Method")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shipment Method field.', Comment = '%';
                }
                field("Sailing Category"; Rec."Sailing Category")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sailing Category field.', Comment = '%';
                }
                field("ECR Required"; Rec."ECR Required")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the ECR Required field.', Comment = '%';
                }
                field("Bypass ECR"; Rec."Bypass ECR")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bypass ECR field.', Comment = '%';
                }
                field("Latest ECR Date"; Rec."Latest ECR Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Latest ECR Date field.', Comment = '%';
                }
                field("ECR Status"; Rec."ECR Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the ECR Status field.', Comment = '%';
                }
                field("Prod. Due Date"; Rec."Prod. Due Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prod. Due Date field.', Comment = '%';
                }
                field("Reservation Quantity"; Rec."Reservation Quantity")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reservation Quantity field.', Comment = '%';
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Order Quantity field.', Comment = '%';
                }
                field("Original ECR Date"; Rec."Original ECR Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Original ECR Date field.', Comment = '%';
                }
                field(Delayed; Rec.Delayed)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Delayed field.', Comment = '%';
                }
                field("ECR Change Remark Code"; Rec."ECR Change Remark Code")
                {
                    ToolTip = 'Specifies the value of the ECR Change Remark Code field.', Comment = '%';
                }
                field("ECR Change Remark"; Rec."ECR Change Remark")
                {
                    ToolTip = 'Specifies the value of the ECR Change Remark field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ECRInfoRefresh)
            {
                Caption = 'ECR Info. Refresh';
                ToolTip = 'Refresh the ECR status information.';
                Image = Refresh;

                trigger OnAction()
                var
                    ECRCalcMgt: Report "RV ECR Calculation Info";
                    SLfilter: Record "Sales Line";
                begin
                    ECRCalcMgt.Run();
                end;
            }
            action(ECRPass)
            {
                Caption = 'ECR Pass';
                ToolTip = 'Pass the ECR for current sales order line.';
                Image = Check;

                trigger OnAction()
                var
                    SalesECRStatusInfo: Record "RV Sales ECR Status Info.";
                begin
                    CurrPage.SetSelectionFilter(SalesECRStatusInfo);
                    SalesECRStatusInfo.ModifyAll("Bypass ECR", true);
                end;
            }
            action(ReservationEntries)
            {
                Caption = 'Reservation Entries';
                ToolTip = 'View the reservation entries for current sales order line.';
                Image = ReservationLedger;

                trigger OnAction()
                var
                    ReservEntry: Record "Reservation Entry";
                begin
                    ReservEntry.InitSortingAndFilters(true);
                    SetReservationFilters(ReservEntry);
                    PAGE.RunModal(PAGE::"Reservation Entries", ReservEntry)
                end;
            }
        }
        area(Promoted)
        {
            actionref(ECRInfoRefresh_Promoted; ECRInfoRefresh) { }
            actionref(ECRPass_Promoted; ECRPass) { }
            actionref(ReservationEntries_Promoted; ReservationEntries) { }
        }
    }
    /// <summary>
    /// Filters the reservation entries for the sales line.
    /// </summary>
    /// <param name="ReservEntry">The reservation entry to filter.</param>
    procedure SetReservationFilters(var ReservEntry: Record "Reservation Entry")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.get(SalesLine."Document Type"::Order, Rec."Sales Order No.", Rec."SO Line No.");
        ReservEntry.SetSourceFilter(DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", false);
        ReservEntry.SetSourceFilter('', 0);
    end;
}
