/// <summary>
/// Table RV QC Specification Line (ID 50502)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50502 "RV QC Specification Line"
{
    Caption = 'QC Specification Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC Specification Name"; Code[20])
        {
            Caption = 'QC Specification Name';
        }
        field(2; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
            trigger OnValidate()
            var
                QCParameterRec: Record "RV QC Parameter";
                QCValueTable: Record "RV QC Value Table";
            begin
                Clear("Value Table Type");
                Clear("Target Value ib Base UM");
                if "QC Parameter Name" <> xRec."QC Parameter Name" then begin
                    if "QC Parameter Name" <> '' then begin
                        if QCParameterRec.Get("QC Parameter Name") then begin
                            if QCValueTable.Get(QCParameterRec."Value Table Name") then;
                            "Value Table Type" := QCValueTable."Value Table Type";

                            if "Value Table Type" = "Value Table Type"::Range then begin
                                if (QCValueTable."Minimum Value" <> '') and (QCValueTable."Maximum Value" <> '') then
                                    "Target Value ib Base UM" := QCValueTable."Minimum Value" + '..' + QCValueTable."Maximum Value"
                                else if (QCValueTable."Minimum Value" = '') and (QCValueTable."Maximum Value" <> '') then
                                    "Target Value ib Base UM" := '..' + QCValueTable."Maximum Value"
                                else if (QCValueTable."Minimum Value" <> '') and (QCValueTable."Maximum Value" = '') then
                                    "Target Value ib Base UM" := '..' + QCValueTable."Maximum Value"
                            end;
                        end;
                    end else begin
                        "Value Table Type" := "Value Table Type"::" ";
                        "Target Value ib Base UM" := '';
                    end;
                end;
            end;
        }
        field(3; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
        field(4; "Target Value ib Base UM"; Text[100])
        {
            Caption = 'Target Value ib Base UM';
        }
    }
    keys
    {
        key(PK; "QC Specification Name", "QC Parameter Name")
        {
            Clustered = true;
        }
    }



}