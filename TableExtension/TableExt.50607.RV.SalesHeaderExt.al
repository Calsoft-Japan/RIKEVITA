/// <summary>
/// TableExtension RV Sales Header (ID 50607) extends Sales Header table
/// FDD006 2026/03/31: New. (Stephen)
/// FDD012 2026/04/19: Liuyang.
/// </summary>
tableextension 50607 "RV_Sales Header" extends "Sales Header"
{
    fields
    {
        field(50100; "RV_B/L Date"; Date)
        {
            Caption = 'B/L Date';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    if Confirm('You have modified the field B/L Date. Do you want to update the line?') then begin
                        repeat
                            SalesLine."RV_B/L Date" := "RV_B/L Date";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
            end;
        }
        field(50101; "RV_Cosing Date"; Date)
        {
            Caption = 'Cosing Date';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                RVSteup: Record "RV RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                Clear(DateFormulaVar);

                if Rec."RV_Cosing Date" = 0D then begin
                    "RV_Stuffing Date" := 0D;
                end else begin
                    RVSteup.Reset();
                    if RVSteup.FindFirst() then begin
                        DateFormulaVar := RVSteup."Stuffing Date Calculation";
                    end;
                    if (Format(DateFormulaVar) <> '') then
                        "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Cosing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation
                end;

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    if Confirm('Do you want to update the related sales lines with the same Cosing Date and Stuffing Date?') then begin
                        repeat
                            SalesLine."RV_Cosing Date" := "RV_Cosing Date";
                            SalesLine."RV_Stuffing Date" := "RV_Stuffing Date";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
            end;
        }
        field(50102; "RV_ETA"; Date)
        {
            Caption = 'ETA';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    if Confirm('You have modified the field ETA. Do you want to update the line?') then begin
                        repeat
                            SalesLine."RV_ETA" := "RV_ETA";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
            end;
        }
        field(50103; "RV_ETD"; Date)
        {
            Caption = 'ETD';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    if Confirm('You have modified the field ETD. Do you want to update the line?') then begin
                        repeat
                            SalesLine."RV_ETD" := "RV_ETD";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
            end;
        }

        field(50600; "RV_ECR Required"; Boolean)
        {
            Caption = 'ECR Required';
            DataClassification = ToBeClassified;
        }

        field(50601; "RV_ECR Date"; Date)
        {
            Caption = 'ECR Date';
            DataClassification = ToBeClassified;
        }

        field(50602; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()//FDD012
            var
                SalesLine: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    if Confirm('You have modified the field Stuffing Date. Do you want to update the line?') then begin
                        repeat
                            SalesLine."RV_Stuffing Date" := "RV_Stuffing Date";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
            end;
        }
    }
}
