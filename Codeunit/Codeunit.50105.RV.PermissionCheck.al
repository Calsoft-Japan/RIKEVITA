/// <summary>
/// codeunit RV User Permission Check (ID 50105)
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD012 2026/04/19 Liuyang
/// </summary>
codeunit 50105 "RV User Permission Check"
{
    procedure GetCurUserPermission(var AllowContainer: Boolean; var AllowBLDate: Boolean; var AllowClosingDate: Boolean; var AllowStaffingDate: Boolean)
    var
        UsrSetup: Record "User Setup";
    begin
        AllowContainer := false;
        AllowBLDate := false;
        AllowClosingDate := false;
        AllowStaffingDate := false;

        if not UsrSetup.Get(UserId) then
            exit;

        if UsrSetup."RV_Allow Edit of Container No." = "RV EditPermission"::Allowed then
            AllowContainer := true;
        if UsrSetup."RV_Allow Edit of B/L Date" = "RV EditPermission"::Allowed then
            AllowBLDate := true;
        if UsrSetup."RV_Allow Edit of Closing Date" = "RV EditPermission"::Allowed then
            AllowClosingDate := true;
        if UsrSetup."RV_Allow Edit of Stuffing Date" = "RV EditPermission"::Allowed then
            AllowStaffingDate := true;
    end;

}
