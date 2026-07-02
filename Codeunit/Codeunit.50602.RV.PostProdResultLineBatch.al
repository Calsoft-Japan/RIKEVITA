/// <summary>
/// Codeunit RV Post Results Line  Batch (ID 50602)
/// FDD010 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50602 "RV Post Prod Result Line Batch"
{
    trigger OnRun()
    begin
        if guiAllowed() then
            if not Confirm(StrSubstNo(ConfirmMsg, GbatchName), false) then
                exit;

        //run process group by each production order no. and production order line no.
        if GFromPage then
            QueryProdResultLine.SetFilter(Status, '%1|%2', QueryProdResultLine.Status::Preparing, QueryProdResultLine.Status::"Ready Post")
        else
            QueryProdResultLine.setrange(Status, QueryProdResultLine.Status::"Ready Post");
        if GbatchName <> '' then
            QueryProdResultLine.SetRange(Batch_Name, GbatchName);
        QueryProdResultLine.Open();
        while QueryProdResultLine.Read() do begin
            Commit();
            RVPostProdResultLine.Reset();
            RVPostProdResultLine.SetRange("Batch Name", QueryProdResultLine.Batch_Name);
            if GFromPage then
                RVPostProdResultLine.SetFilter(Status, '%1|%2', QueryProdResultLine.Status::Preparing, QueryProdResultLine.Status::"Ready Post")
            else
                RVPostProdResultLine.setrange(Status, QueryProdResultLine.Status::"Ready Post");
            RVPostProdResultLine.SetRange("Prod. Order No.", QueryProdResultLine.ProdOrderNo);
            RVPostProdResultLine.SetRange("Prod. Order Line No.", QueryProdResultLine.ProdOrderLineNo);
            if not CURVPostProdResultLine.Run(RVPostProdResultLine) then begin
                RVPostProdResultLine.ModifyAll("Error Message", GetLastErrorText());
                RVPostProdResultLine.ModifyAll(Status, RVPostProdResultLine.Status::"Post Error");
            end;
        end;

        if guiAllowed() then
            message(PostedMsg, GbatchName);
    end;

    var
        QueryProdResultLine: Query "RV Prod. Result Journal Line G";
        CURVPostProdResultLine: Codeunit "RV Post Prod Result Line Proc.";
        RVPostProdResultLine: Record "RV Prod. Result Journal Line";
        GbatchName: Code[20];
        GFromPage: Boolean;
        ConfirmMsg: Label 'Are you sure you want to post the production result journal lines in batch %1?';
        PostedMsg: Label 'Production result journal lines in batch %1 have been posted.';

    procedure SetBatchName(parBatchName: Code[20]; parFromPage: Boolean)
    begin
        GbatchName := parBatchName;
        GFromPage := parFromPage;
    end;
}
