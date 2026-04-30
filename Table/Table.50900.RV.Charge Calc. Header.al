/// <summary>
/// Table RV Charge Calc. Header(ID 50900)
/// FDD009 2026/04/30: New. (Shawn)
/// </summary>
table 50900 "RV Charge Calc. Header"
{
    Caption = 'Charge Calc. Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Description"; Text[250])
        {
            Caption = 'Description';
        }

        field(3; "Calculation Date"; Date)
        {
            Caption = 'Calculation Date';
        }

        field(4; "Calculated By"; Code[50])
        {
            Caption = 'Calculated By';
            TableRelation = "User Setup"."User ID";

        }

        field(5; "Charge Type"; Enum "RV Charge Type")
        {
            Caption = 'Charge Type';

        }

        field(6; "Status"; Enum "RV Charge Calc. Status")
        {
            Caption = 'Charge Type';

        }

        field(11; "HTP Adjustment Price"; Decimal)
        {
            Caption = 'HTP Adjustment Price';
        }
        field(12; "01-COO"; Decimal)
        {
            Caption = '01-COO';
        }
        field(13; "02-FORWARDING"; Decimal)
        {
            Caption = '02-FORWARDING';
        }
        field(14; "03-FUMIGATION"; Decimal)
        {
            Caption = '03-FUMIGATION';
        }
        field(15; "04-HEALTH"; Decimal)
        {
            Caption = '04-HEALTH';
        }
        field(16; "05-PALLETIZING"; Decimal)
        {
            Caption = '05-PALLETIZING';
        }
        field(17; "06-PHYTO"; Decimal)
        {
            Caption = '06-PHYTO';
        }
        field(18; "07-STUFFING"; Decimal)
        {
            Caption = '07-STUFFING';
        }
        field(19; "08-TRANSPORT"; Decimal)
        {
            Caption = '08-TRANSPORT';
        }
        field(20; "09-REACH"; Decimal)
        {
            Caption = '09-REACH';
        }
        field(21; "99-OTHERS"; Decimal)
        {
            Caption = '99-OTHERS';
        }
        field(22; "FREIGHT"; Decimal)
        {
            Caption = 'FREIGHT';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        "Calculation Date" := WorkDate();
    end;

}