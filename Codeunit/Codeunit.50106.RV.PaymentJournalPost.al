/// <summary>
/// codeunit RV PaymentJournal Post (ID 50106)
/// FDD016 2026/04/19: New. (Liuyang)
/// </summary>
codeunit 50106 "RV PaymentJournal Post"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterSetupNewLine, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterSetupNewLine"(var GenJournalLine: Record "Gen. Journal Line"; GenJournalTemplate: Record "Gen. Journal Template"; GenJournalBatch: Record "Gen. Journal Batch"; LastGenJournalLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    begin
        GenJournalLine."RV_APV No." := GenJournalLine."Document No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeCommit, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnBeforeCommit"(GLRegNo: Integer; var GenJournalLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesLine: Record "No. Series Line";
        NoSeries: Codeunit "No. Series";
    begin
        if GenJournalLine."RV_APV No." = '' then
            exit;

        GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        if NoSeries.GetNoSeriesLine(NoSeriesLine, GenJnlBatch."No. Series", GenJournalLine."Posting Date", false) then begin
            NoSeriesLine."Last No. Used" := GenJournalLine."RV_APV No.";
            NoSeriesLine.Modify();
        end;
        //NoSeries.PeekNextNo(GenJnlBatch."No. Series", GenJournalLine."Posting Date");
    end;

}
