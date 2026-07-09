/// <summary>
/// Codeunit RV Prod. Results Management (ID 50601)
/// FDD011 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50605 "RV MPS Reschedul Update Batch"
{
    TableNo = 50604;
    trigger OnRun()
    begin
        MPSReschedulingLine := Rec;
        UpdateMOData();
    end;

    procedure UpdateMOData()
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RountCount: Integer;
        DiffDays: BigInteger;
        oldSetupTime: Decimal;
        oldRunningTime: Decimal;
        oldWaitTime: Decimal;
        oldMoveTime: Decimal;
        RoutingCount: Integer;
        OldDueDate: Date;
    begin
        MfgSetup.get();
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange("Status", ProdOrderRoutingLine.Status::"Firm Planned");
        ProdOrderRoutingLine.SetRange("Prod. Order No.", MPSReschedulingLine."Production No.");
        ProdOrderRoutingLine.SetRange("Routing No.", MPSReschedulingLine."Routing No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", MPSReschedulingLine."Prod. Line No.");

        RoutingCount := ProdOrderRoutingLine.Count();
        case RoutingCount of
            0:
                begin
                    if (MPSReschedulingLine."New Work Center No. 1" <> '')
                    or (MPSReschedulingLine."New Work Center No. 2" <> '')
                    or (MPSReschedulingLine."New Work Center No. 3" <> '') then
                        Error(ErrNotHaveRouting);
                end;
            1:
                if (MPSReschedulingLine."New Work Center No. 2" <> '')
                or (MPSReschedulingLine."New Work Center No. 3" <> '') then
                    Error(ErrNotHaveRouting);
            2:
                if MPSReschedulingLine."New Work Center No. 3" <> '' then
                    Error(ErrNotHaveRouting);
        end;

        if ProdOrderRoutingLine.FindSet() then
            repeat
                RountCount += 1;
                oldSetupTime := ProdOrderRoutingLine."Setup Time";
                oldRunningTime := ProdOrderRoutingLine."Run Time";
                oldWaitTime := ProdOrderRoutingLine."Wait Time";
                oldMoveTime := ProdOrderRoutingLine."Move Time";
                case RountCount of
                    1:
                        begin
                            if MPSReschedulingLine."new Work Center No. 1" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 1" then begin
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 1");
                                    ProdOrderRoutingLine.Validate("Setup Time", oldSetupTime);
                                    ProdOrderRoutingLine.Validate("Run Time", oldRunningTime);
                                    ProdOrderRoutingLine.Validate("Wait Time", oldWaitTime);
                                    ProdOrderRoutingLine.Validate("Move Time", oldMoveTime);
                                    ProdOrderRoutingLine.Modify();
                                end;
                        end;
                    2:
                        begin
                            if MPSReschedulingLine."new Work Center No. 2" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 2" then begin
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 2");
                                    ProdOrderRoutingLine.Validate("Setup Time", oldSetupTime);
                                    ProdOrderRoutingLine.Validate("Run Time", oldRunningTime);
                                    ProdOrderRoutingLine.Validate("Wait Time", oldWaitTime);
                                    ProdOrderRoutingLine.Validate("Move Time", oldMoveTime);
                                    ProdOrderRoutingLine.Modify();
                                end;
                        end;
                    3:
                        begin
                            if MPSReschedulingLine."new Work Center No. 3" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 3" then begin
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 3");
                                    ProdOrderRoutingLine.Validate("Setup Time", oldSetupTime);
                                    ProdOrderRoutingLine.Validate("Run Time", oldRunningTime);
                                    ProdOrderRoutingLine.Validate("Wait Time", oldWaitTime);
                                    ProdOrderRoutingLine.Validate("Move Time", oldMoveTime);
                                    ProdOrderRoutingLine.Modify();
                                end;
                        end;
                    else
                        ProdOrderRoutingLine.FindLast();
                end;
            until ProdOrderRoutingLine.Next() = 0;
        if MPSReschedulingLine."New Ending Date" <> 0D then begin
            ProdOrder.get(ProdOrder.Status::"Firm Planned", MPSReschedulingLine."Production No.");
            IF MPSReschedulingLine."New Ending Date" > ProdOrder."Due Date" then
                error(Text006, ProdOrder."No.");
            ProdOrder.Validate("RV_Rescheduling Ending Date", MPSReschedulingLine."New Ending Date");
            ProdOrder.Validate("Ending Date-Time", CreateDateTime(MPSReschedulingLine."New Ending Date", MfgSetup."Normal Ending Time"));
            ProdOrder.Modify();
        end;

        if MPSReschedulingLine."New Starting Date" <> 0D then begin
            ProdOrder.get(ProdOrder.Status::"Firm Planned", MPSReschedulingLine."Production No.");
            if ProdOrder."Starting Date" <> MPSReschedulingLine."New Starting Date" then begin
                OldDueDate := ProdOrder."Due Date";
                ProdOrder.Validate("RV_Rescheduling Starting Date", MPSReschedulingLine."New Starting Date");
                ProdOrder.Validate("Manual Scheduling", true);
                ProdOrder.Validate("Starting Date", MPSReschedulingLine."New Starting Date");
                IF prodorder."Due Date" > OldDueDate then
                    error(Text007, ProdOrder."No.");
                ProdOrder.Modify();
            end;
        end;

        ProdOrder.get(ProdOrder.Status::"Firm Planned", MPSReschedulingLine."Production No.");
        if ProdOrder."RV_Planning Status" <> MPSReschedulingLine."Planning Status" then begin
            ProdOrder.Validate("RV_Planning Status", MPSReschedulingLine."Planning Status");
            ProdOrder."RV_Planning Controller" := UserId();
            ProdOrder."RV_Planning Date" := Today();
            ProdOrder.Modify();

            if ProdOrder."RV_Planning Status" = ProdOrder."RV_Planning Status"::Planning then begin
                ProdOrderLine.get(ProdOrderLine.Status::"Firm Planned", MPSReschedulingLine."Production No.", MPSReschedulingLine."Prod. Line No.");
                if ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::Unlimited then begin
                    ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::Unlimited);
                    ProdOrderLine.Modify();
                end;
            end;

            if ProdOrder."RV_Planning Status" = ProdOrder."RV_Planning Status"::Fixed then begin
                ProdOrderLine.get(ProdOrderLine.Status::"Firm Planned", MPSReschedulingLine."Production No.", MPSReschedulingLine."Prod. Line No.");
                if ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::None then begin
                    ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::None);
                    ProdOrderLine.Modify();
                end;
            end;
        end;
        MPSReschedulingLine.Delete();
    end;

    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        Text006: Label 'The new ending date cannot be later than the due date for the production order %1.';
        text007: Label 'The due date will be late for the new starting date for production order %1.';
        MfgSetup: Record "Manufacturing Setup";
        ErrNotHaveRouting: Label 'Not found the production order routing line.';
}
