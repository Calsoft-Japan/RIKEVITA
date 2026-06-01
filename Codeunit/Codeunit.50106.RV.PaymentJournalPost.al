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

    [EventSubscriber(ObjectType::Report, Report::Check, OnAfterAssignGenJnlLineDocNoAndAccountType, '', false, false)]
    local procedure Check_OnAfterAssignGenJnlLineDocNoAndAccountType(var GenJnlLine: Record "Gen. Journal Line"; PreviousDocumentNo: Code[20]; ApplyMethod: Option)
    var
        GenLine: Record "Gen. Journal Line";
        BankAcct: Record "Bank Account";
    begin
        GenLine.Reset();
        GenLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenLine.SetRange("Document No.", PreviousDocumentNo);
        if GenLine.FindSet() then begin
            GenJnlLine."RV_Cheque No." := GenLine."RV_Cheque No.";
            GenJnlLine."RV_APV No." := GenLine."RV_APV No.";
        end;

        if (GenJnlLine."Bal. Account Type" = "Gen. Journal Account Type"::"Bank Account") and (GenJnlLine."Bal. Account No." <> '') and BankAcct.Get(GenJnlLine."Bal. Account No.") then
            GenJnlLine."RV_Cheque No." := BankAcct."Last Check No.";
    end;

    [EventSubscriber(ObjectType::Report, Report::Check, OnAfterAssignGenJnlLineDocumentNo, '', false, false)]
    local procedure Check_OnAfterAssignGenJnlLineDocumentNo(var GenJnlLine: Record "Gen. Journal Line"; PreviousDocumentNo: Code[20])
    var
        GenLine: Record "Gen. Journal Line";
        BankAcct: Record "Bank Account";
    begin
        GenLine.Reset();
        GenLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenLine.SetRange("Document No.", PreviousDocumentNo);
        if GenLine.FindSet() then begin
            GenJnlLine."RV_Cheque No." := GenLine."RV_Cheque No.";
            GenJnlLine."RV_APV No." := GenLine."RV_APV No.";
        end;

        if (GenJnlLine."Bal. Account Type" = "Gen. Journal Account Type"::"Bank Account") and (GenJnlLine."Bal. Account No." <> '') and BankAcct.Get(GenJnlLine."Bal. Account No.") then
            GenJnlLine."RV_Cheque No." := BankAcct."Last Check No.";
    end;


    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::CheckManagement, OnBeforeVoidCheckGenJnlLine2Modify, '', false, false)]
    local procedure CheckManagement_OnBeforeVoidCheckGenJnlLine2Modify(var GenJournalLine2: Record "Gen. Journal Line"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
 */
}
