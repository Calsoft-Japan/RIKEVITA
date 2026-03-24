/// <summary>
/// Codeunit RV BOM Permission Check (ID 50601)
/// FDD014 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50600 "RV Check BOM Access "
{
    /// <summary>
    /// FDD014 
    /// check if the user has access to the production BOM. If not, an error message will be shown and the user will not be able to access the production BOM.
    /// </summary>
    /// <param name="ProductionBOMNo"></param>
    procedure CheckBOMAccess(ProductionBOMNo: Code[20])
    var
        BOMHeader: Record "Production BOM Header";
    begin
        UserSetup.get(UserId);
        if BOMHeader.Get(ProductionBOMNo) then
            if BOMHeader."RV Highly Restricted BOM" then
                if not UserSetup."RV Acc Highly Restricted BOM" then
                    Error(PermissionErrorMsg, ProductionBOMNo);
    end;

    var
        UserSetup: Record "User Setup";
        PermissionErrorMsg: Label 'You do not have permission to access this Production BOM %1. Please contact the system administrator.';

}
