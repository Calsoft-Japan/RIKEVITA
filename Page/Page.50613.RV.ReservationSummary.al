/// <summary>
/// Page RV Reservation Summary (ID 50613).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
page 50613 "RV Reservation Summary"
{
    Caption = 'Summary';
    PageType = List;
    SourceTable = "RV Reservation Summary";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Summary Type"; Rec."Summary Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the table that contributed to the quantity.';
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total quantity from the source table.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        OpenSourceRecords(Rec."Query No.");
                    end;
                }
            }
        }
    }

    procedure SetItemAndDate(ItemNo: Code[20]; StartingDate: Date; EndDate: Date; DataType: enum "RV Invy. Planning Data Type")
    var
        QueryQtyOnComponentLines: Query "RV Qty. on Component Lines";
        QueryPlanningIssues: Query "RV Planning Issues";
        QueryPlanningTranShip: Query "RV Planning Tran. Ship";
        QueryQtyOnSalesOrder: Query "RV Qty. on Sales Order";
        QueryTransOrdShipment: Query "RV Trans. Ord. Shipment";
        QueryQtyOnPurchReturn: Query "RV Qty. on Purch. Return";
        QueryScheduledReceipt: Query "RV Scheduled Receipt";
        QueryQtyOnPurchOrder: Query "RV Qty. on Purch. Order";
        QueryTransOrdReceipt: Query "RV Trans. Ord. Receipt";
        QueryQtyinTransit: Query "RV Qty. in Transit";
        QueryQtyOnSalesReturn: Query "RV Qty. on Sales Return";
        // QueryPlanningReceipt: Query "RV Planning Receipt";
        QueryPlannedOrderReceipt: Query "RV Planned Order Receipt";
        QueryItemInv: Query "RV Item Inventory";
        QueryWarehouseEntry: Query "RV Warehouse Entry";
        QueryItemInvExpired: Query "RV Item Inventory Expired";
    begin
        Rec.DeleteAll();
        if DataType = DataType::"Gross Requirement" then begin
            QueryQtyOnComponentLines.SetRange(ItemNo, ItemNo);
            QueryQtyOnComponentLines.SetRange(DueDate, StartingDate, EndDate);
            QueryQtyOnComponentLines.Open();
            while QueryQtyOnComponentLines.Read() do
                AddSummaryLine('Prod. Order Component', 50602, QueryQtyOnComponentLines.Quantity, ItemNo, StartingDate, EndDate);
            QueryQtyOnComponentLines.Close();

            QueryPlanningIssues.SetRange(ItemNo, ItemNo);
            QueryPlanningIssues.SetRange(DueDate, StartingDate, EndDate);
            QueryPlanningIssues.Open();
            while QueryPlanningIssues.Read() do
                AddSummaryLine('Planning Component', 50603, QueryPlanningIssues.Quantity, ItemNo, StartingDate, EndDate);
            QueryPlanningIssues.Close();

            QueryPlanningTranShip.SetRange(ItemNo, ItemNo);
            QueryPlanningTranShip.SetRange(TransferShipmentDate, StartingDate, EndDate);
            QueryPlanningTranShip.Open();
            while QueryPlanningTranShip.Read() do
                AddSummaryLine('Requisition Line - Transfer', 50604, QueryPlanningTranShip.Quantity, ItemNo, StartingDate, EndDate);
            QueryPlanningTranShip.Close();

            QueryQtyOnSalesOrder.SetRange(ItemNo, ItemNo);
            QueryQtyOnSalesOrder.SetRange(ShipmentDate, StartingDate, EndDate);
            QueryQtyOnSalesOrder.Open();
            while QueryQtyOnSalesOrder.Read() do
                AddSummaryLine('Sales Line - Order', 50605, QueryQtyOnSalesOrder.Quantity, ItemNo, StartingDate, EndDate);
            QueryQtyOnSalesOrder.Close();

            QueryTransOrdShipment.SetRange(ItemNo, ItemNo);
            QueryTransOrdShipment.SetRange(ShipmentDate, StartingDate, EndDate);
            QueryTransOrdShipment.Open();
            while QueryTransOrdShipment.Read() do
                AddSummaryLine('Transfer Line - Shipment', 50606, QueryTransOrdShipment.Quantity, ItemNo, StartingDate, EndDate);
            QueryTransOrdShipment.Close();

            QueryQtyOnPurchReturn.SetRange(ItemNo, ItemNo);
            QueryQtyOnPurchReturn.SetRange(ExpectedReceiptDate, StartingDate, EndDate);
            QueryQtyOnPurchReturn.SetFilter(RV_TransitBin, '<>%1', "RV Inventory Status"::"Goods In Transit");
            QueryQtyOnPurchReturn.Open();
            while QueryQtyOnPurchReturn.Read() do
                AddSummaryLine('Purchase Line - Return Order', 50607, QueryQtyOnPurchReturn.Quantity, ItemNo, StartingDate, EndDate);
            QueryQtyOnPurchReturn.Close();
        end else
            if DataType = DataType::"Scheduled Receipt" then begin
                QueryScheduledReceipt.SetRange(ItemNo, ItemNo);
                QueryScheduledReceipt.SetRange(DueDate, StartingDate, EndDate);
                QueryScheduledReceipt.Open();
                while QueryScheduledReceipt.Read() do
                    AddSummaryLine('Prod. Order Line', 50608, QueryScheduledReceipt.Quantity, ItemNo, StartingDate, EndDate);
                QueryScheduledReceipt.Close();

                QueryQtyOnPurchOrder.SetRange(ItemNo, ItemNo);
                QueryQtyOnPurchOrder.SetFilter(RV_TransitBin, '<>%1', "RV Inventory Status"::"Goods In Transit");
                QueryQtyOnPurchOrder.SetRange(ExpectedReceiptDate, StartingDate, EndDate);
                QueryQtyOnPurchOrder.Open();
                while QueryQtyOnPurchOrder.Read() do
                    AddSummaryLine('Purchase Line - Order', 50609, QueryQtyOnPurchOrder.Quantity, ItemNo, StartingDate, EndDate);
                QueryQtyOnPurchOrder.Close();

                QueryTransOrdReceipt.SetRange(ItemNo, ItemNo);
                QueryTransOrdReceipt.SetRange(ReceiptDate, StartingDate, EndDate);
                QueryTransOrdReceipt.Open();
                while QueryTransOrdReceipt.Read() do
                    AddSummaryLine('Transfer Line - Receipt', 50610, QueryTransOrdReceipt.Quantity, ItemNo, StartingDate, EndDate);
                QueryTransOrdReceipt.Close();

                QueryQtyinTransit.SetRange(ItemNo, ItemNo);
                QueryQtyinTransit.SetRange(ReceiptDate, StartingDate, EndDate);
                QueryQtyinTransit.Open();
                while QueryQtyinTransit.Read() do
                    AddSummaryLine('Transfer Line - In Transit', 50611, QueryQtyinTransit.Quantity, ItemNo, StartingDate, EndDate);
                QueryQtyinTransit.Close();

                QueryQtyOnSalesReturn.SetRange(ItemNo, ItemNo);
                QueryQtyOnSalesReturn.SetRange(ShipmentDate, StartingDate, EndDate);
                QueryQtyOnSalesReturn.Open();
                while QueryQtyOnSalesReturn.Read() do
                    AddSummaryLine('Sales Line - Return Order', 50612, QueryQtyOnSalesReturn.Quantity, ItemNo, StartingDate, EndDate);
                QueryQtyOnSalesReturn.Close();

                // QueryPlanningReceipt.SetRange(ItemNo, ItemNo);
                // QueryPlanningReceipt.SetRange(DueDate, StartingDate, EndDate);
                // QueryPlanningReceipt.Open();
                // while QueryPlanningReceipt.Read() do
                //     AddSummaryLine('Requisition Line', 50613, QueryPlanningReceipt.Quantity, ItemNo, StartingDate, EndDate);
                // QueryPlanningReceipt.Close();

                QueryPlannedOrderReceipt.SetRange(ItemNo, ItemNo);
                QueryPlannedOrderReceipt.SetRange(DueDate, StartingDate, EndDate);
                QueryPlannedOrderReceipt.Open();
                while QueryPlannedOrderReceipt.Read() do
                    AddSummaryLine('Prod. Order Line - Planned', 50614, QueryPlannedOrderReceipt.Quantity, ItemNo, StartingDate, EndDate);
                QueryPlannedOrderReceipt.Close();
            end else if DataType = DataType::"Planned Inventory" then begin
                QueryItemInv.SetRange(ItemNo, ItemNo);
                QueryItemInv.Open();
                while QueryItemInv.Read() do
                    AddSummaryLine('Item Inventory', 50601, QueryItemInv.Quantity, ItemNo, StartingDate, EndDate);
                QueryItemInv.Close();

                QueryWarehouseEntry.SetRange(ItemNo, ItemNo);
                QueryWarehouseEntry.Open();
                while QueryWarehouseEntry.Read() do
                    AddSummaryLine('Receipt from Transit Inventory', 50615, QueryWarehouseEntry.Quantity, ItemNo, StartingDate, EndDate);
                QueryWarehouseEntry.Close();
            end else if DataType = DataType::"Receipt from Transit" then begin
                QueryQtyOnPurchOrder.SetRange(ItemNo, ItemNo);
                QueryQtyOnPurchOrder.SetRange(RV_TransitBin, "RV Inventory Status"::"Goods In Transit");
                QueryQtyOnPurchOrder.SetRange(ExpectedReceiptDate, StartingDate, EndDate);
                QueryQtyOnPurchOrder.Open();
                while QueryQtyOnPurchOrder.Read() do
                    AddSummaryLine('Purchase Line - Order', 506091, QueryQtyOnPurchOrder.Quantity, ItemNo, StartingDate, EndDate);
                QueryQtyOnPurchOrder.Close();
            end else if DataType = DataType::"Expired Inventory" then begin
                QueryItemInvExpired.SetRange(ItemNo, ItemNo);
                if StartingDate = 0D then
                    QueryItemInvExpired.setfilter(ExpirationDate, '<>%1&..%2', StartingDate, EndDate)
                else
                    QueryItemInvExpired.SetRange(ExpirationDate, StartingDate, EndDate);
                QueryItemInvExpired.Open();
                while QueryItemInvExpired.Read() do
                    AddSummaryLine('Expired Inventory', 50617, QueryItemInvExpired.Quantity, ItemNo, StartingDate, EndDate);
                QueryItemInvExpired.Close();
            end;
        CurrPage.Update(false);
    end;

    local procedure AddSummaryLine(SummaryType: Text[100]; QueryNo: Integer; Quantity: Decimal; ItemNo: Code[20]; StartingDate: Date; EndDate: Date)
    begin
        if Quantity = 0 then
            exit;
        Rec.Init();
        Rec."Entry No." := QueryNo;
        Rec."Summary Type" := SummaryType;
        Rec."Total Quantity" := Quantity;
        Rec."Query No." := QueryNo;
        Rec."Item No." := ItemNo;
        Rec."Starting Date" := StartingDate;
        Rec."Ending Date" := EndDate;
        Rec.Insert();
    end;

    local procedure OpenSourceRecords(QueryNo: Integer)
    var
        ProdOrderComponent: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        RequisitionLine: Record "Requisition Line";
        SalesLine: Record "Sales Line";
        TransferLine: Record "Transfer Line";
        PurchaseLine: Record "Purchase Line";
        ProdOrderLine: Record "Prod. Order Line";
        ILE: Record "Item Ledger Entry";
        WHE: Record "Warehouse Entry";
    begin
        case QueryNo of
            50601:
                begin
                    ILE.SetRange("Item No.", Rec."Item No.");
                    ILE.SetRange(RV_TranistLocation, ILE.RV_TranistLocation::Stock);
                    ILE.SetFilter("Remaining Quantity", '<>%1', 0);
                    Page.RunModal(Page::"Item Ledger Entries", ILE);
                end;
            50602:
                begin
                    ProdOrderComponent.SetRange(status, ProdOrderComponent.status::Planned, ProdOrderComponent.status::Released);
                    ProdOrderComponent.SetRange("Item No.", Rec."Item No.");
                    ProdOrderComponent.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    ProdOrderComponent.SetRange("Due Date", Rec."Starting Date", Rec."Ending Date");
                    ProdOrderComponent.setfilter("Remaining Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Prod. Order Comp. Line List", ProdOrderComponent);
                end;
            50603:
                begin
                    PlanningComponent.SetRange("Planning Line Origin", PlanningComponent."Planning Line Origin"::" ");
                    PlanningComponent.SetRange("Item No.", Rec."Item No.");
                    PlanningComponent.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    PlanningComponent.SetRange("Due Date", Rec."Starting Date", Rec."Ending Date");
                    PlanningComponent.SetFilter("Expected Quantity (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Planning Component List", PlanningComponent);
                end;
            50604:
                begin
                    RequisitionLine.setfilter("Worksheet Template Name", '<>%1', '');
                    RequisitionLine.setfilter("Journal Batch Name", '<>%1', '');
                    RequisitionLine.SetRange("Replenishment System", RequisitionLine."Replenishment System"::Transfer);
                    RequisitionLine.SetRange(Type, RequisitionLine.Type::Item);
                    RequisitionLine.SetRange("No.", Rec."Item No.");
                    RequisitionLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    RequisitionLine.SetRange("Transfer Shipment Date", Rec."Starting Date", Rec."Ending Date");
                    RequisitionLine.SetFilter("Quantity (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Requisition Lines", RequisitionLine);
                end;
            50605:
                begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("No.", Rec."Item No.");
                    SalesLine.SetRange(RV_TranistLocation, ILE.RV_TranistLocation::Stock);
                    SalesLine.SetRange("Shipment Date", Rec."Starting Date", Rec."Ending Date");
                    SalesLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Sales Lines", SalesLine);
                end;
            50606:
                begin
                    TransferLine.SetRange("Derived From Line No.", 0);
                    TransferLine.SetRange("Item No.", Rec."Item No.");
                    TransferLine.SetRange(RV_TransferfromLocation, "RV Inventory Status"::Stock);
                    TransferLine.SetRange("Shipment Date", Rec."Starting Date", Rec."Ending Date");
                    TransferLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Transfer Lines", TransferLine);
                end;
            50607:
                begin
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Return Order");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetRange("No.", Rec."Item No.");
                    PurchaseLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    PurchaseLine.SetRange("Expected Receipt Date", Rec."Starting Date", Rec."Ending Date");
                    PurchaseLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Purchase Lines", PurchaseLine);
                end;
            50608:
                begin
                    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::"Firm Planned", ProdOrderLine.Status::Released);
                    ProdOrderLine.SetRange("Item No.", Rec."Item No.");
                    ProdOrderLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    ProdOrderLine.SetRange("Due Date", Rec."Starting Date", Rec."Ending Date");
                    ProdOrderLine.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Prod. Order Line List", ProdOrderLine);
                end;
            50609:
                begin
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetRange("No.", Rec."Item No.");
                    PurchaseLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    PurchaseLine.SetRange("Expected Receipt Date", Rec."Starting Date", Rec."Ending Date");
                    PurchaseLine.SetFilter(RV_TranistBin, '<>%1', PurchaseLine.RV_TranistBin::"Goods In Transit");
                    PurchaseLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Purchase Lines", PurchaseLine);
                end;
            506091:
                begin
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetRange("No.", Rec."Item No.");
                    PurchaseLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    PurchaseLine.SetRange("Expected Receipt Date", Rec."Starting Date", Rec."Ending Date");
                    PurchaseLine.SetRange(RV_TranistBin, PurchaseLine.RV_TranistBin::"Goods In Transit");
                    PurchaseLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Purchase Lines", PurchaseLine);
                end;
            50610:
                begin
                    TransferLine.SetRange("Derived From Line No.", 0);
                    TransferLine.SetRange("Item No.", Rec."Item No.");
                    TransferLine.SetRange(RV_TransfertoLocation, "RV Inventory Status"::Stock);
                    TransferLine.SetRange("Receipt Date", Rec."Starting Date", Rec."Ending Date");
                    TransferLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Transfer Lines", TransferLine);
                end;
            50611:
                begin
                    TransferLine.SetRange("Derived From Line No.", 0);
                    TransferLine.SetRange("Item No.", Rec."Item No.");
                    TransferLine.SetRange(RV_InTransitLocation, "RV Inventory Status"::Stock);
                    TransferLine.SetRange("Receipt Date", Rec."Starting Date", Rec."Ending Date");
                    TransferLine.SetFilter("Qty. in Transit (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Transfer Lines", TransferLine);
                end;
            50612:
                begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Return Order");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("No.", Rec."Item No.");
                    SalesLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    SalesLine.SetRange("Shipment Date", Rec."Starting Date", Rec."Ending Date");
                    SalesLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Sales Lines", SalesLine);
                end;
            50613:
                begin
                    RequisitionLine.SetRange(Type, RequisitionLine.Type::Item);
                    RequisitionLine.SetRange("No.", Rec."Item No.");
                    RequisitionLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    RequisitionLine.SetRange("Due Date", Rec."Starting Date", Rec."Ending Date");
                    RequisitionLine.SetFilter("Quantity (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Requisition Lines", RequisitionLine);
                end;
            50614:
                begin
                    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Planned);
                    ProdOrderLine.SetRange("Item No.", Rec."Item No.");
                    ProdOrderLine.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    ProdOrderLine.SetRange("Due Date", Rec."Starting Date", Rec."Ending Date");
                    ProdOrderLine.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
                    Page.RunModal(Page::"Prod. Order Line List", ProdOrderLine);
                end;
            50615:
                begin
                    WHE.SetRange("Item No.", Rec."Item No.");
                    WHE.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    WHE.SetRange(RV_TranistBin, WHE.RV_TranistBin::"Goods In Transit");
                    Page.RunModal(Page::"Warehouse Entries", WHE);
                end;
            50617:
                begin
                    ILE.SetRange("Item No.", Rec."Item No.");
                    if Rec."Starting Date" = 0D then
                        ILE.setfilter("Expiration Date", '<>%1&..%2', Rec."Starting Date", Rec."Ending Date")
                    else
                        ILE.SetRange("Expiration Date", Rec."Starting Date", Rec."Ending Date");
                    ILE.SetRange(RV_TranistLocation, "RV Inventory Status"::Stock);
                    ILE.SetFilter("Remaining Quantity", '<>%1', 0);
                    Page.RunModal(Page::"Item Ledger Entries", ILE);
                end;
        end;
    end;
}
