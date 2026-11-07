/// <summary>
/// Codeunit RV Salesforce Order Mgt (ID 50921)
/// FDD028 2026/11/07: New. (Shawn)
/// </summary>
codeunit 50921 "RV Salesforce Order Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        RVSetup: Record "RV RIKEVITA Setup";

    procedure SendtoStaging()
    var
        recSFBuffer: Record "RV Salesforce Order Buffer";
        recSFStaging: Record "RV Salesforce Order Staging";
    begin
        RVSetup.Get();

        recSFBuffer.Reset();
        if recSFBuffer.FindSet() then
            repeat
                recSFStaging.Init();
                recSFStaging.TransferFields(recSFBuffer);
                recSFStaging.Insert();
            until recSFBuffer.Next() = 0;

    end;

    procedure SendtoTrans()
    var
        recSFStaging: Record "RV Salesforce Order Staging";
        recSFTrans: Record "RV Salesforce Order Trans.";
    begin
        RVSetup.Get();

        recSFStaging.Reset();
        recSFStaging.SetRange(Status, recSFStaging.Status::Interfaced);
        if recSFStaging.FindSet() then
            repeat
                recSFTrans.Init();
                recSFTrans."Staging Entry No." := recSFStaging."Entry No.";

                if recSFStaging."Sales Company" = '' then begin
                    recSFTrans."Transaction Type" := recSFTrans."Transaction Type"::"Local Order";
                end else begin
                    recSFTrans."Transaction Type" := recSFTrans."Transaction Type"::"Oversea Order";
                end;

                recSFTrans."Action Type" := recSFStaging."Action Type";
                recSFTrans."Order No." := recSFStaging."PCN No.";
                recSFTrans."CR No." := recSFStaging."CR No.";
                recSFTrans."Order Date" := recSFStaging."Order Date";

                recSFTrans."Sell-to Customer No." := recSFStaging."Bill Invoice to(Code)";
                recSFTrans."Bill-to Customer No." := recSFStaging."Bill Invoice to(Code)";
                recSFTrans."Ship-to Code" := recSFStaging."End Customer / Ship to(Code)";

                recSFTrans."Currency Code" := recSFStaging."Currency Code";
                recSFTrans."ETA" := recSFStaging."ETA(Request)";
                recSFTrans."ETD" := recSFStaging."ETD(Request)";
                recSFTrans."RVM PIC" := recSFStaging."Order PIC";
                recSFTrans."Salesforce Remarks" := CopyStr(recSFStaging.GetRemarks(), 1, 250);
                recSFTrans."Item No." := recSFStaging."Product Code1";
                recSFTrans."Quantity" := recSFStaging."Qty1(kg)";
                recSFTrans."Unit of Measure Code" := RVSetup."KG Unit Code";
                recSFTrans."Unit Price" := recSFStaging."Unit Price1(per kg)";
                recSFTrans.Status := recSFTrans.Status::Interfaced;

                recSFTrans.Insert();
            until recSFStaging.Next() = 0;

    end;

}
