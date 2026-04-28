/// <summary>
/// Table RV QA Shipment Lot No.(ID 50509)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50509 "RV QA Shipment Lot No."
{
    Caption = 'QA Shipment Lot No.';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
            TableRelation = "RV QA Header";
            NotBlank = true;
        }
        field(2; "COA Lot Line No."; Integer)
        {
            Caption = 'COA Lot Line No.';
        }
        field(3; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(4; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }

        field(5; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = "Unit of Measure";
        }
        field(6; "Container No."; Text[100])
        {
            Caption = 'Container No.';
        }
        field(7; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(8; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }

        field(9; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(10; "QA Status"; Enum "RV QA Status")
        {
            Caption = 'QA Status';
        }
        field(16; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Qty. per UOM"; Decimal)
        {
            Caption = 'Qty. per UOM';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    var
        QAHeader: Record "RV QA Header";
    begin
        if QAHeader.Get("COA No.") then
            "QA Status" := QAHeader."QA Status";
    end;

    procedure SetQAEnable(var UpdateQALineEnable: Boolean; var QACheckEnable: Boolean;
                        var QAApproveEnable: Boolean; var QARejectEnable: Boolean;
                        var ShipmentLotNoEditable: Boolean; var SubCOACardEditable: Boolean;
                        var SubInterQCResultEditable: Boolean; var SubExterQCResultEditable: Boolean;
                         var SubInyResultEditable: Boolean)
    var
        QAHeader: Record "RV QA Header";
    begin

        if QAHeader.Get("COA No.") then;
        CASE QAHeader."QA Status" OF
            (QAHeader."QA Status"::Analyzing):
                begin
                    UpdateQALineEnable := true;
                    QACheckEnable := true;
                    QAApproveEnable := false;
                    QARejectEnable := false;

                    ShipmentLotNoEditable := true;
                    SubCOACardEditable := true;
                    SubInterQCResultEditable := true;
                    SubExterQCResultEditable := true;
                    SubInyResultEditable := true;
                end;
            (QAHeader."QA Status"::Checked):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := true;
                    QARejectEnable := true;

                    ShipmentLotNoEditable := false;
                    SubCOACardEditable := false;
                    SubInterQCResultEditable := false;
                    SubExterQCResultEditable := false;
                    SubInyResultEditable := false;
                end;
            (QAHeader."QA Status"::Approved):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;

                    ShipmentLotNoEditable := false;
                    SubCOACardEditable := false;
                    SubInterQCResultEditable := false;
                    SubExterQCResultEditable := false;
                    SubInyResultEditable := false;
                end;
            (QAHeader."QA Status"::Rejected):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;

                    ShipmentLotNoEditable := false;
                    SubCOACardEditable := false;
                    SubInterQCResultEditable := false;
                    SubExterQCResultEditable := false;
                    SubInyResultEditable := false;
                end;
        END;

    end;

    procedure CreateQAExternalQCResults()
    var
        QAExternalResults: Record "RV QA External QC Results";
        QAHeader: Record "RV QA Header";

        QCResourceGroupApply: Record "RV QC Resource Group Apply";
        QCCustExterSpec: Record "RV QC Customer External Spec.";
        TempQCCustExterSpec: Record "RV QC Customer External Spec." temporary;

        QCGroup: Record "RV QC Resource Group";
        QCSpecificationLine: Record "RV QC Specification Line";
        QCParameter: Record "RV QC Parameter";
        QCStandardType: enum "RV QC Standard Type";
        LineNo: Integer;
        currSpecification: Code[20];
        ConfirmChangeLineQst: Label 'The detail line already exists.Do you want to recreate detail line?';
    begin

        if QAHeader.Get(Rec."COA No.") then;
        QAExternalResults.Reset();
        QAExternalResults.SetRange("COA No.", Rec."COA No.");
        QAExternalResults.SetRange("COA Lot Line No.", Rec."COA Lot Line No.");
        if not QAExternalResults.IsEmpty then begin
            //clear QAExternalResults
            QAExternalResults.DeleteAll();
        end;

        Clear(currSpecification);
        Clear(LineNo);

        //QCGroupApply
        if not QCResourceGroupApply.Get(QAHeader."Item No.") then
            Error('Please Setup QC Resource Group Apply');

        //clear TempQCCustExterSpec
        TempQCCustExterSpec.Reset();
        TempQCCustExterSpec.DeleteAll();

        //Insert QCCustExterSpec
        QCCustExterSpec.Reset();
        if QCCustExterSpec.Get(QCResourceGroupApply."QC Resource Group No.", QAHeader."Ship-to Customer No.", QAHeader."Ship-to Code") then begin
            TempQCCustExterSpec.Init();
            TempQCCustExterSpec.TransferFields(QCCustExterSpec);
            if TempQCCustExterSpec.Insert() then;
        end else begin
            //"Ship-to Code",  ''
            QCCustExterSpec.Reset();
            if QCCustExterSpec.Get(QCResourceGroupApply."QC Resource Group No.", QAHeader."Ship-to Customer No.", '') then begin
                TempQCCustExterSpec.Init();
                TempQCCustExterSpec.TransferFields(QCCustExterSpec);
                if TempQCCustExterSpec.Insert() then;
            end else begin
                //"Customer No." , ''  "Ship-to Code",  ''
                if QCCustExterSpec.Get(QCResourceGroupApply."QC Resource Group No.", '', '') then begin
                    TempQCCustExterSpec.Init();
                    TempQCCustExterSpec.TransferFields(QCCustExterSpec);
                    if TempQCCustExterSpec.Insert() then;
                end;
            end;
        end;

        //curr Specification
        TempQCCustExterSpec.Reset();
        if TempQCCustExterSpec.FindFirst() then begin

            if TempQCCustExterSpec."External Specification" <> '' then begin

                //currSpecification
                Clear(currSpecification);
                currSpecification := TempQCCustExterSpec."External Specification";

            end else begin
                //QCGroup
                QCGroup.Reset();
                QCGroup.SetCurrentKey("QC Resource Group No.", "Effective Date");
                QCGroup.SetRange("QC Resource Group No.", TempQCCustExterSpec."QC Resource Group No.");
                QCGroup.SetFilter("Effective Date", '%1 | ..%2', 0D, WorkDate());
                if QCGroup.Find('+') then begin
                    currSpecification := QCGroup."External Specification";
                end else begin
                    Error('No QC specifications were found for item %1', QAHeader."Item No.");
                end;
            end;

            //QCSpecificationLine
            QCSpecificationLine.Reset();
            QCSpecificationLine.SetRange("QC Specification Name", currSpecification);
            if QCSpecificationLine.FindSet() then
                repeat
                    //QCLine
                    LineNo := LineNo + 10000;
                    QAExternalResults.Init();
                    QAExternalResults."COA No." := "COA No.";
                    QAExternalResults."COA Lot Line No." := "COA Lot Line No.";
                    QAExternalResults."QC External Spec. Line No." := LineNo;

                    //QCParameter
                    if QCParameter.Get(QCSpecificationLine."QC Parameter Name") then begin
                        QAExternalResults."QC Parameter Name" := QCParameter."Parameter Name";
                        QAExternalResults."QC Value" := QCParameter."Value Table Name";
                        //QAExternalResults."COA Value" := 
                        //QAExternalResults."Differ From QC Vaule":=
                        //QAExternalResults."Alpha. Min"
                        //QAExternalResults."Alpha. Max"

                    end;
                    QAExternalResults.Insert();
                until QCSpecificationLine.Next() = 0;
        end;
    end;
}