/// <summary>
/// Codeunit RV Prod. Results Management (ID 50601)
/// FDD011 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50604 "RV MPS Rescheduling Management"
{
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var MPSReschedulingLine: Record "RV MPS Rescheduling Line")
    var
        ProdResultsJnlBatch: Record "RV MPS Rescheduling Batch";
    begin
        Commit();
        ProdResultsJnlBatch.Name := MPSReschedulingLine.GetRangeMax("Batch Name");
        if PAGE.RunModal(0, ProdResultsJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := ProdResultsJnlBatch.Name;
            SetName(CurrentJnlBatchName, MPSReschedulingLine);
        end;
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var MPSReschedulingLine: Record "RV MPS Rescheduling Line")
    begin
        MPSReschedulingLine.FilterGroup := 2;
        MPSReschedulingLine.SetRange("Batch Name", CurrentJnlBatchName);
        MPSReschedulingLine.FilterGroup := 0;
        if MPSReschedulingLine.Find('-') then;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var MPSReschedulingLine: Record "RV MPS Rescheduling Line")
    var
        ProdResultsJnlBatch: Record "RV MPS Rescheduling Batch";
    begin
        ProdResultsJnlBatch.Get(CurrentJnlBatchName);
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var MPSReschedulingLine: Record "RV MPS Rescheduling Line")
    begin
        CheckTemplateName(CurrentJnlBatchName);
        MPSReschedulingLine.FilterGroup := 2;
        MPSReschedulingLine.SetRange("Batch Name", CurrentJnlBatchName);
        MPSReschedulingLine.FilterGroup := 0;
    end;

    local procedure CheckTemplateName(var CurrentJnlBatchName: Code[10])
    var
        ProdResultsJnlBatch: Record "RV MPS Rescheduling Batch";
    begin
        if not ProdResultsJnlBatch.Get(CurrentJnlBatchName) then begin
            if not ProdResultsJnlBatch.FindFirst() then begin
                ProdResultsJnlBatch.Init();
                ProdResultsJnlBatch.Name := Text004;
                ProdResultsJnlBatch.Description := Text005;
                ProdResultsJnlBatch.Insert(true);
                Commit();
            end;
            CurrentJnlBatchName := ProdResultsJnlBatch.Name
        end;
    end;

    procedure OpenJnlBatch(var ReqWkshName: Record "RV MPS Rescheduling Batch")
    var
        ReqLine: Record "RV MPS Rescheduling Line";
        JnlSelected: Boolean;
    begin
        // ReqWkshName.Find('-');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnCalculateProdOrderDatesOnSetBeforeDueDate', '', false, false)]
    procedure OnCalculateProdOrderDatesOnSetBeforeDueDate(var ProdOrderLine: Record "Prod. Order Line"; var IsHandled: Boolean)
    var
        LeadTimeMgt: Codeunit "Lead-Time Management";
        NewDueDate: Date;
    begin
        LeadTimeMgt.SetManualScheduling(ProdOrderLine."Manual Scheduling");
        if ProdOrderLine."Planning Level Code" = 0 then
            NewDueDate :=
              LeadTimeMgt.GetPlannedDueDate(
                ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code",
                ProdOrderLine."Ending Date", '', "Requisition Ref. Order Type"::"Prod. Order")
        else
            NewDueDate := ProdOrderLine."Ending Date";

        if NewDueDate > ProdOrderLine."Due Date" then
            ProdOrderLine."Due Date" := NewDueDate;

        IsHandled := true;
    end;

    procedure ChangeMORVPlanningStatus(var ProdOrder: Record "Production Order"; ChangeTo: Option Fix,Planning)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        case ChangeTo of
            ChangeTo::Fix:
                ProdOrder.SetRange("RV_Planning Status", ProdOrder."RV_Planning Status"::Planning);
            ChangeTo::Planning:
                ProdOrder.SetRange("RV_Planning Status", ProdOrder."RV_Planning Status"::Fixed);
        end;
        if ProdOrder.FindSet() then
            repeat
                case ChangeTo of
                    ChangeTo::Fix:
                        ProdOrder."RV_Planning Status" := ProdOrder."RV_Planning Status"::Fixed;
                    ChangeTo::Planning:
                        ProdOrder."RV_Planning Status" := ProdOrder."RV_Planning Status"::Planning;
                end;
                ProdOrder.Modify();

                ProdOrderLine.Reset();
                ProdOrderLine.SetRange(Status, ProdOrder.Status);
                ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
                if ProdOrderLine.FindSet() then
                    repeat
                        case ChangeTo of
                            changeto::Fix:
                                ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::None);
                            ChangeTo::Planning:
                                ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::Unlimited);
                        end;
                        ProdOrderLine.Modify();
                    until ProdOrderLine.Next() = 0;
            until ProdOrder.Next() = 0;
    end;

    procedure ChangePORVPlanningStatus(var PurchOrder: Record "Purchase Header"; ChangeTo: Option Fix,Planning)
    var
        PurchOrderLine: Record "Purchase Line";
    begin
        case ChangeTo of
            ChangeTo::Fix:
                PurchOrder.SetRange("RV_Planning Status", PurchOrder."RV_Planning Status"::Planning);
            ChangeTo::Planning:
                PurchOrder.SetRange("RV_Planning Status", PurchOrder."RV_Planning Status"::Fixed);
        end;
        if PurchOrder.FindSet() then
            repeat
                case ChangeTo of
                    ChangeTo::Fix:
                        PurchOrder."RV_Planning Status" := PurchOrder."RV_Planning Status"::Fixed;
                    ChangeTo::Planning:
                        PurchOrder."RV_Planning Status" := PurchOrder."RV_Planning Status"::Planning;
                end;
                PurchOrder.Modify();

                PurchOrderLine.Reset();
                PurchOrderLine.SetRange("Document Type", PurchOrder."Document Type");
                PurchOrderLine.SetRange("Document No.", PurchOrder."No.");
                if PurchOrderLine.FindSet() then
                    repeat
                        case ChangeTo of
                            ChangeTo::Fix:
                                PurchOrderLine.Validate("Planning Flexibility", PurchOrderLine."Planning Flexibility"::None);
                            ChangeTo::Planning:
                                PurchOrderLine.Validate("Planning Flexibility", PurchOrderLine."Planning Flexibility"::Unlimited);
                        end;
                        PurchOrderLine.Modify();
                    until PurchOrderLine.Next() = 0;
            until PurchOrder.Next() = 0;
    end;

    var
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
}
