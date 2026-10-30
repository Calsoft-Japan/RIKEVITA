/// <summary>
/// Table RV NC Header (ID 50520)
/// FDD039 2026/10/09: New. (Mike)
/// </summary>
table 50521 "RV QC Resource Group Remarks"
{
    Caption = 'QC Resource Group Remarks';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC Resource Group No."; Code[20])
        {
            Caption = 'QC Resource Group No.';
        }
        field(20; "Remark Code"; Code[50])
        {
            Caption = 'Remark Code';

            trigger OnLookup()
            var
                StandardRemark: Record "RV Standard Remark";
                StandardRemarkLookup: Page "RV Standard Remark";
            begin
                StandardRemark.Reset();
                Clear(StandardRemarkLookup);
                StandardRemarkLookup.SetTableView(StandardRemark);
                StandardRemarkLookup.LookupMode(true);
                if StandardRemarkLookup.RunModal() = Action::LookupOK then begin
                    StandardRemarkLookup.GetRecord(StandardRemark);
                    Rec."Remark Code" := StandardRemark.Code;
                    Rec."Remark Type" := StandardRemark."Remark Type";
                    Rec.Remark := StandardRemark.Remark;
                end;
            end;

            trigger OnValidate()
            var
                StandardRemark: Record "RV Standard Remark";
            begin
                if Rec."Remark Code" = '' then begin
                    Rec.Remark := '';
                    exit;
                end;

                if Rec."Remark Code" <> xRec."Remark Code" then begin
                    StandardRemark.Get(Rec."Remark Code", Rec."Remark Type");
                    Rec.Remark := StandardRemark.Remark;
                end;
            end;
        }
        field(25; "Remark Type"; Enum "RV Remark Type")
        {
            Caption = 'Remark Type';
            DataClassification = ToBeClassified;
        }
        field(30; "Remark"; Text[150])
        {
            Caption = 'Remark';
        }
    }
    keys
    {
        key(PK; "QC Resource Group No.", "Remark Code", "Remark Type")
        {
            Clustered = true;
        }
    }
}