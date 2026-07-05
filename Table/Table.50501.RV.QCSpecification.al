/// <summary>
/// Table RV QC Specification (ID 50501)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50501 "RV QC Specification"
{
    Caption = 'QC Specification';
    DataClassification = CustomerContent;
    LookupPageID = "RV QC Specification List";
    fields
    {
        field(1; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
            NotBlank = true;
        }

        field(2; "QC Specification Description"; Text[100])
        {
            Caption = 'QC Specification Description';
        }
    }
    keys
    {
        key(PK; "QC Specification Name")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        QCSpecificationLine: Record "RV QC Specification Line";
        SpecValueSetting: Record "RV Specification Value Setting";
    begin
        //clear QCSpecificationLine
        QCSpecificationLine.Reset();
        QCSpecificationLine.SetRange("QC Specification Name", "QC Specification Name");
        QCSpecificationLine.DeleteAll();
        //clear SpecValueSetting
        SpecValueSetting.Reset();
        SpecValueSetting.SetRange("QC Specification Name", "QC Specification Name");
        SpecValueSetting.DeleteAll();
    end;
}