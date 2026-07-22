report 50603 "RV Order Listing Update"
/// <summary>
/// COMMON 2026/05/02: New. (Stephen)
/// </summary>

{
    ApplicationArea = All;
    Caption = 'Order Listing Update';
    //UsageCategory = Tasks;
    ProcessingOnly = true;
    //PreviewMode = PrintLayout;
    //DefaultLayout = RDLC;
    //RDLCLayout = './ReportLayout/RV_COAReport.rdl';

    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableView = sorting("Document No.");
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Sales Lines';
            trigger OnPreDataItem()
            begin
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetFilter("Outstanding Quantity", '> 0');
                SalesLine.SetAutoCalcFields("Reserved Quantity", "Reserved Qty. (Base)");
            end;

            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
                ShiptoAddress: Record "Ship-to Address";
                WhseshipmentHeader: Record "Warehouse Shipment Header";
                WhseshipmentLine: Record "Warehouse Shipment Line";
                BlanketSalesLine: Record "Sales Line";
                BlanketSalesHeader: Record "Sales Header";
                ProdHeader: Record "Production Order";
                ProdLine: Record "Prod. Order Line";
                transferLine: Record "Transfer Line";
                TransferHeader: Record "Transfer Header";
                ReservationEntry: Record "Reservation Entry";
                SalesCommentLine: Record "Sales Comment Line";
                OrderListing: Record "RV Order Listing";
                ItemUnitOfMeasure: Record "Item Unit of Measure";
                SLReserveEntry: Record "Reservation Entry";
            //ProdHeader:Record "Production Order";

            begin
                //TransferOrderNo := '';
                //TransferOrderLineNo := '';
                //ProdOrderNo := '';
                //ProdOrderLineNo := '';
                Temtransferorder.deleteall;
                Temtransferline.deleteall;
                Temprodorder.deleteall;
                EntryNo += 1;
                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                OrderListing.reset;
                OrderListing.SetRange("Sales Order No.", SalesLine."Document No.");
                OrderListing.SetRange("Sales Order Line No.", SalesLine."Line No.");
                if NOT OrderListing.FindFirst() then begin
                    EntryNo += 1;
                    OrderListing.Init();
                    OrderListing."Entry No." := EntryNo;
                end;
                OrderListing."Sales Order No." := SalesLine."Document No.";
                OrderListing."Sales Order Line No." := SalesLine."Line No.";
                OrderListing."Order Date" := SalesHeader."Order Date";
                OrderListing."Order Age (Days)" := Today - SalesHeader."Order Date";
                OrderListing."Item No." := SalesLine."No.";
                OrderListing."Item Description" := SalesLine."Description";
                OrderListing."Order Qty. (UOM)" := SalesLine."Quantity";
                OrderListing."Reserved Qty. (UOM)" := SalesLine."Reserved Quantity";
                OrderListing."Order Unit of Measure" := SalesLine."Unit of Measure Code";
                OrderListing."Order Qty. (Base)" := SalesLine."Quantity (Base)";
                OrderListing."Requested Delivery Date" := SalesLine."Requested Delivery Date";
                OrderListing."Customer No." := SalesHeader."Sell-to Customer No.";
                OrderListing."Ship-to Customer Name" := SalesHeader."Ship-to Name";
                OrderListing."Ship-to Country" := SalesHeader."Ship-to Country/Region Code";
                OrderListing."Sales Force Remark" := SalesHeader."RV_Sales Force Remark";
                OrderListing."RVM PIC" := SalesHeader."RV_RVM PIC";
                OrderListing."Sales Office Sales Rep." := SalesHeader."RV_Sales Office Sales Rep.";

                IF SalesLine."Requested Delivery Date" <> 0D then
                    OrderListing."Order Lead Time (Days)" := SalesLine."Requested Delivery Date" - SalesHeader."Order Date"
                else
                    OrderListing."Order Lead Time (Days)" := SalesLine."Planned Delivery Date" - SalesHeader."Order Date";
                OrderListing."Packing Date" := SalesLine."RV_Stuffing Date";
                OrderListing."ECR Date" := SalesLine."RV_ECR Date";

                //KG quantity calculation.
                IF SalesLine."Unit of Measure Code" = 'KG' THEN begin
                    OrderListing."Order Qty. (KG)" := SalesLine.Quantity;
                    OrderListing."Reserved Qty. (KG)" := SalesLine."Reserved Quantity";
                end else begin
                    IF ItemUnitOfMeasure.Get(SalesLine."No.", 'KG') then begin
                        OrderListing."Order Qty. (KG)" := Round(SalesLine."Quantity (Base)" / ItemUnitOfMeasure."Qty. per Unit of Measure", 0.00001);
                        OrderListing."Reserved Qty. (KG)" := Round(SalesLine."Reserved Qty. (Base)" / ItemUnitOfMeasure."Qty. per Unit of Measure", 0.00001);
                    end;
                end;

                //Logistics Information
                IF ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN BEGIN
                    OrderListing."Holding Requirement 1" := ShiptoAddress."RV_Holding Period";
                    OrderListing."Bypass Holding Requirement" := ShiptoAddress."RV_Bypass ECR";
                END;

                WhseshipmentLine.Reset();
                WhseshipmentLine.setrange("Source No.", SalesLine."Document No.");
                WhseshipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
                if WhseshipmentLine.findlast then begin
                    OrderListing."Closing Date & Time 2" := WhseshipmentLine."RV_Closing Date";
                    OrderListing."SI Received Date" := WhseshipmentLine."RV_SI Received Date";
                    OrderListing.ETA := WhseshipmentLine.RV_ETA;
                    OrderListing.ETD := WhseshipmentLine.RV_ETD;
                    OrderListing."Packing Date" := WhseshipmentLine."RV_Stuffing Date";
                end;

                //related information
                OrderListing."Blanket Sales Order No." := SalesLine."Blanket Order No.";
                OrderListing."Blanket Sales Order Line No." := SalesLine."Blanket Order Line No.";
                FindReservationEntry(SalesLine);
                OrderListing."Transfer Order No." := '';
                OrderListing."Prod. Order No." := '';
                OrderListing."Transfer Order Line No." := '';
                OrderListing."Prod. Order Line No." := '';
                IF TemTransferOrder.FindSet() then
                    repeat
                        if OrderListing."Transfer Order No." = '' then
                            OrderListing."Transfer Order No." := TemTransferOrder."No."
                        else
                            OrderListing."Transfer Order No." := OrderListing."Transfer Order No." + '|' + TemTransferOrder."No.";
                        transferLine.Reset;
                        transferLine.SetRange("Document No.", TemTransferOrder."No.");
                        transferLine.SetRange("Item No.", salesLine."No.");
                        if transferLine.Findfirst() then
                            if OrderListing."Transfer Order Line No." <> FORMAT(transferLine."Line No.") then
                                OrderListing."Transfer Order Line No." := FORMAT(transferLine."Line No.");
                    until TemTransferOrder.Next() = 0;

                IF TemProdOrder.FindSet() then
                    repeat
                        If ProdHeader.Get(ProdHeader.Status::"Firm Planned", TemProdOrder."No.") then begin
                            if OrderListing."Prod. Order No." = '' then
                                OrderListing."Firm Prod. Order No." := TemProdOrder."No."
                            else
                                OrderListing."Firm Prod. Order No." := OrderListing."Firm Prod. Order No." + '|' + TemProdOrder."No.";
                            ProdLine.Reset;
                            ProdLine.SetRange("Prod. Order No.", TemProdOrder."No.");
                            ProdLine.SetRange("Item No.", salesLine."No.");
                            if ProdLine.Findfirst() then
                                if OrderListing."Firm Prod. Order Line No." <> FORMAT(ProdLine."Line No.") then
                                    OrderListing."Firm Prod. Order Line No." := FORMAT(ProdLine."Line No.");
                        end else begin
                            if OrderListing."Prod. Order No." = '' then
                                OrderListing."Prod. Order No." := TemProdOrder."No."
                            else
                                OrderListing."Prod. Order No." := OrderListing."Prod. Order No." + '|' + TemProdOrder."No.";
                            ProdLine.Reset;
                            ProdLine.SetRange("Prod. Order No.", TemProdOrder."No.");
                            ProdLine.SetRange("Item No.", salesLine."No.");
                            if ProdLine.Findfirst() then
                                if OrderListing."Prod. Order Line No." <> FORMAT(ProdLine."Line No.") then
                                    OrderListing."Prod. Order Line No." := FORMAT(ProdLine."Line No.");
                        end;
                    until TemProdOrder.Next() = 0;
                //OrderListing."Prod. Order Line No." := ProdOrderLineNo;
                //OrderListing."Transfer Order No." := TransferOrderNo;
                //OrderListing."Transfer Order Line No." := TransferOrderLineNo;

                ProdHeader.Reset();
                ProdHeader.SetFilter("No.", OrderListing."Prod. Order No.");
                if ProdHeader.FindLast() then
                    OrderListing."Packing Line" := SalesHeader."Shortcut Dimension 2 Code";
                //Status Update
                if OrderListing."Reserved Qty. (UOM)" <= 0 then
                    OrderListing.Status := OrderListing.Status::Ordered
                else
                    OrderListing.Status := OrderListing.Status::"Partial Reserved";
                if OrderListing."Reserved Qty. (UOM)" = OrderListing."Order Qty. (UOM)" then
                    OrderListing.Status := OrderListing.Status::Reserved;

                SalesCommentLine.SetRange("Document Type", SalesLine."Document Type");
                SalesCommentLine.SetRange("No.", SalesLine."Document No.");
                if SalesCommentLine.FindFirst() then
                    OrderListing.Comment := SalesCommentLine.Comment;
                IF not OrderListing.Insert() then
                    OrderListing.Modify();
                Counts += 1;


            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    procedure FindReservationEntry(var ProcessingsalesLine: Record "Sales Line")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        ReqLineDataType: Record "Requisition Line";
        TransferLine: Record "Transfer Line";
        ILEntry: Record "Item Ledger Entry";
        OutputILEntry: Record "Item Ledger Entry";
        ResEntryTransfer: Record "Reservation Entry";
        PlanBOM: Record "Planning Component";
    begin
        ResEntryMinus.Reset();
        ResEntryMinus.setrange("Source Type", 37);
        ResEntryMinus.setrange("Source ID", ProcessingsalesLine."Document No.");
        ResEntryMinus.SetRange("Source Ref. No.", ProcessingsalesLine."Line No.");
        ResEntryMinus.SetRange("Positive", false);
        if ResEntryMinus.FindSet() then
            repeat
                ResEntryPlus.Reset();
                ResEntryPlus.SetRange("Entry No.", ResEntryMinus."Entry No.");
                ResEntryPlus.SetRange("Positive", true);
                if ResEntryPlus.FindFirst() then begin
                    case ResEntryPlus."Source Type" of
                        Database::"Requisition Line":
                            begin
                                if ReqLineDataType.get(ResEntryPlus."Source ID", ResEntryPlus."Source Batch Name", ResEntryPlus."Source Ref. No.") then begin
                                    case ReqLineDataType."Ref. Order Type" of
                                        //just do tranfer order case, because may be the production order has been created but transfer order is not created.
                                        ReqLineDataType."Ref. Order Type"::Transfer:
                                            begin
                                                FindTransferLineReservationEntry(ResEntryPlus);
                                            end;

                                    end;
                                end;
                            end;
                        Database::"Transfer Line":
                            begin
                                if TransferLine.get(ResEntryPlus."Source ID", ResEntryPlus."Source Ref. No.") then begin
                                    IF TransferOrderNo = '' then
                                        TransferOrderNo := TransferLine."Document No."
                                    else
                                        TransferOrderNo := TransferOrderNo + '|' + TransferLine."Document No.";
                                    if TransferOrderLineNo = '' then
                                        TransferOrderLineNo := FORMAT(TransferLine."Line No.")
                                    else
                                        TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(TransferLine."Line No.");
                                    IF NOT TemTransferOrder.Get(TransferLine."Document No.") THEN BEGIN
                                        TemTransferOrder.Init();
                                        TemTransferOrder."No." := TransferLine."Document No.";
                                        TemTransferOrder.Insert();
                                    END;
                                    FindTransferLineReservationEntry(ResEntryPlus);

                                end;
                            end;
                        Database::"Item Ledger Entry":
                            begin
                                ILEntry.get(ResEntryPlus."Source Ref. No.");
                                if ILEntry."Document Type" = ILEntry."Entry Type"::Output then begin
                                    IF ProdOrderNo = '' then
                                        ProdOrderNo := ResEntryPlus."Source ID"
                                    else
                                        ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                    if ProdOrderLineNo = '' then
                                        ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                    else
                                        ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                    TemProdOrder.Reset();
                                    TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                    IF TemProdOrder.isempty THEN BEGIN
                                        TemProdOrder."No." := ResEntryPlus."Source ID";
                                        TemProdOrder.Insert();
                                    END;
                                end else begin
                                    if ILEntry."Entry Type" = ILEntry."Entry Type"::Transfer then begin
                                        IF TransferOrderNo = '' then
                                            TransferOrderNo := ILEntry."Order No."
                                        else
                                            TransferOrderNo := TransferOrderNo + '|' + ILEntry."Order No.";
                                        if TransferOrderLineNo = '' then
                                            TransferOrderLineNo := FORMAT(ILEntry."Order Line No.")
                                        else
                                            TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(ILEntry."Order Line No.");
                                        IF NOT TemTransferOrder.Get(ILEntry."Order No.") THEN BEGIN
                                            TemTransferOrder.Init();
                                            TemTransferOrder."No." := ILEntry."Order No.";
                                            TemTransferOrder.Insert();
                                        END;
                                    end;
                                    //Since the inventory is transfered, the production has been completed. just get related item ledger entry by lot no.                                 IF ILEntry."Lot No." <> '' then begin
                                    OutputILEntry.reset;
                                    OutputILEntry.SetRange("Entry Type", OutputILEntry."Entry Type"::Output);
                                    OutputILEntry.SetRange("Item No.", ILEntry."Item No.");
                                    OutputILEntry.SetRange("Lot No.", ILEntry."Lot No.");
                                    if OutputILEntry.FindFirst() then begin
                                        IF ProdOrderNo = '' then
                                            ProdOrderNo := OutputILEntry."Document No."
                                        else
                                            ProdOrderNo := ProdOrderNo + '|' + OutputILEntry."Document No.";
                                        if ProdOrderLineNo = '' then
                                            ProdOrderLineNo := FORMAT(OutputILEntry."Order Line No.")
                                        else
                                            ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(OutputILEntry."Order Line No.");
                                        TemProdOrder.Reset();
                                        TemProdOrder.SetRange("No.", OutputILEntry."Document No.");
                                        IF TemProdOrder.isempty THEN BEGIN
                                            TemProdOrder."No." := OutputILEntry."Document No.";
                                            TemProdOrder.Insert();
                                        END;
                                    end;
                                end;
                            end;
                        Database::"Prod. Order Line":
                            begin
                                IF ProdOrderNo = '' then
                                    ProdOrderNo := ResEntryPlus."Source ID"
                                else
                                    ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                if ProdOrderLineNo = '' then
                                    ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                else
                                    ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                TemProdOrder.Reset();
                                TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                IF TemProdOrder.isempty THEN BEGIN
                                    TemProdOrder."No." := ResEntryPlus."Source ID";
                                    TemProdOrder.Insert();
                                END;
                            end;
                    end;
                end;
            until ResEntryMinus.Next() = 0;
    end;

    procedure FindTransferLineReservationEntry(var TransResEntryPlus: Record "Reservation Entry")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        ReqLineDataType: Record "Requisition Line";
        TransferLine: Record "Transfer Line";
        ILEntry: Record "Item Ledger Entry";
        OutputILEntry: Record "Item Ledger Entry";
    begin
        ResEntryMinus.Reset();
        IF TransResEntryPlus."Source Type" = 5741 THEN BEGIN
            ResEntryMinus.setrange("Source Type", 5741);
            ResEntryMinus.setrange("Source ID", TransResEntryPlus."Source ID");
            ResEntryMinus.SetRange("Source Ref. No.", TransResEntryPlus."Source Ref. No.");
        end else begin
            ResEntryMinus.setrange("Source Type", 246);
            ResEntryMinus.setrange("Source ID", TransResEntryPlus."Source ID");
            ResEntryMinus.SetRange("Source Batch Name", TransResEntryPlus."Source Batch Name");
            ResEntryMinus.SetRange("Source Ref. No.", TransResEntryPlus."Source Ref. No.");
        end;
        ResEntryMinus.SetRange("Positive", false);
        if ResEntryMinus.findset then begin
            repeat
                ResEntryPlus.Reset();
                ResEntryPlus.setrange("Entry No.", ResEntryMinus."Entry No.");
                ResEntryPlus.setrange("Positive", true);
                if ResEntryPlus.FindSet() then begin
                    repeat
                        case ResEntryPlus."Source Type" of
                            Database::"Requisition Line":
                                begin
                                    if ReqLineDataType.get(ResEntryPlus."Source ID", ResEntryPlus."Source Batch Name", ResEntryPlus."Source Ref. No.") then begin
                                        case ReqLineDataType."Ref. Order Type" of
                                            //just do tranfer order case, because may be the production order has been created but transfer order is not created.
                                            ReqLineDataType."Ref. Order Type"::Transfer:
                                                FindTransferLineReservationEntry(TransResEntryPlus);
                                        end;
                                    end;
                                end;
                            Database::"Transfer Line":
                                begin
                                    if TransferLine.get(ResEntryPlus."Source ID", ResEntryPlus."Source Ref. No.") then begin
                                        IF TransferOrderNo = '' then
                                            TransferOrderNo := TransferLine."Document No."
                                        else
                                            TransferOrderNo := TransferOrderNo + '|' + TransferLine."Document No.";
                                        if TransferOrderLineNo = '' then
                                            TransferOrderLineNo := FORMAT(TransferLine."Line No.")
                                        else
                                            TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(TransferLine."Line No.");

                                        IF NOT TemTransferOrder.Get(TransferLine."Document No.") THEN BEGIN
                                            TemTransferOrder.Init();
                                            TemTransferOrder."No." := TransferLine."Document No.";
                                            TemTransferOrder.Insert();
                                        END;
                                        FindTransferLineReservationEntry(TransResEntryPlus);

                                    end;
                                end;
                            Database::"Item Ledger Entry":
                                begin
                                    ILEntry.get(ResEntryPlus."Source Ref. No.");
                                    if ILEntry."Document Type" = ILEntry."Entry Type"::Output then begin
                                        IF ProdOrderNo = '' then
                                            ProdOrderNo := ResEntryPlus."Source ID"
                                        else
                                            ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                        if ProdOrderLineNo = '' then
                                            ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                        else
                                            ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                        TemProdOrder.Reset();
                                        TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                        IF TemProdOrder.isempty THEN BEGIN
                                            TemProdOrder."No." := ResEntryPlus."Source ID";
                                            TemProdOrder.Insert();
                                        END;
                                    end else begin
                                        if ILEntry."Entry Type" = ILEntry."Entry Type"::Transfer then begin
                                            IF TransferOrderNo = '' then
                                                TransferOrderNo := ILEntry."Order No."
                                            else
                                                TransferOrderNo := TransferOrderNo + '|' + ILEntry."Order No.";
                                            if TransferOrderLineNo = '' then
                                                TransferOrderLineNo := FORMAT(ILEntry."Order Line No.")
                                            else
                                                TransferOrderLineNo := TransferOrderLineNo + '|' + FORMAT(ILEntry."Order Line No.");
                                            IF NOT TemTransferOrder.Get(ILEntry."Order No.") THEN BEGIN
                                                TemTransferOrder.Init();
                                                TemTransferOrder."No." := ILEntry."Order No.";
                                                TemTransferOrder.Insert();
                                            END;
                                        end;
                                        //Since the inventory is transfered, the production has been completed. just get related item ledger entry by lot no.                                 IF ILEntry."Lot No." <> '' then begin
                                        OutputILEntry.reset;
                                        OutputILEntry.SetRange("Entry Type", OutputILEntry."Entry Type"::Output);
                                        OutputILEntry.SetRange("Item No.", ILEntry."Item No.");
                                        OutputILEntry.SetRange("Lot No.", ILEntry."Lot No.");
                                        if OutputILEntry.FindFirst() then begin
                                            IF ProdOrderNo = '' then
                                                ProdOrderNo := OutputILEntry."Document No."
                                            else
                                                ProdOrderNo := ProdOrderNo + '|' + OutputILEntry."Document No.";
                                            if ProdOrderLineNo = '' then
                                                ProdOrderLineNo := FORMAT(OutputILEntry."Order Line No.")
                                            else
                                                ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(OutputILEntry."Order Line No.");
                                            TemProdOrder.Reset();
                                            TemProdOrder.SetRange("No.", OutputILEntry."Document No.");
                                            IF TemProdOrder.isempty THEN BEGIN
                                                TemProdOrder."No." := OutputILEntry."Document No.";
                                                TemProdOrder.Insert();
                                            END;
                                        end;
                                    end;
                                end;
                            Database::"Prod. Order Line":
                                begin
                                    IF ProdOrderNo = '' then
                                        ProdOrderNo := ResEntryPlus."Source ID"
                                    else
                                        ProdOrderNo := ProdOrderNo + '|' + ResEntryPlus."Source ID";
                                    if ProdOrderLineNo = '' then
                                        ProdOrderLineNo := FORMAT(ResEntryPlus."Source Prod. Order Line")
                                    else
                                        ProdOrderLineNo := ProdOrderLineNo + '|' + FORMAT(ResEntryPlus."Source Prod. Order Line");
                                    TemProdOrder.Reset();
                                    TemProdOrder.SetRange("No.", ResEntryPlus."Source ID");
                                    IF TemProdOrder.isempty THEN BEGIN
                                        TemProdOrder."No." := ResEntryPlus."Source ID";
                                        TemProdOrder.Insert();
                                    END;
                                end;
                        end;
                    until ResEntryPlus.Next() = 0;
                end;
            until ResEntryMinus.Next() = 0;
        end;
    end;


    trigger OnPreReport()
    var
        OrderListing: Record "RV Order Listing";
        SalesCommentLine: Record "Sales Comment Line";
        SalesLine1: Record "Sales Line";
    begin
        //IF GuiAllowed Then
        //    if NOT Confirm('This action will collect the latest data and overwrite existing data. Do you want to continue?') THEN
        //        EXIT;

        //Update Comment to Sales Comment Line
        OrderListing.reset;
        if OrderListing.FindSet() then begin
            repeat
                SalesCommentLine.SetRange("Document Type", SalesLine1."Document Type"::Order);
                SalesCommentLine.SetRange("No.", OrderListing."Sales Order No.");
                SalesCommentLine.DeleteAll();
                SalesCommentLine.Init();
                SalesCommentLine."Document Type" := SalesLine1."Document Type"::Order;
                SalesCommentLine."No." := OrderListing."Sales Order No.";
                SalesCommentLine.Comment := OrderListing.Comment;
                SalesCommentLine.Insert();
                SalesLine1.reset;
                SalesLine1.SetRange("Document Type", SalesLine1."Document Type"::Order);
                SalesLine1.SetRange("Document No.", OrderListing."Sales Order No.");
                SalesLine1.SetRange("Line No.", OrderListing."Sales Order Line No.");
                IF NOT SalesLine1.FindFirst() or (SalesLine1."Outstanding Quantity" <= 0) then
                    OrderListing.Delete();
            until OrderListing.Next() = 0;
        end;
        OrderListing.Reset();
        IF OrderListing.FindLast() then
            EntryNo := OrderListing."Entry No."
        else
            EntryNo := 0;
        Counts := 0;
    end;

    var

        TransferOrderNo: Text[250];
        TransferOrderLineNo: Text[250];
        ProdOrderNo: Text[250];
        ProdOrderLineNo: Text[250];
        EntryNo: Integer;
        Counts: Integer;
        TemTransferOrder: Record "Transfer Header" temporary;
        TemTransferLine: Record "Transfer Line" temporary;
        TemProdOrder: Record "Production Order" temporary;


}
