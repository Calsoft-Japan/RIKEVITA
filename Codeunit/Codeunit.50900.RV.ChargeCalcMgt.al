/// <summary>
/// Codeunit RV Charge Calc. Mgt (ID 50900)
/// FDD009 2026/05/01: New. (Shawn)
/// </summary>
codeunit 50900 "RV Charge Calc. Mgt"
{
    trigger OnRun()
    begin
    end;

    var
        Err: Label '';
        ChargeDocNo: Code[20];
        RVSetup: Record "RV RIKEVITA Setup";

        CCHeader: Record "RV Charge Calc. Header";
        CCLine: Record "RV Charge Calc. Line";


    procedure SetDocNo(pDocNo: Code[20])
    begin
        ChargeDocNo := pDocNo;
        CCHeader.Get(ChargeDocNo);
    end;

    procedure CalcCharge()
    var
    begin
        RVSetup.Get();

        case CCHeader."Charge Type" of
            Enum::"RV Charge Type"::FOB:
                begin
                    CalcFOB();
                end;
            Enum::"RV Charge Type"::CNF:
                begin
                    CalcCNF();
                end;
            else begin
                //do nothing.
            end;
        end;
    end;

    local procedure CalcFOB()
    var
    begin

        //Calculate ChargeUOM related fields.
        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        if CCLine.FindSet() then
            repeat
                CCLine.CalcBaseFields();
                CCLine.Modify();
            until CCLine.Next() = 0;

        CCHeader.CalcFields("Total Quantity (KG)");

        if CCLine.FindSet() then
            repeat
                CCLine."01-COO" := Round(CCHeader."01-COO" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."02-FORWARDING" := Round(CCHeader."02-FORWARDING" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."03-FUMIGATION" := Round(CCHeader."03-FUMIGATION" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."04-HEALTH" := Round(CCHeader."04-HEALTH" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."05-PALLETIZING" := Round(CCHeader."05-PALLETIZING" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."06-PHYTO" := Round(CCHeader."06-PHYTO" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."07-STUFFING" := Round(CCHeader."07-STUFFING" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."08-TRANSPORT" := Round(CCHeader."08-TRANSPORT" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."09-REACH" := Round(CCHeader."09-REACH" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."10-Label" := Round(CCHeader."10-Label" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."11-OF" := Round(CCHeader."11-OF" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);
                CCLine."99-OTHERS" := Round(CCHeader."99-OTHERS" * CCLine."Quantity (KG)" / CCHeader."Total Quantity (KG)", 0.00001);

                CCLine."Total Charge (KG)" := Round(CCLine."01-COO"
                                                    + CCLine."02-FORWARDING"
                                                    + CCLine."03-FUMIGATION"
                                                    + CCLine."04-HEALTH"
                                                    + CCLine."05-PALLETIZING"
                                                    + CCLine."06-PHYTO"
                                                    + CCLine."07-STUFFING"
                                                    + CCLine."08-TRANSPORT"
                                                    + CCLine."09-REACH"
                                                    + CCLine."10-Label"
                                                    + CCLine."11-OF"
                                                    + CCLine."99-OTHERS"
                                                    + CCLine."FREIGHT",
                                                    0.00001);

                CCLine.CalcFields("HTP Adjustment Price");
                CCLine."Unit Charge (KG)" := Round(CCLine."Total Charge (KG)" / CCLine."Quantity (KG)" + CCLine."HTP Adjustment Price", 0.00001);
                CCline."HTP Adj. Price (Order Curr.)" := Round(CCLine."HTP Adjustment Price" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."Unit Charge (KG) (Ord Curr.)" := Round(CCLine."Unit Charge (KG)" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCLine."Invoice Unit Price (KG)" := Round(CCLine."Order Unit Price (KG)" + CCLine."Unit Charge (KG) (Ord Curr.)", 0.00001);
                CCLine."Invoice Amount (KG)" := Round(CCLine."Invoice Unit Price (KG)" * CCLine."Quantity (KG)", 0.00001);

                //Calculate Order Currency related fields.
                CCline."01-COO (Order Curr.)" := Round(CCLine."01-COO" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."02-FORWARDING (Order Curr.)" := Round(CCLine."02-FORWARDING" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."03-FUMIGATION (Order Curr.)" := Round(CCLine."03-FUMIGATION" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."04-HEALTH (Order Curr.)" := Round(CCLine."04-HEALTH" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."05-PALLETIZING (Order Curr.)" := Round(CCLine."05-PALLETIZING" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."06-PHYTO (Order Curr.)" := Round(CCLine."06-PHYTO" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."07-STUFFING (Order Curr.)" := Round(CCLine."07-STUFFING" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."08-TRANSPORT (Order Curr.)" := Round(CCLine."08-TRANSPORT" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."09-REACH (Order Curr.)" := Round(CCLine."09-REACH" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."10-Label (Order Curr.)" := Round(CCLine."10-Label" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."11-OF (Order Curr.)" := Round(CCLine."11-OF" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."99-OTHERS (Order Curr.)" := Round(CCLine."99-OTHERS" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCline."FREIGHT (Order Curr.)" := Round(CCLine."FREIGHT" * CCLine."Exch. Rate from Inv. Currency", 0.00001);

                CCLine."Total Charge (KG) (Ord Curr.)" := Round(CCLine."01-COO (Order Curr.)"
                                                                + CCLine."02-FORWARDING (Order Curr.)"
                                                                + CCLine."03-FUMIGATION (Order Curr.)"
                                                                + CCLine."04-HEALTH (Order Curr.)"
                                                                + CCLine."05-PALLETIZING (Order Curr.)"
                                                                + CCLine."06-PHYTO (Order Curr.)"
                                                                + CCLine."07-STUFFING (Order Curr.)"
                                                                + CCLine."08-TRANSPORT (Order Curr.)"
                                                                + CCLine."09-REACH (Order Curr.)"
                                                                + CCLine."10-Label (Order Curr.)"
                                                                + CCLine."11-OF (Order Curr.)"
                                                                + CCLine."99-OTHERS (Order Curr.)"
                                                                + CCLine."FREIGHT (Order Curr.)",
                                                                0.00001);

                CCLine.Modify();
            until CCLine.Next() = 0;


    end;

    local procedure CalcCNF()
    var
        UnitCharge_KG: Decimal;
    begin

        //Calculate ChargeUOM related fields.
        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        if CCLine.FindSet() then
            repeat
                CCLine.CalcBaseFields();
                CCLine.Modify();
            until CCLine.Next() = 0;

        CCHeader.CalcFields("Total Quantity (KG)");

        //all lines are same Unit Charge (KG).
        UnitCharge_KG := Round((CCHeader."Total Cost" + CCHeader.FREIGHT) / CCHeader."Total Quantity (KG)", 0.00001);

        if CCLine.FindSet() then
            repeat
                CCLine."Unit Charge (KG)" := UnitCharge_KG;
                CCline."Unit Charge (KG) (Ord Curr.)" := Round(CCLine."Unit Charge (KG)" * CCLine."Exch. Rate from Inv. Currency", 0.00001);
                CCLine."Invoice Unit Price (KG)" := Round(CCLine."Order Unit Price (KG)" + CCLine."Unit Charge (KG) (Ord Curr.)", 0.00001);
                CCLine."Invoice Amount (KG)" := Round(CCLine."Invoice Unit Price (KG)" * CCLine."Quantity (KG)", 0.00001);
                CCLine.Modify();

            until CCLine.Next() = 0;

    end;

    procedure CarryOutCharge()
    var
    begin
        RVSetup.Get();

        case CCHeader."Charge Type" of
            Enum::"RV Charge Type"::FOB:
                begin
                    CarryOutFOB();
                end;
            Enum::"RV Charge Type"::CNF:
                begin
                    CarryOutCNF();
                end;
            else begin
                //do nothing.
            end;
        end;
    end;


    local procedure CarryOutFOB()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SOPost: Codeunit "Sales-Post";
        SOLastLineNo: Integer;
    begin

        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        CCLine.SetFilter("Total Charge (KG)", '>%1', 0);
        if CCLine.FindSet() then
            repeat
                //Reopen Sales Order if released.
                SalesHeader.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.");
                if SalesHeader.Status = Enum::"Sales Document Status"::Released then begin
                    ReleaseSalesDoc.PerformManualReopen(SalesHeader);
                end;

                //Update the Existing Sales Order Line
                if SalesLine.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.", CCLine."Sales Order Line No.") then begin

                    SalesLine."RV_Freight Charge" := CCLine."FREIGHT (Order Curr.)";
                    SalesLine."RV_Other Charge" := CCLine."Total Charge (KG) (Ord Curr.)" - CCLine."FREIGHT (Order Curr.)";
                    SalesLine.Modify();
                end;

                //Insert New Sales Order Lines for 01-COO - FREIGHT
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Enum::"Sales Document Type"::Order);
                SalesLine.SetRange("Document No.", CCLine."Sales Order No.");
                SalesLine.FindLast();
                SOLastLineNo := SalesLine."Line No.";

                if CCLine."01-COO (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."01-COO");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."01-COO (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."02-FORWARDING (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."02-FORWARDING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."02-FORWARDING (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."03-FUMIGATION (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."03-FUMIGATION");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."03-FUMIGATION (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."04-HEALTH (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."04-HEALTH");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."04-HEALTH (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."05-PALLETIZING (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."05-PALLETIZING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."05-PALLETIZING (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."06-PHYTO (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."06-PHYTO");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."06-PHYTO (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."07-STUFFING (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."07-STUFFING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."07-STUFFING (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."08-TRANSPORT (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."08-TRANSPORT");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."08-TRANSPORT (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."09-REACH (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."09-REACH");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."09-REACH (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."10-Label (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."10-Label");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."10-Label (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."11-OF (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."11-OF");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."11-OF (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."FREIGHT (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."Freight Charge Item No");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."FREIGHT (Order Curr.)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                //Insert New Sales Order Lines for HTP Adjustment
                if CCLine."HTP Adj. Price (Order Curr.)" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."HTP Adjustment");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."HTP Adj. Price (Order Curr.)" * CCLine."Quantity (KG)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                //Post Ship for Created Sales Order Lines
                SalesHeader.Ship := TRUE;
                SalesHeader.Invoice := FALSE;
                Clear(SOPost);
                SOPost.RUN(SalesHeader);

            until CCLine.Next() = 0;

        CCHeader.Status := Enum::"RV Charge Calc. Status"::Completed;
        CCHeader.Modify();

    end;

    local procedure InitFOBSOLine(var pSalesLine: Record "Sales Line"; pLineNo: Integer)
    var
    begin
        pSalesLine.reset();
        pSalesLine.Init();
        pSalesLine."Document Type" := Enum::"Sales Document Type"::Order;
        pSalesLine."Document No." := CCLine."Sales Order No.";
        pSalesLine."Line No." := pLineNo;
        pSalesLine.Validate(Type, Enum::"Sales Line Type"::Item);
    end;

    local procedure CarryOutCNF()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin

        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        CCLine.SetFilter("Invoice Unit Price (KG)", '>%1', 0);
        if CCLine.FindSet() then
            repeat

                //Reopen Sales Order if released.
                SalesHeader.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.");
                if SalesHeader.Status = Enum::"Sales Document Status"::Released then begin
                    ReleaseSalesDoc.PerformManualReopen(SalesHeader);
                end;

                //Update the Existing Sales Order Line
                if SalesLine.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.", CCLine."Sales Order Line No.") then begin

                    SalesLine.Validate("Unit Price", CCLine."Invoice Unit Price (KG)");
                    SalesLine.Modify();
                end;

            until CCLine.Next() = 0;

        CCHeader.Status := Enum::"RV Charge Calc. Status"::Completed;
        CCHeader.Modify();

    end;
}
