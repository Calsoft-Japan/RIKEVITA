/// <summary>
/// Report RV Collect MPS Data (ID 50601)
/// FDD011 2026/02/23: New. (Stephen)
/// </summary>
report 50601 "RV Collect MPS Data"
{
    ApplicationArea = All;
    Caption = 'Collect MPS Data';
    ProcessingOnly = true;
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.") where(Status = const("Firm Planned"));
            RequestFilterFields = "RV_Planning Controller",
                                  "RV_Planning Status";
            dataitem("Prod. Order Line";
            "Prod. Order Line")
            {
                DataItemLink = status = field(status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting("Line No.");

                trigger OnAfterGetRecord()
                var
                    RountCounter: Integer;
                begin
                    LastLineNo += 10000;
                    MPSReschedulingLine.Init();
                    MPSReschedulingLine."Batch Name" := GBatch;
                    MPSReschedulingLine."batch Line No." := LastLineNo;
                    MPSReschedulingLine."Production No." := "Production Order"."No.";
                    MPSReschedulingLine."Item No." := "Prod. Order Line"."Item No.";
                    MPSReschedulingLine.Quantity := "Prod. Order Line".Quantity;
                    MPSReschedulingLine."Starting Date" := DT2DATE("Prod. Order Line"."Starting Date-Time");
                    MPSReschedulingLine."Ending Date" := DT2DATE("Prod. Order Line"."Ending Date-Time");
                    MPSReschedulingLine."Due Date" := "Prod. Order Line"."Due Date";
                    MPSReschedulingLine."Routing No." := "Prod. Order Line"."Routing No.";
                    MPSReschedulingLine."Planning Status" := "Production Order"."RV_Planning Status";
                    MPSReschedulingLine."Prod. Line No." := "Prod. Order Line"."Line No.";
                    TemSalesOrder.Reset();
                    TemSalesOrder.deleteall();
                    tempProdOrderLine.Reset();
                    tempProdOrderLine.deleteall();
                    FindReservationEntry("Prod. Order Line");
                    TemSalesOrder.Reset();
                    if TemSalesOrder.FindSet() then
                        repeat
                            if MPSReschedulingLine."Sales Order No." = '' then
                                MPSReschedulingLine."Sales Order No." := TemSalesOrder."No."
                            else
                                MPSReschedulingLine."Sales Order No." := MPSReschedulingLine."Sales Order No." + '|' + TemSalesOrder."No.";

                            SalesLine.Reset;
                            SalesLine.setrange("Document Type", SalesLine."Document Type"::Order);
                            SalesLine.SetRange("Document No.", TemSalesOrder."No.");
                            if SalesLine.Findfirst() then
                                if MPSReschedulingLine."Sales Order Line No." <> SalesLine."Line No." then
                                    MPSReschedulingLine."Sales Order Line No." := SalesLine."Line No.";

                        until TemSalesOrder.Next() = 0;

                    tempProdOrderLine.Reset();
                    tempProdOrderLine.SetCurrentKey("Line No.");
                    tempProdOrderLine.SetAscending("Line No.", false);
                    if tempProdOrderLine.findfirst() then
                        MPSReschedulingLine."FG Prod. Order No." := tempProdOrderLine."Prod. Order No.";

                    MPSReschedulingLine.Insert();

                    ProdOrderRoutingLine.Reset();
                    ProdOrderRoutingLine.SetRange(Status, "Prod. Order Line"."Status");
                    ProdOrderRoutingLine.SetRange("Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                    ProdOrderRoutingLine.SetRange("Routing Reference No.", "Prod. Order Line"."Line No.");
                    if ProdOrderRoutingLine.FindSet() then begin
                        repeat
                            RountCounter += 1;
                            case RountCounter of
                                1:
                                    MPSReschedulingLine."Work Center No. 1" := ProdOrderRoutingLine."No.";
                                2:
                                    MPSReschedulingLine."Work Center No. 2" := ProdOrderRoutingLine."No.";
                                3:
                                    MPSReschedulingLine."Work Center No. 3" := ProdOrderRoutingLine."No.";
                                else
                                    ProdOrderRoutingLine.FindLast();
                            end;
                        until ProdOrderRoutingLine.Next() = 0;
                        MPSReschedulingLine.Modify();
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                if (StartingDate <> 0D)
               And (EndingDate <> 0D) then begin
                    SetFilter("Starting Date", '%1..', StartingDate);
                    //setFilter("Ending Date", '..%1', EndingDate);
                    setFilter("Starting Date", '..%1', EndingDate);
                end else
                    if (StartingDate <> 0D) then
                        SetFilter("Starting Date", '%1..', StartingDate)
                    else if (EndingDate <> 0D) then
                        //setFilter("Ending Date", '..%1', EndingDate);
                        setFilter("Starting Date", '..%1', EndingDate);

                MPSReschedulingLine.Reset();
                MPSReschedulingLine.SetRange("Batch Name", GBatch);
                if MPSReschedulingLine.FindLast() then
                    LastLineNo := MPSReschedulingLine."batch Line No.";
            end;
        }
    }
    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'General';
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Production Starting Date From';
                        ApplicationArea = All;
                    }
                    field(EndingDate; EndingDate)
                    {
                        Caption = 'Production Starting Date To';
                        ApplicationArea = All;
                    }

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = Action::OK then begin
                if (StartingDate = 0D)
               and (EndingDate = 0D) then
                    Error(ErrDateBlank);
                IF (EndingDate <> 0D)
                    and (StartingDate > EndingDate) then
                    Error(ErrStartDateAfterEndDate);
            end;
        end;
    }

    trigger OnPostReport()
    begin
        Message(MsgProcessFinish);
    end;

    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        GBatch: Code[10];
        LastLineNo: Integer;
        StartingDate: Date;
        EndingDate: Date;
        ErrDateBlank: label 'Both Starting Date and Ending Date cannot be blank.';
        ErrStartDateAfterEndDate: label 'Starting Date cannot be later than Ending Date.';
        MsgProcessFinish: label 'MPS data collection is completed.';
        TemSalesOrder: Record "Sales Header" temporary;
        TempProdOrderLine: Record "Prod. Order Line" temporary;
        LevelNo: Integer;
        SalesLine: Record "Sales Line";

    procedure SetBatchName(BatchName: Code[10])
    begin
        GBatch := BatchName;
    end;

    procedure FindReservationEntry(var ProdLine: Record "Prod. Order Line")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        TransferLine: Record "Transfer Line";
    begin
        ResEntryPlus.Reset();
        ResEntryPlus.setrange("Source Type", 5406);
        ResEntryPlus.SetRange("source subtype", ProdLine.Status);
        ResEntryPlus.setrange("Source ID", ProdLine."Prod. Order No.");
        ResEntryPlus.SetRange("Source Prod. Order Line", ProdLine."Line No.");
        ResEntryPlus.SetRange("Positive", true);
        if ResEntryPlus.FindSet() then begin
            LevelNo += 1;
            TempProdOrderLine.Init();
            TempProdOrderLine."Prod. Order No." := ProdLine."Prod. Order No.";
            TempProdOrderLine."Line No." := LevelNo;
            TempProdOrderLine.insert();
            repeat
                ResEntryMinus.Reset();
                ResEntryMinus.SetRange("Entry No.", ResEntryPlus."Entry No.");
                ResEntryMinus.SetRange("Positive", false);
                if ResEntryMinus.FindFirst() then begin
                    case ResEntryMinus."Source Type" of
                        Database::"Requisition Line":
                            begin
                                FindTransferLineReservationEntry(ResEntryMinus);
                            end;
                        Database::"Transfer Line":
                            begin
                                FindTransferLineReservationEntry(ResEntryMinus);
                            end;
                        Database::"Prod. Order Component":
                            begin
                                FindTransferLineReservationEntry(ResEntryMinus);
                            end;
                        database::"Planning Component":
                            begin
                                FindTransferLineReservationEntry(ResEntryMinus);
                            end;
                        Database::"Sales Line":
                            begin
                                TemSalesOrder.Reset();
                                TemSalesOrder.SetRange("No.", ResEntryMinus."Source ID");
                                IF TemSalesOrder.isempty THEN BEGIN
                                    TemSalesOrder.init();
                                    TemSalesOrder."Document Type" := TemSalesOrder."Document Type"::Order;
                                    TemSalesOrder."No." := ResEntryMinus."Source ID";
                                    TemSalesOrder.Insert();
                                END;
                            end;
                    end;
                end;
            until ResEntryPlus.Next() = 0;
        end else begin
            LevelNo += 1;
            TempProdOrderLine.Init();
            TempProdOrderLine."Prod. Order No." := ProdLine."Prod. Order No.";
            TempProdOrderLine."Line No." := LevelNo;
            TempProdOrderLine.insert();
        end;
    end;

    procedure FindTransferLineReservationEntry(var TransResEntryMinus: Record "Reservation Entry")
    var
        ResEntryPlus: Record "Reservation Entry";
        ResEntryMinus: Record "Reservation Entry";
        ReqLineDataType: Record "Requisition Line";
        TransferLine: Record "Transfer Line";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ResEntryPlus.Reset();
        case TransResEntryMinus."Source Type" of
            5741://Transfer Order Line
                BEGIN
                    ResEntryPlus.setrange("Source Type", 5741);
                    ResEntryPlus.setrange("Source ID", TransResEntryMinus."Source ID");
                    ResEntryPlus.SetRange("Source Ref. No.", TransResEntryMinus."Source Ref. No.");
                end;
            246://Requisition Line
                begin
                    ResEntryPlus.setrange("Source Type", 246);
                    ResEntryPlus.setrange("Source ID", TransResEntryMinus."Source ID");
                    ResEntryPlus.SetRange("Source Batch Name", TransResEntryMinus."Source Batch Name");
                    ResEntryPlus.SetRange("Source Ref. No.", TransResEntryMinus."Source Ref. No.");
                end;
            99000829://Planning Component
                begin
                    ResEntryPlus.setrange("Source Type", 246);
                    ResEntryPlus.setrange("Source ID", TransResEntryMinus."Source ID");
                    ResEntryPlus.SetRange("Source Batch Name", TransResEntryMinus."Source Batch Name");
                    ResEntryPlus.SetRange("Source Ref. No.", TransResEntryMinus."Source Prod. Order Line");

                    if ReqLineDataType.get(ResEntryMinus."Source ID", ResEntryMinus."Source Batch Name", ResEntryMinus."Source Ref. No.") then begin
                        case ReqLineDataType."Ref. Order Type" of
                            ReqLineDataType."Ref. Order Type"::"Prod. Order":
                                begin
                                    LevelNo += 1;
                                    TempProdOrderLine.Init();
                                    TempProdOrderLine."Prod. Order No." := ReqLineDataType."Ref. Order No.";
                                    TempProdOrderLine."Line No." := LevelNo;
                                    TempProdOrderLine.insert();
                                end;
                        end;
                    end;
                end;
            5407://Prod. Order Component
                begin
                    ResEntryPlus.setrange("Source Type", 5406);
                    ResEntryPlus.setrange("Source ID", TransResEntryMinus."Source ID");
                    ResEntryPlus.SetRange("Source Prod. Order Line", TransResEntryMinus."Source Prod. Order Line");

                    if ProdOrderLine.get(TransResEntryMinus."Source Subtype",
                                            TransResEntryMinus."Source ID",
                                            TransResEntryMinus."Source Prod. Order Line") then begin
                        LevelNo += 1;
                        TempProdOrderLine.Init();
                        TempProdOrderLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                        TempProdOrderLine."Line No." := LevelNo;
                        TempProdOrderLine.insert();
                    end;
                end;
        end;
        ResEntryPlus.SetRange("Positive", true);
        if ResEntryPlus.findset then begin
            repeat
                ResEntryMinus.Reset();
                ResEntryMinus.setrange("Entry No.", ResEntryPlus."Entry No.");
                ResEntryMinus.setrange("Positive", false);
                if ResEntryMinus.FindSet() then begin
                    repeat
                        case ResEntryMinus."Source Type" of
                            Database::"Requisition Line":
                                begin
                                    if ReqLineDataType.get(ResEntryMinus."Source ID", ResEntryMinus."Source Batch Name", ResEntryMinus."Source Ref. No.") then begin
                                        case ReqLineDataType."Ref. Order Type" of
                                            //just do tranfer order case, because may be the production order has been created but transfer order is not created.
                                            ReqLineDataType."Ref. Order Type"::Transfer:
                                                FindTransferLineReservationEntry(ResEntryMinus);
                                        end;
                                    end;
                                end;
                            Database::"Transfer Line":
                                begin
                                    FindTransferLineReservationEntry(ResEntryMinus);
                                end;
                            Database::"Prod. Order Component":
                                begin
                                    FindTransferLineReservationEntry(ResEntryMinus);
                                end;
                            database::"Planning Component":
                                begin
                                    FindTransferLineReservationEntry(ResEntryMinus);
                                end;
                            Database::"Sales Line":
                                begin
                                    TemSalesOrder.Reset();
                                    TemSalesOrder.SetRange("No.", ResEntryMinus."Source ID");
                                    IF TemSalesOrder.isempty THEN BEGIN
                                        TemSalesOrder.init();
                                        TemSalesOrder."Document Type" := TemSalesOrder."Document Type"::Order;
                                        TemSalesOrder."No." := ResEntryMinus."Source ID";
                                        TemSalesOrder.Insert();
                                    END;
                                end;
                        end;
                    until ResEntryMinus.Next() = 0;
                end;
            until ResEntryPlus.next = 0;
        end;
    end;
}
