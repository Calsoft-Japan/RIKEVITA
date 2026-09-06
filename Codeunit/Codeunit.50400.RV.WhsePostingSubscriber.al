//Stephen 2026/8/12 create subscriber for report 
codeunit 50400 "RV Whse. Posting Subscriber"
{
    //Set the SITE dimension code in the warehouse entry based on the warehouse journal line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnInitWhseEntryCopyFromWhseJnlLine, '', false, false)]
    local procedure SetSITECode(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ProdLine: Record "Prod. Order Line";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        GLSetup: Record "General Ledger Setup";
        ItemJournal: Record "Item Journal Line";
        ProdConsumLine: Record "Prod. Order Component";
    begin
        RIKEVITASetup.Get();
        GLSetup.Get();
        case WarehouseJournalLine."Whse. Document Type" of
            WarehouseJournalLine."Whse. Document Type"::Shipment:
                begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", WarehouseJournalLine."Whse. Document No.");
                    SalesLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                    if SalesLine.FindFirst() then begin
                        if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                            WarehouseEntry."RV_SITE Dim. Code" := SalesLine."Shortcut Dimension 1 Code"
                        else
                            WarehouseEntry."RV_SITE Dim. Code" := SalesLine."Shortcut Dimension 2 Code"
                    end;
                end;
            WarehouseJournalLine."Whse. Document Type"::Receipt:
                begin
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document No.", WarehouseJournalLine."Whse. Document No.");
                    PurchaseLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                    if PurchaseLine.FindFirst() then begin
                        if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                            WarehouseEntry."RV_SITE Dim. Code" := PurchaseLine."Shortcut Dimension 1 Code"
                        else
                            WarehouseEntry."RV_SITE Dim. Code" := PurchaseLine."Shortcut Dimension 2 Code"
                    end;
                end;
            WarehouseJournalLine."Whse. Document Type"::"Whse. Journal":
                begin
                    TransLine.Reset();
                    TransLine.SetRange("Document No.", WarehouseJournalLine."Whse. Document No.");
                    TransLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                    if TransLine.FindFirst() then begin
                        if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                            WarehouseEntry."RV_SITE Dim. Code" := TransLine."Shortcut Dimension 1 Code"
                        else
                            WarehouseEntry."RV_SITE Dim. Code" := TransLine."Shortcut Dimension 2 Code"
                    end;
                end;
            WarehouseJournalLine."Whse. Document Type"::Production:
                begin
                    If WarehouseJournalLine."Source Document" = WarehouseJournalLine."Source Document"::"Output Jnl." then begin
                        ProdLine.Reset();
                        ProdLine.SetRange("Prod. Order No.", WarehouseJournalLine."Whse. Document No.");
                        ProdLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                        if ProdLine.FindFirst() then begin
                            if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                                WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 1 Code"
                            else
                                WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 2 Code"
                        end;
                    end;
                    If WarehouseJournalLine."Source Document" = WarehouseJournalLine."Source Document"::"Consumption Jnl." then begin
                        ProdConsumLine.Reset();
                        ProdConsumLine.SetRange("Prod. Order No.", WarehouseJournalLine."Whse. Document No.");
                        ProdConsumLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                        ProdConsumLine.SetRange("Item No.", WarehouseJournalLine."Item No.");
                        if ProdConsumLine.FindFirst() then begin
                            if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                                WarehouseEntry."RV_SITE Dim. Code" := ProdConsumLine."Shortcut Dimension 1 Code"
                            else
                                WarehouseEntry."RV_SITE Dim. Code" := ProdConsumLine."Shortcut Dimension 2 Code"
                        end else begin
                            ProdLine.Reset();
                            ProdLine.SetRange("Prod. Order No.", WarehouseJournalLine."Whse. Document No.");
                            ProdLine.SetRange("Line No.", WarehouseJournalLine."Whse. Document Line No.");
                            if ProdLine.FindFirst() then begin
                                if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                                    WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 1 Code"
                                else
                                    WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 2 Code"
                            end;
                        end;
                        ;
                    end;
                end;
            WarehouseJournalLine."Whse. Document Type"::" ":
                begin
                    ItemJournal.Reset();
                    ItemJournal.SetRange("Document No.", WarehouseJournalLine."Source No.");
                    ItemJournal.SetRange("Line No.", WarehouseJournalLine."Source Line No.");
                    if ProdLine.FindFirst() then begin
                        if RIKEVITASetup."SITE Dim. Code" = GLSetup."Global Dimension 1 Code" then
                            WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 1 Code"
                        else
                            WarehouseEntry."RV_SITE Dim. Code" := ProdLine."Shortcut Dimension 2 Code"
                    end;
                end;
        end;
    end;
    //Stephen 2026/8/12 check reason code for each line to be posted from Item Journal before posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnCodeOnBeforeItemJnlPostBatchRun, '', false, false)]
    local procedure CheckReasonCode(var ItemJournalLine: Record "Item Journal Line")
    var
        ItemJournalLine2: Record "Item Journal Line";
    begin
        ItemJournalLine2.copy(ItemJournalLine);
        if ItemJournalLine2.FindSet() then begin
            repeat
                if ItemJournalLine2."Reason Code" = '' then
                    If ItemJournalLine2."Journal Template Name" <> 'PROD. ORDE' then
                        Error('Please set reason code for each record.');
            until ItemJournalLine2.Next() = 0;
        end;
    end;
    //Stephen 2026/8/12 check reason code for each line to be posted from Item Journal before posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", OnCodeOnBeforeItemJnlPostBatchRun, '', false, false)]
    local procedure CheckReasonCode2(var ItemJournalLine: Record "Item Journal Line")
    var
        ItemJournalLine2: Record "Item Journal Line";
    begin
        ItemJournalLine2.copy(ItemJournalLine);
        if ItemJournalLine2.FindSet() then begin
            repeat
                if ItemJournalLine2."Reason Code" = '' then
                    If ItemJournalLine2."Journal Template Name" <> 'PROD. ORDE' then
                        Error('Please set reason code for each record.');
            until ItemJournalLine2.Next() = 0;
        end;
    end;
}
