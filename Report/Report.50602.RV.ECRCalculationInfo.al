report 50602 "RV ECR Calculation Info"
{
    ApplicationArea = All;
    Caption = 'ECR Info. Refresh';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Salesline; "Sales Line")
        {
            RequestFilterFields = "Document No.", "Line No.";
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const(order));

            trigger OnPreDataItem()
            begin
                Salesline.SetFilter("Outstanding Quantity", '>0');
                Salesline.SetAutoCalcFields("Reserved Quantity");
            end;

            trigger OnAfterGetRecord()
            var
                SalesReservationInfo: Codeunit ReservationEntryMgt;
                ProdLine: Record "Prod. Order Line";
                Item: Record Item;
                tmpDate: date;
                tmpDataCal: DateFormula;
            begin
                Salesheader.get(Salesline."Document Type", Salesline."Document No.");

                if not SalesECRStatusInfo.get(Salesline."Document No.", Salesline."Line No.") then begin
                    SalesECRStatusInfo.init();
                    SalesECRStatusInfo."Sales Order No." := Salesheader."No.";
                    SalesECRStatusInfo."Customer No." := Salesheader."Sell-to Customer No.";
                    SalesECRStatusInfo."SO Line No." := Salesline."Line No.";
                    SalesECRStatusInfo."Item No." := Salesline."No.";
                    SalesECRStatusInfo."Original ECR Date" := Salesline."RV_ECR Date";
                    SalesECRStatusInfo."ECR Required" := Salesline."RV_ECR Required";
                    SalesECRStatusInfo."Bypass ECR" := not Salesline."RV_ECR Required";
                    SalesECRStatusInfo."Shipment Type" := Salesheader."RV_Shipment Type";
                    SalesECRStatusInfo.Insert();
                end;

                SalesECRStatusInfo."Customer Name" := Salesheader."Sell-to Customer Name";
                SalesECRStatusInfo."Item Description" := Salesline.Description;
                // SalesECRStatusInfo."Shipment Method" := Salesheader."Shipment Method Code";
                SalesECRStatusInfo."Shipment Type" := Salesheader."RV_Shipment Type";
                SalesECRStatusInfo."Ship-to Country" := Salesheader."Ship-to Country/Region Code";
                if ShiptoAddress.get(Salesheader."Sell-to Customer No.", Salesheader."Ship-to Code") then begin
                    ShiptoAddress.CalcFields("RV_Holding Category");
                    SalesECRStatusInfo."Sailing Category" := ShiptoAddress."RV_Holding Category";
                end else
                    SalesECRStatusInfo."Sailing Category" := '';


                //ReservEntry.InitSortingAndFilters(true);
                //ECRSetReservationFilters(ReservEntry, Salesline);
                //FindReqLine(ReservEntry);
                Clear(SalesReservationInfo);
                SalesReservationInfo.FindReservationEntry(Salesline);
                SalesReservationInfo.GetProdNoInfo(SalesECRStatusInfo."Prod. Order No.", SalesECRStatusInfo."Prod. Due Date");

                // if SalesECRStatusInfo."Prod. Order No." <> '' then begin
                //     ProdLine.Reset();
                //     ProdLine.SetFilter("Prod. Order No.", SalesECRStatusInfo."Prod. Order No.");
                //     ProdLine.setrange("Item No.", SalesECRStatusInfo."Item No.");
                //     if ProdLine.findfirst() then
                //         SalesECRStatusInfo."Prod. Due Date" := ProdLine."Due Date";
                // end;

                SalesECRStatusInfo."Reservation Quantity" := Salesline."Reserved Quantity";
                SalesECRStatusInfo."Order Quantity" := Salesline."Quantity";
                salesECRStatusInfo."Stuffing Date" := Salesline."RV_Stuffing Date";
                if SalesECRStatusInfo."Prod. Due Date" = 0D then
                    SalesECRStatusInfo."Latest ECR Date" := Salesline."RV_ECR Date"
                else begin
                    if Salesline."RV_ECR Required" then begin
                        case Salesheader."RV_Shipment Type" of
                            Salesheader."RV_Shipment Type"::Air:
                                begin
                                    Item.get(SalesECRStatusInfo."Item No.");
                                    salesECRStatusInfo."ECR Aging Period" := FORMAT(Item."RV_ECR Ageing Period");
                                    if format(RVSetup."Holding Period for Air") <> '' then
                                        evaluate(tmpDataCal, '+' + format(RVSetup."Holding Period for Air"));
                                    tmpDate := CalcDate(tmpDataCal, SalesECRStatusInfo."Prod. Due Date");
                                    if format(Item."RV_ECR Ageing Period") <> '' then
                                        evaluate(tmpDataCal, '+' + format(Item."RV_ECR Ageing Period"));
                                    tmpDate := CalcDate(tmpDataCal, tmpDate);
                                    salesECRStatusInfo."Holding Period" := FORMAT(RVSetup."Holding Period for Air");
                                    SalesECRStatusInfo."Latest ECR Date" := tmpDate;
                                end;
                            Salesheader."RV_Shipment Type"::Land,
                            Salesheader."RV_Shipment Type"::Sea:
                                begin
                                    Item.get(SalesECRStatusInfo."Item No.");
                                    salesECRStatusInfo."ECR Aging Period" := FORMAT(Item."RV_ECR Ageing Period");
                                    ShiptoAddress.CalcFields("RV_Holding Period");
                                    if format(ShiptoAddress."RV_Holding Period") <> '' then
                                        evaluate(tmpDataCal, '+' + format(ShiptoAddress."RV_Holding Period"));
                                    tmpDate := CalcDate(tmpDataCal, SalesECRStatusInfo."Prod. Due Date");
                                    if format(Item."RV_ECR Ageing Period") <> '' then
                                        evaluate(tmpDataCal, '+' + format(Item."RV_ECR Ageing Period"));
                                    tmpDate := CalcDate(tmpDataCal, tmpDate);
                                    salesECRStatusInfo."Holding Period" := FORMAT(ShiptoAddress."RV_Holding Period");
                                    SalesECRStatusInfo."Latest ECR Date" := tmpDate;
                                end;
                        end;
                    end else begin
                        Item.get(SalesECRStatusInfo."Item No.");
                        salesECRStatusInfo."ECR Aging Period" := '';
                        salesECRStatusInfo."Holding Period" := '';
                        if format(Item."RV_ECR Ageing Period") <> '' then
                            evaluate(tmpDataCal, '+' + format(Item."RV_ECR Ageing Period"));
                        tmpDate := CalcDate(tmpDataCal, SalesECRStatusInfo."Prod. Due Date");
                        SalesECRStatusInfo."Latest ECR Date" := tmpDate;
                    end;
                end;
                if Today() > SalesECRStatusInfo."Original ECR Date" then
                    SalesECRStatusInfo.Delayed := true
                else
                    SalesECRStatusInfo.Delayed := false;
                if Today() > SalesECRStatusInfo."Latest ECR Date" then
                    SalesECRStatusInfo."ECR Status" := SalesECRStatusInfo."ECR Status"::Released
                else
                    SalesECRStatusInfo."ECR Status" := SalesECRStatusInfo."ECR Status"::"On-Hold";
                SalesECRStatusInfo.Modify();
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
    trigger onprereport()
    begin
        RVSetup.get();
    end;

    trigger OnPostReport()
    begin
        IsRunedOnce := true;
    end;

    var
        SalesECRStatusInfo: Record "RV Sales ECR Status Info.";
        ReservEntry: Record "Reservation Entry";
        Salesheader: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
        ProdOrderLine: Record "Prod. Order Line";
        ILEntry: Record "Item Ledger Entry";
        LotNoInfo: Record "Lot No. Information";
        IsRunedOnce: Boolean;
        RVSetup: record "RV rikevita setup";

    procedure ECRSetReservationFilters(var ReservEntry: Record "Reservation Entry"; salesLine: Record "Sales Line")
    begin
        ReservEntry.SetSourceFilter(DATABASE::"Sales Line", salesLine."Document Type".AsInteger(), salesLine."Document No.", salesLine."Line No.", false);
        ReservEntry.SetSourceFilter('', 0);
    end;

    procedure getIsRunedOnce(): Boolean
    begin
        exit(IsRunedOnce);
    end;

    procedure FindReqLine(var ResEntrySales: Record "Reservation Entry")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        ReqLineDim1: Record "Requisition Line";
        TransferLine: Record "Transfer Line";

        ResEntryTransfer: Record "Reservation Entry";
        PlanBOM: Record "Planning Component";
    begin
        if ResEntrySales.FindSet() then
            repeat
                if ResEntryPlus.get(ResEntrySales."Entry No.", true) then begin
                    case ResEntryPlus."Source Type" of
                        Database::"Requisition Line":
                            begin
                                if ReqLineDim1.get(ResEntryPlus."Source ID", ResEntryPlus."Source Batch Name", ResEntryPlus."Source Ref. No.") then begin
                                    case ReqLineDim1."Ref. Order Type" of
                                        ReqLineDim1."Ref. Order Type"::"Prod. Order":
                                            begin
                                                PlanBOM.Reset();
                                                PlanBOM.SetRange("Worksheet Template Name", ReqLineDim1."Worksheet Template Name");
                                                PlanBOM.SetRange("Worksheet Batch Name", ReqLineDim1."Journal Batch Name");
                                                PlanBOM.SetRange("Worksheet Line No.", ReqLineDim1."Line No.");
                                                if PlanBOM.FindSet() then
                                                    repeat
                                                        ResEntryMinus.Reset();
                                                        ResEntryMinus.setrange("Source Type", Database::"Planning Component");
                                                        ResEntryMinus.setrange("Source ID", PlanBOM."Worksheet Template Name");
                                                        ResEntryMinus.SetRange("Source Batch Name", PlanBOM."Worksheet Batch Name");
                                                        ResEntryMinus.SetRange("Source Prod. Order Line", PlanBOM."Worksheet Line No.");
                                                        ResEntryMinus.SetRange("Positive", false);
                                                        FindReqLine(ResEntryMinus);
                                                    until PlanBOM.Next() = 0;
                                            end;
                                        ReqLine."Ref. Order Type"::Transfer:
                                            begin
                                                ResEntryMinus.Reset();
                                                ResEntryMinus.setrange("Source Type", Database::"Requisition Line");
                                                ResEntryMinus.setrange("Source ID", ReqLineDim1."Worksheet Template Name");
                                                ResEntryMinus.SetRange("Source Batch Name", ReqLineDim1."Journal Batch Name");
                                                ResEntryMinus.SetRange("Source Ref. No.", ReqLineDim1."Line No.");
                                                ResEntryMinus.SetRange("Positive", false);
                                                FindReqLine(ResEntryMinus);
                                            end;
                                        ReqLine."Ref. Order Type"::Purchase:
                                            begin
                                                ResEntryMinus.Reset();
                                                ResEntryMinus.setrange("Source Type", Database::"Requisition Line");
                                                ResEntryMinus.setrange("Source ID", ReqLineDim1."Worksheet Template Name");
                                                ResEntryMinus.SetRange("Source Batch Name", ReqLineDim1."Journal Batch Name");
                                                ResEntryMinus.SetRange("Source Ref. No.", ReqLineDim1."Line No.");
                                                ResEntryMinus.SetRange("Positive", false);
                                                FindReqLine(ResEntryMinus);
                                            end;
                                    end;
                                end;
                            end;
                        Database::"Transfer Line":
                            begin
                                if TransferLine.get(ResEntryPlus."Source ID", ResEntryPlus."Source Ref. No.") then begin
                                    ResEntryMinus.Reset();
                                    ResEntryMinus.setrange("Source Type", Database::"Transfer Line");
                                    ResEntryMinus.setrange("Source ID", TransferLine."Document No.");
                                    ResEntryMinus.SetRange("Source Ref. No.", TransferLine."Line No.");
                                    ResEntryMinus.SetRange("Positive", false);
                                    FindReqLine(ResEntryMinus);
                                end;
                            end;
                        Database::"Item Ledger Entry":
                            begin
                                ILEntry.get(ResEntryPlus."Source Ref. No.");
                                if LotNoInfo.get(ILEntry."Item No.", ILEntry."Variant Code", ILEntry."Lot No.") then begin
                                    LotNoInfo.CalcFields("RV_Manufacture Date");
                                    SalesECRStatusInfo."Prod. Due Date" := LotNoInfo."RV_Manufacture Date";
                                end;
                            end;
                        Database::"Prod. Order Line":
                            begin
                                SalesECRStatusInfo."Prod. Order No." := ResEntryPlus."Source ID";
                                ProdOrderLine.get(ResEntryPlus."Source Subtype", ResEntryPlus."Source ID", ResEntryPlus."Source Prod. Order Line");
                                SalesECRStatusInfo."Prod. Due Date" := ProdOrderLine."Due Date";
                            end;
                    end;
                end;
            until ResEntrySales.Next() = 0;
    end;
}
