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
        CCLine.Reset();
        CCLine.SetRange("Document No.", ChargeDocNo);
        if CCLine.FindSet() then
            repeat
                CCLine.CalcQtyKG();
                CCLine.Modify();
            until CCLine.Next() = 0;

    end;

    local procedure CalcCNF()
    var
    begin

    end;
}
