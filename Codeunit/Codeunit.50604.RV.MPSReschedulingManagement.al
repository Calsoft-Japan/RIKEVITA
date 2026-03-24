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
        ReqWkshName.Find('-');
    end;

    var
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
}
