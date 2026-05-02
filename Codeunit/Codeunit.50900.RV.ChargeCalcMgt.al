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
}
