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
        recCust: Record Customer;
        recShipto: Record "Ship-to Address";
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

                if recSFStaging."Sales Company" = '' then begin
                    recSFTrans."Sell-to Customer No." := recSFStaging."Bill Invoice to(Code)";
                    recSFTrans."Bill-to Customer No." := recSFStaging."Bill Invoice to(Code)";
                    if recSFTrans."Action Type" in [recSFTrans."Action Type"::New, recSFTrans."Action Type"::Cancel] then begin
                        recSFTrans."Ship-to Code" := recSFStaging."End Customer / Ship to(Code)";
                    end else begin
                        recSFTrans."Ship-to Code" := recSFStaging."After Enduser(Code)";
                    end;
                end else begin
                    recCust.Reset();
                    recCust.SetRange(Name, recSFStaging."Sales Company");
                    if recCust.FindFirst() then begin
                        recSFTrans."Bill-to Customer No." := recCust."No.";
                    end;
                    if recSFTrans."Action Type" in [recSFTrans."Action Type"::New, recSFTrans."Action Type"::Cancel] then begin
                        recShipto.Reset();
                        recShipto.SetRange(Name, recSFStaging.Customer);
                        if recShipto.FindFirst() then begin
                            recSFTrans."Sell-to Customer No." := recShipto."Customer No.";
                            recSFTrans."Ship-to Code" := recShipto.Code;
                        end;
                    end else begin
                        recShipto.Reset();
                        recShipto.SetRange(Name, recSFStaging."After Customer");
                        if recShipto.FindFirst() then begin
                            recSFTrans."Sell-to Customer No." := recShipto."Customer No.";
                            recSFTrans."Ship-to Code" := recShipto.Code;
                        end;
                    end
                end;

                if recSFTrans."Action Type" in [recSFTrans."Action Type"::New, recSFTrans."Action Type"::Cancel] then begin

                    recSFTrans."Currency Code" := recSFStaging."Currency Code";
                    recSFTrans."ETA" := recSFStaging."ETA(Request)";
                    recSFTrans."ETD" := recSFStaging."ETD(Request)";
                    recSFTrans."RVM PIC" := recSFStaging."Order PIC";
                    recSFTrans."Salesforce Remarks" := CopyStr(recSFStaging.GetRemarks(), 1, 250);
                    recSFTrans."Item No." := recSFStaging."Product Code1";
                    recSFTrans."Quantity" := recSFStaging."Qty1(kg)";
                    recSFTrans."Unit of Measure Code" := RVSetup."KG Unit Code";
                    recSFTrans."Unit Price" := recSFStaging."Unit Price1(per kg)";
                end else begin

                    recSFTrans."Currency Code" := recSFStaging."After Currency Code";
                    recSFTrans."ETA" := recSFStaging."After ETA(Request)";
                    recSFTrans."ETD" := recSFStaging."After ETD(Request)";
                    recSFTrans."RVM PIC" := recSFStaging."After Order PIC";
                    recSFTrans."Salesforce Remarks" := CopyStr(recSFStaging.GetAfterRemarks(), 1, 250);
                    recSFTrans."Item No." := recSFStaging."After Product Name1(Code)";
                    recSFTrans."Quantity" := recSFStaging."After Qty1(kg)";
                    recSFTrans."Unit of Measure Code" := RVSetup."KG Unit Code";
                    recSFTrans."Unit Price" := recSFStaging."After Unit Price1";
                end;

                recSFTrans.Status := recSFTrans.Status::Interfaced;

                recSFTrans.Insert();

                recSFStaging.Status := recSFStaging.Status::Processed;
                recSFStaging.Modify();

            until recSFStaging.Next() = 0;

    end;

    procedure Carryout()
    var
        recSFTrans: Record "RV Salesforce Order Trans.";
        result: Boolean;
    begin
        RVSetup.Get();

        recSFTrans.Reset();
        recSFTrans.SetRange(Status, recSFTrans.Status::Interfaced);
        if recSFTrans.FindSet() then
            repeat
                case recSFTrans."Action Type" of
                    "RV Salesforce Action Type"::New:
                        begin
                            result := CreateSalesOrder(recSFTrans);
                        end;
                    "RV Salesforce Action Type"::Revise:
                        begin
                            result := ReviseSalesOrder(recSFTrans);
                        end;
                    "RV Salesforce Action Type"::Cancel:
                        begin
                            result := CancelSalesOrder(recSFTrans);
                        end;
                end;

                if result then begin
                    recSFTrans.Status := recSFTrans.Status::"Processed";
                    recSFTrans."Error Message" := '';
                    recSFTrans.Modify();
                end else begin
                    recSFTrans.Status := recSFTrans.Status::"Process Error";
                    recSFTrans."Error Message" := CopyStr(GetLastErrorCode + '. ' + GetLastErrorText, 1, 2048);
                    recSFTrans.Modify();
                end;

            until recSFTrans.Next() = 0;

    end;

    [TryFunction]
    local procedure CreateSalesOrder(pSFTrans: Record "RV Salesforce Order Trans.")
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";

    begin
        recSalesHeader.Init();
        recSalesHeader.Validate("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.Validate("No.", pSFTrans."Order No.");
        recSalesHeader.Insert(true);

        recSalesHeader.Validate("Sell-to Customer No.", pSFTrans."Sell-to Customer No.");
        recSalesHeader.Validate("Bill-to Customer No.", pSFTrans."Bill-to Customer No.");
        recSalesHeader.Validate("Order Date", pSFTrans."Order Date");
        recSalesHeader.Validate("Ship-to Code", pSFTrans."Ship-to Code");
        if pSFTrans."Currency Code" = 'MYR' then begin
            recSalesHeader.Validate("Currency Code", '');
        end else begin
            recSalesHeader.Validate("Currency Code", pSFTrans."Currency Code");
        end;
        recSalesHeader.Validate("RV_ETA", pSFTrans."ETA");
        recSalesHeader.Validate("RV_ETD", pSFTrans."ETD");
        recSalesHeader.Validate("RV_RVM PIC", pSFTrans."RVM PIC");
        recSalesHeader.Validate("RV_Sales Force Remark", pSFTrans."Salesforce Remarks");
        recSalesHeader.Modify(true);

        recSalesLine.Init();
        recSalesLine.Validate("Document Type", recSalesHeader."Document Type");
        recSalesLine.Validate("Document No.", recSalesHeader."NO.");
        recSalesLine.Validate("Line No.", 10000);
        recSalesLine.Insert(true);

        recSalesLine.Validate(Type, recSalesLine.Type::Item);
        recSalesLine.Validate("No.", pSFTrans."Item No.");
        recSalesLine.Validate(Quantity, pSFTrans.Quantity);
        recSalesLine.Validate("Unit of Measure Code", pSFTrans."Unit of Measure Code");
        recSalesLine.Validate("Unit Price", pSFTrans."Unit Price");
        recSalesLine.Modify(true);

    end;

    [TryFunction]
    local procedure ReviseSalesOrder(pSFTrans: Record "RV Salesforce Order Trans.")
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        AfterCurrency: Code[10];
        HeaderChanged: Boolean;
        LineChanged: Boolean;

    begin

        recSalesHeader.Get(recSalesHeader."Document Type"::Order, pSFTrans."Order No.");
        if recSalesHeader."Order Date" <> pSFTrans."Order Date" then begin
            recSalesHeader.Validate("Order Date", pSFTrans."Order Date");
            HeaderChanged := true;
        end;

        if recSalesHeader."Sell-to Customer No." <> pSFTrans."Sell-to Customer No." then begin
            recSalesHeader.Validate("Sell-to Customer No.", pSFTrans."Sell-to Customer No.");
            HeaderChanged := true;
        end;

        if recSalesHeader."Bill-to Customer No." <> pSFTrans."Bill-to Customer No." then begin
            recSalesHeader.Validate("Bill-to Customer No.", pSFTrans."Bill-to Customer No.");
            HeaderChanged := true;
        end;

        if recSalesHeader."Ship-to Code" <> pSFTrans."Ship-to Code" then begin
            recSalesHeader.Validate("Ship-to Code", pSFTrans."Ship-to Code");
            HeaderChanged := true;
        end;

        if pSFTrans."Currency Code" = 'MYR' then begin
            AfterCurrency := '';
        end else begin
            AfterCurrency := pSFTrans."Currency Code";
        end;
        if recSalesHeader."Currency Code" <> AfterCurrency then begin
            recSalesHeader.Validate("Currency Code", AfterCurrency);
            HeaderChanged := true;
        end;

        if recSalesHeader."RV_ETA" <> pSFTrans."ETA" then begin
            recSalesHeader.Validate("RV_ETA", pSFTrans."ETA");
            HeaderChanged := true;
        end;

        if recSalesHeader."RV_ETD" <> pSFTrans."ETD" then begin
            recSalesHeader.Validate("RV_ETD", pSFTrans."ETD");
            HeaderChanged := true;
        end;

        if recSalesHeader."RV_RVM PIC" <> pSFTrans."RVM PIC" then begin
            recSalesHeader.Validate("RV_RVM PIC", pSFTrans."RVM PIC");
            HeaderChanged := true;
        end;

        if recSalesHeader."RV_Sales Force Remark" <> pSFTrans."Salesforce Remarks" then begin
            recSalesHeader.Validate("RV_Sales Force Remark", pSFTrans."Salesforce Remarks");
            HeaderChanged := true;
        end;

        if HeaderChanged then
            recSalesHeader.Modify(true);

        recSalesLine.Get(recSalesLine."Document Type"::Order, pSFTrans."Order No.", 10000);

        if recSalesLine."No." <> pSFTrans."Item No." then begin
            recSalesLine.Validate("No.", pSFTrans."Item No.");
            LineChanged := true;
        end;
        if recSalesLine."Quantity" <> pSFTrans."Quantity" then begin
            recSalesLine.Validate(Quantity, pSFTrans.Quantity);
            LineChanged := true;
        end;
        if recSalesLine."Unit Price" <> pSFTrans."Unit Price" then begin
            recSalesLine.Validate("Unit Price", pSFTrans."Unit Price");
            LineChanged := true;
        end;

        if LineChanged then
            recSalesLine.Modify(true);

    end;

    [TryFunction]
    local procedure CancelSalesOrder(pSFTrans: Record "RV Salesforce Order Trans.")
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        ItemNoMatchErr: Label 'The Item No. is not match.';

    begin
        recSalesLine.Get(recSalesLine."Document Type"::Order, pSFTrans."Order No.", 10000);
        if recSalesLine."No." <> pSFTrans."Item No." then begin
            Error(ItemNoMatchErr);
        end;
        recSalesLine.Validate(Quantity, 0);
        recSalesLine.Modify(true);
    end;
}
