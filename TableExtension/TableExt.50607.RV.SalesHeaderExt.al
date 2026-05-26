/// <summary>
/// TableExtension RV Sales Header (ID 50607) extends Sales Header table
/// FDD006 2026/03/31: New. (Stephen)
/// FDD012 2026/04/19: Liuyang.
/// FDD006 2026/05/9: Fix the logic for updating  (Zhao)
/// </summary>
tableextension 50607 "RV Sales Header" extends "Sales Header"
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
                if ("RV_B/L Date" <> xRec."RV_B/L Date") then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    //if SalesLine.FindFirst() then Zhao
                    if SalesLine.FindSet() then
                        if Confirm('You have modified the field B/L Date. Do you want to update the line?') then begin
                            repeat
                                SalesLine."RV_B/L Date" := "RV_B/L Date";
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                        end;
                end;
            end;
        }
        field(50101; "RV_Closing Date"; Date)
        {
            Caption = 'Closing Date';
            Description = 'FDD012';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                RVSteup: Record "RV RIKEVITA Setup";
                DateFormulaVar: DateFormula;
            begin
                if ("RV_Closing Date" <> xRec."RV_Closing Date") then begin

                    if Rec."RV_Closing Date" = 0D then begin
                        "RV_Stuffing Date" := 0D;
                    end else begin
                        //Zhao BEGIN
                        /*RVSteup.Reset();
                        if RVSteup.FindFirst() then begin
                            DateFormulaVar := RVSteup."Stuffing Date Calculation";
                        end;
                        if (Format(DateFormulaVar) <> '') then
                            "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Cosing Date");//Stuffing Date = Closing Date - Stuffing Date Calculation
                            */
                        RVSteup.get();
                        DateFormulaVar := RVSteup."Stuffing Date Calculation";
                        if (Format(DateFormulaVar) <> '') then
                            "RV_Stuffing Date" := CalcDate('-' + Format(DateFormulaVar), "RV_Closing Date")//Stuffing Date = Closing Date - Stuffing Date Calculation
                        else
                            "RV_Stuffing Date" := "RV_Closing Date";
                    end;

                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindSet() then
                        if Confirm('Do you want to update the related sales lines with the same Cosing Date and Stuffing Date?') then begin
                            repeat
                                SalesLine.Validate("RV_Closing Date", "RV_Closing Date");
                                SalesLine.Validate("RV_Stuffing Date", "RV_Stuffing Date");
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                        end;
                end;
                //Zhao END
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
                if RV_ETA <> xRec.RV_ETA then begin//Zhao
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindFirst() then
                        if Confirm('You have modified the field ETA. Do you want to update the line?') then begin
                            repeat
                                SalesLine."RV_ETA" := "RV_ETA";
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                        end;
                end
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
                if RV_ETD <> xRec.RV_ETD then begin//Zhao
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindFirst() then
                        if Confirm('You have modified the field ETD. Do you want to update the line?') then begin
                            repeat
                                SalesLine."RV_ETD" := "RV_ETD";
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                        end;
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
                if "RV_Stuffing Date" <> xRec."RV_Stuffing Date" then begin//Zhao
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindSet() then
                        if Confirm('You have modified the field Stuffing Date. Do you want to update the line?') then begin
                            repeat
                                SalesLine.Validate("RV_Stuffing Date", "RV_Stuffing Date");
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                        end;
                end;
            end;
        }
    }
}
