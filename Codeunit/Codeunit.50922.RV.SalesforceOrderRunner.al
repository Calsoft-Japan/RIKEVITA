/// <summary>
/// Codeunit RV Salesforce Order Runner (ID 50922)
/// FDD004 2026/11/10: New. (Shawn)
/// </summary>
codeunit 50922 "RV Salesforce Order Runner"
{

    trigger OnRun()
    begin
        SFMgt.SendtoStaging();
        SFMgt.SendtoTrans();
        SFMgt.Carryout();
    end;

    var
        SFMgt: Codeunit "RV Salesforce Order Mgt";

}
