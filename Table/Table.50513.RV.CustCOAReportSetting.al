/// <summary>
/// Table RV Cust. COA Report Setting (ID 50513)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50513 "RV Cust. COA Report Setting"
{
    Caption = 'Cust. COA Report Setting';
    DataClassification = CustomerContent;
    fields
    {

        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            NotBlank = true;
        }
        field(2; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(3; "Display Quantity Per Lot."; Boolean)
        {
            Caption = 'Display Quantity Per Lot.';
        }
        field(4; "Display Method&Chars Spec."; Enum "RV Display Method Chars Spec.")
        {
            Caption = 'Display Method&Chars Spec.';
        }
        field(5; "Date Wording"; Enum "RV Date Wording")
        {
            Caption = 'Date Wording';
        }
        field(6; "Date Calculation"; Enum "RV Date Calculation")
        {
            Caption = 'Date Calculation';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }

    /*
    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RIKEVITA Setup";
    begin

        if "QC No." = '' then begin
            RVVITASetup.Get();
            RVVITASetup.TestField("QC No. Nos.");
            "QC No." := NoSeriesMgt.GetNextNo(RVVITASetup."QC No. Nos.");
        end;
    end;
    */

    var
}