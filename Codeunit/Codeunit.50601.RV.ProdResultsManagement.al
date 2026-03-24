/// <summary>
/// Codeunit RV Prod. Results Management (ID 50601)
/// FDD010 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50601 "RV Prod. Results Management"
{
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var ProdResultJournalLine: Record "RV Prod. Result Journal Line")
    var
        ProdResultsJnlBatch: Record "RV Prod. Results Journal Bat";
    begin
        Commit();
        ProdResultsJnlBatch.Name := ProdResultJournalLine.GetRangeMax("Batch Name");
        if PAGE.RunModal(0, ProdResultsJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := ProdResultsJnlBatch.Name;
            SetName(CurrentJnlBatchName, ProdResultJournalLine);
        end;
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var ProdResultJournalLine: Record "RV Prod. Result Journal Line")
    begin
        ProdResultJournalLine.FilterGroup := 2;
        ProdResultJournalLine.SetRange("Batch Name", CurrentJnlBatchName);
        ProdResultJournalLine.FilterGroup := 0;
        if ProdResultJournalLine.Find('-') then;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var ProdResultJournalLine: Record "RV Prod. Result Journal Line")
    var
        ProdResultsJnlBatch: Record "RV Prod. Results Journal Bat";
    begin
        ProdResultsJnlBatch.Get(CurrentJnlBatchName);
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var ProdResultJournalLine: Record "RV Prod. Result Journal Line")
    begin
        CheckTemplateName(CurrentJnlBatchName);
        ProdResultJournalLine.FilterGroup := 2;
        ProdResultJournalLine.SetRange("Batch Name", CurrentJnlBatchName);
        ProdResultJournalLine.FilterGroup := 0;
    end;

    local procedure CheckTemplateName(var CurrentJnlBatchName: Code[10])
    var
        ProdResultsJnlBatch: Record "RV Prod. Results Journal Bat";
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

    procedure OpenJnlBatch(var ReqWkshName: Record "RV Prod. Results Journal Bat")
    var
        ReqLine: Record "RV Prod. Result Journal Line";
        JnlSelected: Boolean;
    begin
        ReqWkshName.Find('-');
    end;

    var
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
}
