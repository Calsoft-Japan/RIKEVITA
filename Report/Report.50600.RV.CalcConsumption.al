/// <summary>
/// Report RV Calc. Consumption (ID 50600)
/// FDD010 2026/02/23: New. (Stephen)
/// </summary>
report 50600 "RV Calc. Consumption"
{
    Caption = 'RV Calc. Consumption';
    ProcessingOnly = true;

    dataset
    {
        dataitem("RV Prod. Result Journal Line"; "RV Prod. Result Journal Line")
        {
            RequestFilterFields = "Batch Name", "Journal Line No.", "Prod. Order No.";
            dataitem("Production Order"; "Production Order")
            {
                DataItemTableView = sorting(Status, "No.") where(Status = const(Released));
                DataItemLink = "No." = field("Prod. Order No.");
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                    RequestFilterFields = "Item No.";

                    trigger OnAfterGetRecord()
                    var
                        NeededQty: Decimal;
                        IsHandled: Boolean;
                    begin
                        NeededQty := GetNeededQtylocal(CalcBasedOn, true);
                        AdjustQtyToReservedFromInventory(NeededQty, ReservedFromStock);
                        CreateConsumpJnlLine("Location Code", "Bin Code", NeededQty);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                RVProdResultJnlLine.Reset();
                RVProdResultJnlLine.SetRange("Batch Name", "RV Prod. Result Journal Line"."Batch Name");
                if RVProdResultJnlLine.FindLast() then
                    LastLineNo := RVProdResultJnlLine."Journal Line No.";
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
                    field(CalcBasedOn; CalcBasedOn)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Calculation Based on';
                        OptionCaption = 'Actual Output,Expected Output';
                        ToolTip = 'Specifies whether the calculation of the quantity to consume is based on the actual output or on the expected output (the quantity of finished goods that you expect to produce). The default value of this field can be set in the Manufacturing Setup.';
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
        trigger OnOpenPage()
        begin
            InitializeRequest(WorkDate(), GetDefaultCalcBasedOn());
        end;
    }

    var
        PostingDate: Date;
        CalcBasedOn: Option "Actual Output","Expected Output";
        ReservedFromStock: Enum "Reservation From Stock";
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        LastLineNo: Integer;
        RVProdResultJnlLine: Record "RV Prod. Result Journal Line";

    procedure InitializeRequest(NewPostingDate: Date; NewCalcBasedOn: Option)
    begin
        PostingDate := NewPostingDate;
        CalcBasedOn := NewCalcBasedOn;
    end;

    local procedure GetDefaultCalcBasedOn(): Option
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if ManufacturingSetup.Get() then
            exit(ManufacturingSetup."Default Consum. Calc. Based on");

        exit(ManufacturingSetup."Default Consum. Calc. Based on"::"Expected Output");
    end;

    procedure CreateConsumpJnlLine(LocationCode: Code[10]; BinCode: Code[20]; OriginalQtyToPost: Decimal)
    var
        Location: Record Location;
        ManufacturingSetup: Record "Manufacturing Setup";
        QtyToPost: Decimal;
        ShouldAdjustQty: Boolean;
    begin
        QtyToPost := OriginalQtyToPost;

        ShouldAdjustQty := "Prod. Order Component"."Flushing Method" in ["Prod. Order Component"."Flushing Method"::"Pick + Manual", "Prod. Order Component"."Flushing Method"::Forward, "Prod. Order Component"."Flushing Method"::"Pick + Forward"];
        if ShouldAdjustQty then begin
            Location.SetLoadFields("Prod. Consump. Whse. Handling");
            if Location.Get(LocationCode) and (Location."Prod. Consump. Whse. Handling" = Location."Prod. Consump. Whse. Handling"::"Warehouse Pick (mandatory)") then
                "Prod. Order Component".AdjustQtyToQtyPicked(QtyToPost);
        end;

        LastLineNo += 10000;
        RVProdResultJnlLine.Init();
        RVProdResultJnlLine."Batch Name" := "RV Prod. Result Journal Line"."Batch Name";
        RVProdResultJnlLine."Journal Line No." := LastLineNo;
        case RVProdResultJnlLine."Data Type" of
            RVProdResultJnlLine."Data Type"::"Adjust Output":
                begin
                    RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Adjust Consumption";
                end;
            RVProdResultJnlLine."Data Type"::"Planned Output":
                begin
                    RVProdResultJnlLine."Data Type" := RVProdResultJnlLine."Data Type"::"Planned Consumption";
                end;
        end;
        RVProdResultJnlLine."Prod. Order No." := "RV Prod. Result Journal Line"."Prod. Order No.";
        RVProdResultJnlLine."Item No." := "Prod. Order Component"."Item No.";
        RVProdResultJnlLine.Quantity := QtyToPost;
        RVProdResultJnlLine.UOM := "Prod. Order Component"."Unit of Measure Code";
        RVProdResultJnlLine."Posting Date" := PostingDate;
        RVProdResultJnlLine."Prod. Order Line No." := "Prod. Order Component"."Prod. Order Line No.";
        RVProdResultJnlLine."Prod. Order Comp. Line No." := "Prod. Order Component"."Line No.";
        RVProdResultJnlLine.Insert();
    end;

    procedure GetNeededQtylocal(CalcBasedOn: Option "Actual Output","Expected Output"; IncludePreviousPosting: Boolean): Decimal
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        CapLedgEntry: Record "Capacity Ledger Entry";
        MfgCostCalcMgt: Codeunit "Mfg. Cost Calculation Mgt.";
        OutputQtyBase: Decimal;
        CompQtyBase: Decimal;
        NeededQty: Decimal;
        RoundingPrecision: Decimal;
        IsHandled: Boolean;
    begin
        Item.Get("Prod. Order Component"."Item No.");
        RoundingPrecision := Item."Rounding Precision";
        if RoundingPrecision = 0 then
            RoundingPrecision := UOMMgt.QtyRndPrecision();

        if CalcBasedOn = CalcBasedOn::"Actual Output" then begin
            ProdOrderLine.Get("Prod. Order Component".Status,
                            "Prod. Order Component"."Prod. Order No.",
                            "Prod. Order Component"."Prod. Order Line No.");

            OutputQtyBase := "RV Prod. Result Journal Line".Quantity;
            CompQtyBase := MfgCostCalcMgt.CalcActNeededQtyBase(ProdOrderLine, "Prod. Order Component", OutputQtyBase);

            NeededQty := UOMMgt.RoundToItemRndPrecision(CompQtyBase / "Prod. Order Component"."Qty. per Unit of Measure", RoundingPrecision);
            exit(NeededQty);
        end;
        exit(Round("Prod. Order Component"."Remaining Quantity", RoundingPrecision));
    end;
}
