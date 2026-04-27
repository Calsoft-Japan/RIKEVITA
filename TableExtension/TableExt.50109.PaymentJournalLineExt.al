/// <summary>
/// TableExtension RV Payment Journal Line Ext (ID 50109) extends "Gen. Journal Line" table
/// FDD017 FDD016 2026/04/13: New. (Liuyang)
/// </summary>
tableextension 50109 "RV Payment Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50100; "RV_Cheque No."; Code[20])
        {
            Description = 'FDD016';
            Caption = 'Cheque No.';
            DataClassification = ToBeClassified;
        }

        field(50101; "RV_APV No."; Code[20])
        {
            Description = 'FDD016';
            Caption = 'APV No.';
            DataClassification = ToBeClassified;
        }
        field(50102; "RV_Description 2"; Text[300])
        {
            Description = 'FDD017';
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(50103; "RV_Expat Employee"; Boolean)
        {
            Description = 'FDD017';
            Caption = 'Expat Employee';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "RV_Partner Type"; Enum "Partner Type")
        {
            Description = 'FDD017';
            Caption = 'Partner Type';
            DataClassification = ToBeClassified;
            //TableRelation = Vendor."Partner Type";
            Editable = false;
        }
        field(50105; "RV_ID No./Passport No."; Code[30])//Value should come from Vendor/Employee master same field
        {
            Description = 'FDD017';
            Caption = 'ID No./Passport No.';
            DataClassification = ToBeClassified;
            //TableRelation = Vendor."RV_ID No./Passport No.";
            Editable = false;
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
                Emp: Record Employee;
                BankAcct: Record "Bank Account";
            begin
                "RV_Expat Employee" := false;
                "RV_ID No./Passport No." := '';
                "Recipient Bank Account" := '';
                "RV_Partner Type" := Vend."Partner Type"::" ";
                "RV_Cheque No." := '';

                if (Rec."Account Type" = "Account Type"::Employee) and (Rec."Account No." <> '') then begin
                    if Emp.Get("Account No.") then begin
                        "RV_Expat Employee" := Emp."RV_Expat Employee";
                        "RV_ID No./Passport No." := Emp."RV_ID No./Passport No.";
                        "Recipient Bank Account" := Emp."RV_Bank Account Code";
                    end;
                end
                else
                    if (Rec."Account Type" = "Account Type"::Vendor) and (Rec."Account No." <> '') then begin
                        if Vend.Get("Account No.") then begin
                            "RV_Partner Type" := Vend."Partner Type";
                            "RV_ID No./Passport No." := Vend."RV_ID No./Passport No.";
                            "Recipient Bank Account" := Vend."Preferred Bank Account Code";
                        end;
                    end;

                // if ("Recipient Bank Account" <> '') and BankAcct.Get("Recipient Bank Account") then
                //     "RV_Cheque No." := BankAcct."Last Check No.";
            end;
        }

        modify("Bal. Account No.")//FDD016
        {
            trigger OnAfterValidate()
            var
                BankAcct: Record "Bank Account";
            begin
                if ("Bal. Account Type" = "Gen. Journal Account Type"::"Bank Account") and ("Bal. Account No." <> '') and BankAcct.Get("Bal. Account No.") then
                    "RV_Cheque No." := BankAcct."Last Check No.";
            end;
        }
    }
}
