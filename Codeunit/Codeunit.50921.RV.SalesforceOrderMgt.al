/// <summary>
/// Codeunit RV Salesforce Order Mgt (ID 50921)
/// FDD028 2026/11/07: New. (Shawn)
/// </summary>
codeunit 50921 "RV Salesforce Order Mgt"
{

    trigger OnRun()
    begin
    end;

    procedure SendtoStaging()
    var
        recSFBuffer: Record "RV Salesforce Order Buffer";
        recSFStaging: Record "RV Salesforce Order Staging";
    begin
        recSFBuffer.Reset();
        if recSFBuffer.FindSet() then
            repeat
                recSFStaging.Init();
                recSFStaging.TransferFields(recSFBuffer);
                recSFStaging.Insert();
            until recSFBuffer.Next() = 0;

    end;

}
