/// <summary>
/// Report RV Calc. Consumption (ID 50600)
/// FDD010 2026/02/23: New. (Stephen)
/// </summary>
report 50600 "RV Calc. Consumption"
{
    Caption = 'Cal. Prod. Journal';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProdOrderLine; "Prod. Order Line")
        {
            DataItemTableView = sorting("Prod. Order No.", "Line No.") where(Status = const(Released));
            RequestFilterFields = "Prod. Order No.";

            trigger OnPreDataItem()
            begin
                RVProdResultJnlLine.Reset();
                RVProdResultJnlLine.SetRange("Batch Name", GBatchName);
                if RVProdResultJnlLine.FindLast() then
                    LastLineNo := RVProdResultJnlLine."Journal Line No.";
            end;

            trigger OnAfterGetRecord()
            begin
                if PlannedOutput then
                    CreateOutputJnlLine();
                if PlannedConsumption then
                    CreateConsumpJnlLine(CalcBasedOn::"Expected Output");
                if AdjustConsumption then
                    CreateConsumpJnlLine(CalcBasedOn::"Actual Output");
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
                    field("Planned Output"; PlannedOutput)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Planned Output';
                    }
                    field("Planned Consumption"; PlannedConsumption)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Planned Consumption';

                        trigger OnValidate()
                        begin
                            AdjustConsumption := not PlannedConsumption;
                        end;
                    }
                    field("Adjust Consumption"; AdjustConsumption)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Adjust Consumption';

                        trigger OnValidate()
                        begin
                            PlannedConsumption := not AdjustConsumption;
                        end;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = CloseAction::OK then
                if not PlannedOutput and not PlannedConsumption and not AdjustConsumption then
                    Error('At least one option must be selected.');
        end;
    }

    var
        CalcBasedOn: Option "Actual Output","Expected Output";
        ReservedFromStock: Enum "Reservation From Stock";
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        LastLineNo: Integer;
        RVProdResultJnlLine: Record "RV Prod. Result Journal Line";
        PlannedOutput: Boolean;
        PlannedConsumption: Boolean;
        AdjustConsumption: Boolean;
        GBatchName: Code[20];

    procedure CreateConsumpJnlLine(parCalcBasedOn: Option "Actual Output","Expected Output")
    var
        ProdOrderComp: Record "Prod. Order Component";
        NeededQty: Decimal;
    begin
        ProdOrderComp.Reset();
        ProdOrderComp.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        ProdOrderComp.SetFilter("Item No.", '<>%1', '');
        if ProdOrderComp.FindSet() then
            repeat
                NeededQty := ProdOrderComp.GetNeededQty(parCalcBasedOn, true);
                if NeededQty <> 0 then begin
                    LastLineNo += 10000;
                    RVProdResultJnlLine.Init();
                    RVProdResultJnlLine."Batch Name" := GBatchName;
                    RVProdResultJnlLine."Journal Line No." := LastLineNo;
                    if parCalcBasedOn = CalcBasedOn::"Expected Output" then
                        RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Planned Consumption"
                    else
                        RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Adjust Consumption";
                    RVProdResultJnlLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                    RVProdResultJnlLine."Item No." := ProdOrderComp."Item No.";

                    RVProdResultJnlLine.Quantity := NeededQty;
                    RVProdResultJnlLine.UOM := ProdOrderComp."Unit of Measure Code";
                    RVProdResultJnlLine."Posting Date" := WorkDate();
                    RVProdResultJnlLine."Prod. Order Line No." := ProdOrderComp."Prod. Order Line No.";
                    RVProdResultJnlLine."Prod. Order Comp. Line No." := ProdOrderComp."Line No.";
                    RVProdResultJnlLine."Location Code" := ProdOrderComp."Location Code";
                    RVProdResultJnlLine."Variant Code" := ProdOrderComp."Variant Code";
                    RVProdResultJnlLine."Bin Code" := ProdOrderComp."Bin Code";
                    RVProdResultJnlLine."Qty. per Unit of Measure" := ProdOrderComp."Qty. per Unit of Measure";
                    RVProdResultJnlLine.Insert();
                end;
            until ProdOrderComp.Next() = 0;
    end;

    procedure CreateOutputJnlLine()
    var
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        ProdOrderRtngLine.Reset();
        ProdOrderRtngLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRtngLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        if ProdOrderRtngLine.FindLast() then begin
            repeat
                LastLineNo += 10000;
                RVProdResultJnlLine.Init();
                RVProdResultJnlLine."Batch Name" := GBatchName;
                RVProdResultJnlLine."Journal Line No." := LastLineNo;
                RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Planned Output";
                RVProdResultJnlLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                RVProdResultJnlLine."Output Item No." := ProdOrderLine."Item No.";
                RVProdResultJnlLine."Operation No." := ProdOrderRtngLine."Operation No.";
                RVProdResultJnlLine."Work Center No." := ProdOrderRtngLine."Work Center No.";

                if not IsLastOperation(ProdOrderRtngLine) then
                    RVProdResultJnlLine.Quantity := 0
                else
                    RVProdResultJnlLine.Quantity := ProdOrderLine."Remaining Quantity";

                RVProdResultJnlLine.UOM := ProdOrderLine."Unit of Measure Code";
                RVProdResultJnlLine."Posting Date" := WorkDate();
                RVProdResultJnlLine."Prod. Order Line No." := ProdOrderLine."Line No.";
                RVProdResultJnlLine."Routing No." := ProdOrderLine."Routing No.";
                RVProdResultJnlLine."Location Code" := ProdOrderLine."Location Code";
                RVProdResultJnlLine."Variant Code" := ProdOrderLine."Variant Code";
                RVProdResultJnlLine."Bin Code" := ProdOrderLine."Bin Code";
                RVProdResultJnlLine."Qty. per Unit of Measure" := ProdOrderLine."Qty. per Unit of Measure";
                RVProdResultJnlLine.Insert();
            until ProdOrderRtngLine.Next() = 0;
        end else begin
            LastLineNo += 10000;
            RVProdResultJnlLine.Init();
            RVProdResultJnlLine."Batch Name" := GBatchName;
            RVProdResultJnlLine."Journal Line No." := LastLineNo;
            RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Planned Output";
            RVProdResultJnlLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
            RVProdResultJnlLine."Output Item No." := ProdOrderLine."Item No.";
            RVProdResultJnlLine.Quantity := ProdOrderLine."Remaining Quantity";
            RVProdResultJnlLine.UOM := ProdOrderLine."Unit of Measure Code";
            RVProdResultJnlLine."Posting Date" := WorkDate();
            RVProdResultJnlLine."Prod. Order Line No." := ProdOrderLine."Line No.";
            RVProdResultJnlLine."Routing No." := ProdOrderLine."Routing No.";
            RVProdResultJnlLine."Location Code" := ProdOrderLine."Location Code";
            RVProdResultJnlLine."Variant Code" := ProdOrderLine."Variant Code";
            RVProdResultJnlLine."Bin Code" := ProdOrderLine."Bin Code";
            RVProdResultJnlLine."Qty. per Unit of Measure" := ProdOrderLine."Qty. per Unit of Measure";
            RVProdResultJnlLine.Insert();
        end;
    end;

    local procedure IsLastOperation(ProdOrderRoutingLine: Record "Prod. Order Routing Line") Result: Boolean
    begin
        Result := ProdOrderRoutingLine."Next Operation No." = '';
    end;

    procedure SetBatchName(BatchName: Code[20])
    begin
        GBatchName := BatchName;
    end;
}
