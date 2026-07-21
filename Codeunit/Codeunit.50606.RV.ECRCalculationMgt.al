/// <summary>
/// Codeunit RV ECR Calculation Mgt (ID 50606)
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
codeunit 50606 "RV ECR Calculation Mgt"
{
    var
        ErrCheckStatus: Label 'The sales line cannot be posted for shipment due to the Sales ECR status is "On-Hold". Sales Order No.: %1,Sales Line No.: %2';
        GDocNo: Code[20];
        GLineNo: Integer;

    [EventSubscriber(ObjectType::table, Database::"Ship-to Address", OnBeforeModifyEvent, '', false, false)]
    procedure ShiptoAddressOnBeforeModifyEvent(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address")
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if rec."Country/Region Code" <> xRec."Country/Region Code" then begin
            rec."RV_Shipment Type" := rec."RV_Shipment Type"::" ";
            rec."RV_Bypass ECR" := false;
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales header", OnBeforeModifyEvent, '', false, false)]
    procedure SalesHeaderOnBeforeModifyEvent(var Rec: Record "Sales header"; var xRec: Record "Sales header")
    var
        SalesLine: Record "Sales Line";
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
    begin
        if (Rec."Sell-to Customer No." <> xRec."Sell-to Customer No.")
        or (Rec."Ship-to Country/Region Code" <> xRec."Ship-to Country/Region Code") then begin
            ECRStatusInfo.SetRange("Sales Order No.", Rec."No.");
            ECRStatusInfo.DeleteAll();
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales header", OnAfterValidateEvent, 'RV_Stuffing Date', false, false)]
    procedure StuffingDateOnAfterValidateEvent(var Rec: Record "Sales header"; var xRec: Record "Sales header")
    var
        SalesLine: Record "Sales Line";
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
    begin
        /*the update should be  run by table validate trigger 
        var
            myInt: Integer;
        begin
            
        end;
        if (Rec."RV_Stuffing Date" <> xRec."RV_Stuffing Date") then begin
            ModifyECRInfo(rec."No.", 0, rec."RV_Stuffing Date", rec."Ship-to Code");
        end;
    */
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales header", OnAfterValidateEvent, 'Ship-to Code', false, false)]
    procedure ShiptoCodeOnAfterValidateEvent(var Rec: Record "Sales header"; var xRec: Record "Sales header")
    var
        SalesLine: Record "Sales Line";
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
        ShiptoAddress: Record "Ship-to Address";
    begin
        if (Rec."Ship-to Code" <> xRec."Ship-to Code") then begin
            ShiptoAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code");
            Rec."RV_Shipment Type" := ShiptoAddress."RV_Shipment Type";
            ModifyECRInfo(rec."No.", 0, rec."RV_Stuffing Date", rec."Ship-to Code");
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnBeforeModifyEvent, '', false, false)]
    procedure SalesLineOnBeforeModifyEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
        tmpDataCal: DateFormula;
    begin
        if (Rec."No." <> xRec."No.")
        or (Rec."RV_ECR Required" <> xRec."RV_ECR Required") then begin
            ECRStatusInfo.SetRange("Sales Order No.", Rec."Document No.");
            ECRStatusInfo.SetRange("SO Line No.", Rec."Line No.");
            ECRStatusInfo.DeleteAll();
        end;

        /* 
                if (not Rec.RV_isNotNew) then begin
                    SalesHeader.get(Rec."Document Type", Rec."Document No.");

                    if SalesHeader."Ship-to Code" <> '' then begin
                        ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code");
                        ShiptoAddress.CalcFields("RV_Sailing Period");

                        if (format(ShiptoAddress."RV_Sailing Period") <> '')
                        and (SalesHeader."RV_Stuffing Date" <> 0D) then begin
                             Evaluate(tmpDataCal, '-' + format(ShiptoAddress."RV_Sailing Period"));
                             //Rec."Shipment Date" := CalcDate(tmpDataCal, SalesHeader."RV_Stuffing Date");
                             Rec.Validate("Shipment Date", CalcDate(tmpDataCal, SalesHeader."RV_Stuffing Date"));
                         end else
                             Rec.Validate("Shipment Date", SalesHeader."RV_Stuffing Date");

                        rec."RV_ECR Required" := ShiptoAddress."RV_Bypass ECR";
                        Rec."RV_ECR Date" := SalesHeader."RV_Stuffing Date";
                        //Rec."RV_Stuffing Date" := SalesHeader."RV_Stuffing Date";
                        Rec.RV_isNotNew := true;
                        
    end;
    end;*/
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnAfterAssignHeaderValues, '', false, false)]
    procedure SalesLineOnAfterAssignHeaderValues(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
        //SalesHeader: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
    begin
        //SalesHeader.get(Rec."Document Type", Rec."Document No.");
        SalesLine."RV_B/L Date" := SalesHeader."RV_B/L Date";
        SalesLine."RV_Closing Date" := SalesHeader."RV_Closing Date";
        SalesLine."RV_ECR Date" := SalesHeader."RV_ECR Date";
        SalesLine.RV_ETA := SalesHeader.RV_ETA;
        SalesLine.RV_ETD := SalesHeader.RV_ETD;
        SalesLine."RV_ECR Date" := SalesHeader."RV_Stuffing Date";
        SalesLine.Validate("RV_Stuffing Date", SalesHeader."RV_Stuffing Date");
        SalesLine.RV_RDD := SalesHeader.RV_RDD;
        ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code");
        SalesLine."RV_ECR Required" := ShiptoAddress."RV_Bypass ECR";
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnBeforeDeleteEvent, '', false, false)]
    procedure SalesLineOnBeforeDeleteEvent(var Rec: Record "Sales Line")
    var
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
    begin
        ECRStatusInfo.SetRange("Sales Order No.", Rec."Document No.");
        ECRStatusInfo.SetRange("SO Line No.", Rec."Line No.");
        ECRStatusInfo.DeleteAll();
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnAfterValidateEvent, "RV_Stuffing Date", false, false)]
    procedure SalesLineOnAfterValidateRVStuffingDateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
        tmpDataCal: DateFormula;
    begin
        if (rec."RV_Stuffing Date" <> xRec."RV_Stuffing Date") then begin
            ValidateSalesLineShipmentDate(Rec, Rec.FieldNo("RV_Stuffing Date"));
            // SalesHeader.get(Rec."Document Type", Rec."Document No.");
            // ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code");
            // ShiptoAddress.CalcFields("RV_Holding Period");

            // if format(ShiptoAddress."RV_Holding Period") <> '' then
            //     Evaluate(tmpDataCal, '-' + format(ShiptoAddress."RV_Holding Period"));
            // Rec."RV_ECR Date" := Rec."RV_Stuffing Date";
            // if Rec."RV_Stuffing Date" <> 0D then
            //     Rec.Validate("Shipment Date", CalcDate(tmpDataCal, Rec."RV_Stuffing Date"))
            // else
            //     rec.Validate("Shipment Date", Rec."RV_Stuffing Date");
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnAfterValidateEvent, "No.", false, false)]
    procedure SalesLineOnAfterValidateNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")

    begin
        if rec."No." <> xrec."No." then begin
            ValidateSalesLineShipmentDate(Rec, Rec.FieldNo("No."));
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales line", OnAfterValidateEvent, "RV_RDD", false, false)]
    procedure SalesLineOnAfterValidateRVRDDEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")

    begin
        if rec."RV_RDD" <> xrec."RV_RDD" then begin
            ValidateSalesLineShipmentDate(Rec, Rec.FieldNo("RV_RDD"));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterTestSalesLine, '', false, false)]
    procedure SalesPostOnAfterPostSalesLineEvent(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WhseShip: Boolean; WhseReceive: Boolean)
    var
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
    begin
        if not SalesHeader.Ship then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if SalesLine.findset() then begin
            repeat
                if ECRStatusInfo.get(SalesHeader."No.", SalesLine."Line No.") then
                    if not ECRStatusInfo."Bypass ECR" then
                        if ECRStatusInfo."ECR Status" = ECRStatusInfo."ECR Status"::"On-Hold" then
                            error(ErrCheckStatus, SalesHeader."No.", SalesLine."Line No.");
            until SalesLine.next() = 0;
        end;
    end;

    procedure ValidateSalesLineShipmentDate(var salesLine: Record "Sales Line"; fieldNo: Integer)
    var
        Item: Record Item;
        SH: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
        RVSetup: Record "RV RIKEVITA Setup";
        tmpDate: date;
        tmpDataCal: DateFormula;
    begin
        SH.get(salesLine."Document Type", salesLine."Document No.");
        RVSetup.Get();
        Item.get(salesLine."No.");

        if fieldNo = salesLine.FieldNo("No.") then begin
            salesLine.RV_RDD := SH.RV_RDD;
            salesLine."RV_Stuffing Date" := SH."RV_Stuffing Date";

            salesLine."RV_ECR Required" := Item."RV_ECR Required";
            salesLine."RV_Closing Date" := SH.RV_RDD;

            if format(RVSetup."Stuffing Date Calculation") <> '' then
                evaluate(tmpDataCal, '-' + format(RVSetup."Stuffing Date Calculation"));

            if salesLine.RV_RDD <> 0D then
                salesLine."RV_Stuffing Date" := CalcDate(tmpDataCal, salesLine.RV_RDD);
        end;

        if fieldNo = salesLine.FieldNo("RV_RDD") then begin
            if format(RVSetup."Stuffing Date Calculation") <> '' then
                evaluate(tmpDataCal, '-' + format(RVSetup."Stuffing Date Calculation"));

            if salesLine.RV_RDD <> 0D then
                salesLine."RV_Stuffing Date" := CalcDate(tmpDataCal, salesLine.RV_RDD);
        end;

        salesLine."RV_ECR Date" := salesLine."RV_Stuffing Date";

        ShiptoAddress.get(SH."Sell-to Customer No.", SH."Ship-to Code");
        ShiptoAddress.CalcFields("RV_Holding Period");

        if salesLine."RV_ECR Required" then begin
            case ShiptoAddress."RV_Shipment Type" of
                ShiptoAddress."RV_Shipment Type"::Air:
                    begin
                        if format(RVSetup."Holding Period for Air") <> '' then
                            evaluate(tmpDataCal, '-' + format(RVSetup."Holding Period for Air"));
                        if salesLine."RV_ECR Date" <> 0D then
                            tmpDate := CalcDate(tmpDataCal, salesLine."RV_ECR Date");
                        if format(Item."RV_ECR Ageing Period") <> '' then
                            evaluate(tmpDataCal, '-' + format(Item."RV_ECR Ageing Period"));
                        if tmpDate <> 0D then begin
                            tmpDate := CalcDate(tmpDataCal, tmpDate);
                            salesLine.Validate("Shipment Date", tmpDate);
                        end;
                    end;
                else begin
                    if format(ShiptoAddress."RV_Holding Period") <> '' then
                        evaluate(tmpDataCal, '-' + format(ShiptoAddress."RV_Holding Period"));
                    if salesLine."RV_ECR Date" <> 0D then
                        tmpDate := CalcDate(tmpDataCal, salesLine."RV_ECR Date");
                    if format(Item."RV_ECR Ageing Period") <> '' then
                        evaluate(tmpDataCal, '-' + format(Item."RV_ECR Ageing Period"));
                    if tmpDate <> 0D then begin
                        tmpDate := CalcDate(tmpDataCal, tmpDate);
                        salesLine.Validate("Shipment Date", tmpDate);
                    end;
                end;
            end;
        end else begin
            if format(Item."RV_ECR Ageing Period") <> '' then
                evaluate(tmpDataCal, '-' + format(Item."RV_ECR Ageing Period"));
            if salesLine."RV_ECR Date" <> 0D then
                tmpDate := CalcDate(tmpDataCal, salesLine."RV_ECR Date");
            if tmpDate <> 0D then
                salesLine.Validate("Shipment Date", tmpDate);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnAfterCheckWhseShptLine, '', false, false)]
    procedure OnAfterCheckWhseShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        ECRStatusInfo: Record "RV Sales ECR Status Info.";
    begin
        if ECRStatusInfo.get(WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.") then
            if not ECRStatusInfo."Bypass ECR" then
                if ECRStatusInfo."ECR Status" = ECRStatusInfo."ECR Status"::"On-Hold" then
                    error(ErrCheckStatus, WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.");
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales Line", OnAfterInsertEvent, '', false, false)]
    local procedure SalesLineOnAfterInsertEvent(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        //SalesHeader.get(Rec."Document Type", Rec."Document No.");
        //ModifyECRInfo(Rec."Document No.", Rec."Line No.", SalesHeader."RV_Stuffing Date", SalesHeader."Ship-to Code");
    end;

    procedure ModifyECRInfo(parDocNo: Code[20]; parLine: Integer; parDate: Date; parShiptoCode: Code[10])
    var
        SalesLine: Record "Sales Line";
        ShiptoAddress: Record "Ship-to Address";
        tmpDataCal: DateFormula;
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", parDocNo);
        if parLine <> 0 then
            SalesLine.SetRange("Line No.", parLine);
        if SalesLine.findset() then
            repeat
                ValidateSalesLineShipmentDate(SalesLine, SalesLine.FieldNo("No."));
                SalesLine.Modify();
            // if ShiptoAddress.get(SalesLine."Sell-to Customer No.", parShiptoCode) then begin
            //     //SalesLine.RV_isNotNew := true;
            //     SalesLine."RV_Stuffing Date" := parDate;
            //     SalesLine."RV_ECR Date" := SalesLine."RV_Stuffing Date";
            //     ShiptoAddress.CalcFields("RV_Holding Period");
            //     if (format(ShiptoAddress."RV_Holding Period") <> '')
            //    and (parDate <> 0D) then begin
            //         Evaluate(tmpDataCal, '-' + format(ShiptoAddress."RV_Holding Period"));
            //         //SalesLine."Shipment Date" := CalcDate(tmpDataCal, parDate);
            //         SalesLine.Validate("Shipment Date", CalcDate(tmpDataCal, parDate));
            //     end else
            //         SalesLine.Validate("Shipment Date", SalesLine."RV_Stuffing Date");
            //     SalesLine."RV_ECR Required" := ShiptoAddress."RV_Bypass ECR";
            //     SalesLine.Modify();
            // end;
            until SalesLine.next() = 0;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales Line", OnAfterUpdateDates, '', false, false)]
    local procedure OnAfterUpdateDates(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ShiptoAddress: Record "Ship-to Address";
        tmpDataCal: DateFormula;
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then begin
            ShiptoAddress.CalcFields("RV_Holding Period");

            if format(ShiptoAddress."RV_Holding Period") <> '' then
                Evaluate(tmpDataCal, '-' + format(ShiptoAddress."RV_Holding Period"));
            SalesLine."RV_ECR Date" := SalesLine."RV_Stuffing Date";
            if SalesLine."RV_Stuffing Date" <> 0D then
                SalesLine.Validate("Shipment Date", CalcDate(tmpDataCal, SalesLine."RV_Stuffing Date"))
            else
                SalesLine.Validate("Shipment Date", SalesLine."RV_Stuffing Date");
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Sales Order Subform", OnNewRecordEvent, '', false, false)]
    procedure SalesOrderSubformOnNewRecordEvent(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.get(Rec."Document Type", Rec."Document No.") then begin
            rec.RV_RDD := SalesHeader.RV_RDD;
            rec."RV_Stuffing Date" := SalesHeader."RV_Stuffing Date";
        end;
    end;
}
