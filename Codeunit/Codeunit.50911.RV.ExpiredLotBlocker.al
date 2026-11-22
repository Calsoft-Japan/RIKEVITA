/// <summary>
/// Codeunit RV Expired Lot Blocker (ID 50911)
/// 2026/11/22: New. (Shawn)
/// </summary>
codeunit 50911 "RV Expired Lot Blocker"
{

    trigger OnRun()
    begin
        LotInfo.SetFilter("Date Filter", '>%1&<=%2', 0D, WorkDate());
        LotInfo.SetFilter("Expired Inventory", '>%1', 0);
        LotInfo.ModifyAll(Blocked, true);
    end;

    var
        LotInfo: Record "Lot No. Information";

}
