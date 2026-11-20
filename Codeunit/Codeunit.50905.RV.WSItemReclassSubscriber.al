/// <summary>
/// Codeunit RV WS Item Reclass. Jnl. Sub. (ID 50905)
/// FDD102 2026/11/20: New. (Shawn)
/// </summary>
codeunit 50905 "RV WS Item Reclass. Jnl. Sub."
{
    [EventSubscriber(ObjectType::Page, Page::"Item Reclass. Journal", 'OnAfterActionEvent', 'Post', false, false)]
    local procedure OnAfterPostItemReclassJournal(var Rec: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        if CopyStr(Rec."Journal Batch Name", 1, 3) = 'WSH' then begin
            if not Confirm('Do you want to delele this Batch?') then
                exit;

            ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
            ItemJnlBatch.Delete(true);

        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Reclass. Journal", 'OnAfterActionEvent', 'Post and &Print', false, false)]
    local procedure OnAfterPostPrintItemReclassJournal(var Rec: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        if CopyStr(Rec."Journal Batch Name", 1, 3) = 'WSH' then begin
            if not Confirm('Do you want to delele this Batch?') then
                exit;

            ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
            ItemJnlBatch.Delete(true);

        end;
    end;
}
