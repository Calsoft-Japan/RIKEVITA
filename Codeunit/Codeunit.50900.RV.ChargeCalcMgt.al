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
                CCLine.CalcKGFields();
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
                                                    + CCLine."99-OTHERS"
                                                    + CCLine."FREIGHT", 0.00001);

                CCLine.CalcFields("HTP Adjustment Price");
                CCLine."Unit Charge (KG)" := Round(CCLine."Total Charge (KG)" / CCLine."Quantity (KG)" + CCLine."HTP Adjustment Price", 0.00001);

                CCLine.Modify();
            until CCLine.Next() = 0;


    end;

    local procedure CalcCNF()
    var
    begin

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
        SOPost: Codeunit "Sales-Post";
        SOLastLineNo: Integer;
    begin

        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        CCLine.SetFilter("Total Charge (KG)", '>%1', 0);
        if CCLine.FindSet() then
            repeat

                //Update the Existing Sales Order Line
                if SalesLine.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.", CCLine."Sales Order Line No.") then begin

                    SalesLine."RV_Freight Charge" := CCLine.FREIGHT;
                    SalesLine."RV_Other Charge" := CCLine."Total Charge (KG)" - CCLine.FREIGHT;
                    SalesLine.Modify();
                end;

                //Insert New Sales Order Lines for 01-COO - FREIGHT
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Enum::"Sales Document Type"::Order);
                SalesLine.SetRange("Document No.", CCLine."Sales Order No.");
                SalesLine.FindLast();
                SOLastLineNo := SalesLine."Line No.";

                if CCLine."01-COO" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."01-COO");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."01-COO");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."02-FORWARDING" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."02-FORWARDING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."02-FORWARDING");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."03-FUMIGATION" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."03-FUMIGATION");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."03-FUMIGATION");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."04-HEALTH" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."04-HEALTH");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."04-HEALTH");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."05-PALLETIZING" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."05-PALLETIZING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."05-PALLETIZING");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."06-PHYTO" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."06-PHYTO");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."06-PHYTO");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."07-STUFFING" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."07-STUFFING");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."07-STUFFING");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."08-TRANSPORT" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."08-TRANSPORT");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."08-TRANSPORT");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine."09-REACH" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."09-REACH");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."09-REACH");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                if CCLine.FREIGHT > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."Freight Charge Item No");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine.FREIGHT);
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                //Insert New Sales Order Lines for HTP Adjustment
                CCLine.CalcFields("HTP Adjustment Price");
                if CCLine."HTP Adjustment Price" > 0 then begin
                    SOLastLineNo += 10000;
                    InitFOBSOLine(SalesLine, SOLastLineNo);
                    SalesLine.Validate("No.", RVSetup."HTP Adjustment");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", CCLine."HTP Adjustment Price" * CCLine."Quantity (KG)");
                    SalesLine.Validate("Qty. to Ship", 1);
                    SalesLine.Insert(true);
                end;

                //Post Ship for Created Sales Order Lines
                SalesHeader.Get(Enum::"Sales Document Type"::Order, CCLine."Sales Order No.");
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
    begin
    end;
}
