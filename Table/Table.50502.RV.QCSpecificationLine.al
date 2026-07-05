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
                QCListValue: Record "RV QC List Value";
                SpecValueSetting: Record "RV Specification Value Setting";
            begin
                Clear("Value Table Name");
                Clear("Value Table Type");
                Clear("Type");
                Clear("Minimum Value");
                Clear("Maximum Value");
                if "QC Parameter Name" <> xRec."QC Parameter Name" then begin
                    if "QC Parameter Name" <> '' then begin
                        if QCParameterRec.Get("QC Parameter Name") then begin
                            if QCValueTable.Get(QCParameterRec."Value Table Name") then begin
                                "Value Table Name" := QCValueTable."Value Table Name";
                                "Type" := QCValueTable."Type";
                                "Value Table Type" := QCValueTable."Value Table Type";
                                "Minimum Value" := QCValueTable."Minimum Value";
                                "Maximum Value" := QCValueTable."Maximum Value";

                                ClearSpecValueSetting(SpecValueSetting, xRec."QC Parameter Name");
                                InsertSpecValueSetting(SpecValueSetting);
                            end else begin
                                Clear("Value Table Name");
                                Clear("Type");
                                Clear("Value Table Type");
                                Clear("Minimum Value");
                                Clear("Maximum Value");
                                ClearSpecValueSetting(SpecValueSetting, xRec."QC Parameter Name");
                            end;
                        end;
                    end else begin
                        Clear("Value Table Name");
                        Clear("Type");
                        Clear("Value Table Type");
                        Clear("Minimum Value");
                        Clear("Maximum Value");
                        ClearSpecValueSetting(SpecValueSetting, xRec."QC Parameter Name");
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
        field(5; "Type"; Enum "RV Type")
        {
            Caption = 'Type';
        }
        field(6; "Value Table Name"; Code[100])
        {
            Caption = 'Value Table Name';
            TableRelation = "RV QC Value Table";
        }
        field(7; "Minimum Value"; Text[50])
        {
            Caption = 'Minimum Value';
        }
        field(8; "Maximum Value"; Text[50])
        {
            Caption = 'Maximum Value';
        }
    }
    keys
    {
        key(PK; "QC Specification Name", "QC Parameter Name")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        SpecValueSetting: Record "RV Specification Value Setting";
    begin
        //clear SpecValueSetting
        SpecValueSetting.Reset();
        SpecValueSetting.SetRange("QC Specification Name", "QC Specification Name");
        SpecValueSetting.SetRange("QC Parameter Name", "QC Parameter Name");
        SpecValueSetting.DeleteAll();
    end;

    procedure ClearSpecValueSetting(var SpecValueSetting: Record "RV Specification Value Setting"; QCParameterName: Code[20])
    begin
        //clear SpecValueSetting
        SpecValueSetting.Reset();
        SpecValueSetting.SetRange("QC Specification Name", "QC Specification Name");
        SpecValueSetting.SetRange("QC Parameter Name", QCParameterName); //QCParameterName
        SpecValueSetting.DeleteAll();
    end;

    procedure InsertSpecValueSetting(var SpecValueSetting: Record "RV Specification Value Setting")
    var
        QCParameterRec: Record "RV QC Parameter";
        QCValueTable: Record "RV QC Value Table";
        QCListValue: Record "RV QC List Value";
    begin
        if QCParameterRec.Get("QC Parameter Name") then;
        if QCValueTable.Get(QCParameterRec."Value Table Name") then;

        //Insert SpecValueSetting
        QCListValue.Reset();
        QCListValue.SetRange("Value Table Name", QCValueTable."Value Table Name");
        if QCListValue.FindSet() then
            repeat
                //Insert SpecValueSetting
                SpecValueSetting.Reset();
                SpecValueSetting.Init();
                SpecValueSetting."QC Specification Name" := "QC Specification Name";
                SpecValueSetting."QC Parameter Name" := "QC Parameter Name";
                SpecValueSetting."Value Table Name" := QCValueTable."Value Table Name";
                SpecValueSetting."Type" := QCValueTable."Type";
                SpecValueSetting."Value Table Type" := QCValueTable."Value Table Type";
                SpecValueSetting."List Value" := QCListValue."List Value";
                SpecValueSetting."Check Status" := QCListValue."Check Status";
                SpecValueSetting.Insert();
            until QCListValue.Next() = 0;
    end;

}