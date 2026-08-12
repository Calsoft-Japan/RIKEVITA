/// <summary>
/// Page RV COA Card Subform (ID 50514)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50514 "RV COA Card Subform"
{
    Caption = 'RV COA Card Subform';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QA Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                    trigger OnAssistEdit()
                    begin
                        if (Rec."COA No." = '') then begin
                            RIKEVITASetup.Get();
                            RIKEVITASetup.TestField("COA No. Nos.");
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."COA No. Nos.", Rec."COA No.") then begin
                                Rec."COA No." := NoSeries.GetNextNo(RIKEVITASetup."COA No. Nos.");
                            end;
                        end;
                    end;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type QA")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                    trigger OnValidate()
                    begin
                        Rec."Order No." := '';
                        Rec."Item No." := '';

                        //ClearHeaderData
                        Rec.ClearHeaderData;

                        //clear ShipmentLotNo
                        Rec.ClearShipmentLotNo;

                        //Init ShipmentLotNo
                        Rec.InitShipmentLotNo;

                        CurrPage.Update();

                    end;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PostedWhShipLine: Record "Posted Whse. Shipment Line";
                        WhShipline: Record "Warehouse Shipment line";
                        RefOrderTypeQA: Enum "RV Ref. Order Type QA";
                    begin

                        if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Posted Whse. Shipment" then begin
                            if Page.RunModal(Page::"Posted Whse. Shipment Lines", PostedWhShipLine) <> Action::LookupOK then
                                exit(false);
                            Text := PostedWhShipLine."No.";
                            Rec."Item No." := PostedWhShipLine."Item No.";
                            Rec."Line No." := PostedWhShipLine."Line No.";
                            exit(true);

                        end else if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Warehouse Shipment" then begin
                            if Page.RunModal(Page::"Whse. Shipment Lines", WhShipline) <> Action::LookupOK then
                                exit(false);
                            Text := WhShipline."No.";
                            Rec."Item No." := WhShipline."Item No.";
                            Rec."Line No." := WhShipline."Line No.";
                            CurrPage.Update(true);
                            exit(true);
                        end;

                    end;

                    trigger OnValidate()
                    begin
                        //ClearHeaderData
                        Rec.ClearHeaderData;

                        //clear ShipmentLotNo
                        Rec.ClearShipmentLotNo;

                        Rec.ValidateOrderNo();

                        //Init ShipmentLotNo
                        Rec.InitShipmentLotNo;

                        CurrPage.Update();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Customer No."; Rec."Ship-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Final Destination"; Rec."Final Destination")
                {
                    ApplicationArea = All;
                    Editable = SubCOACardEditable;
                }
                field("Mark"; Rec."Mark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = SubCOACardEditable;
                }
                field("QA Comment"; Rec."QA Comment")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("QA Status"; Rec."QA Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA Checked By"; Rec."QA Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA Checked Remark"; Rec."QA Checked Remark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("QA Checked Date"; Rec."QA Checked Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA Approved By"; Rec."QA Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA Approved Remark"; Rec."QA Approved Remark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("QA Approved Date"; Rec."QA Approved Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("COA Created Date"; Rec."COA Created Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);
    end;


    var
        PO: Page "Purchase Order";
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";

        UpdateQALineEnable: Boolean;
        QACheckEnable: Boolean;
        QAApproveEnable: Boolean;
        QARejectEnable: Boolean;
        SubCOACardEditable: Boolean;

    procedure UpdateQALine_Action()
    var
        QCResourceGroupApply: Record "RV QC Resource Group Apply";
        QCResource: Record "RV QC Resource Group";
        QAExternalQCResults: Record "RV QA External QC Results";
        QAInternalQCResults: Record "RV QA Internal QC Results";
        QCSpecification: Record "RV QC Specification";
        CustomerExternalSpec: Record "RV QC Customer External Spec.";
        QCSpecificationLine: Record "RV QC Specification Line";
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        ExternalSpecNo: Code[30];
        ExternalSpecLineNo: Integer;
        FQCHeader: Record "RV QC Header";
        FQCLine: Record "RV QC Line";
        QCValueTable: Record "RV QC Value Table";
    begin
        QAShipmentLotNo.reset;
        QAShipmentLotNo.SetRange(QAShipmentLotNo."COA No.", Rec."COA No.");
        if QAShipmentLotNo.FindSet() then
            repeat
                //create LotNo internal QC line based on the FQC Line
                FQCHeader.Reset();
                FQCHeader.SetRange(FQCHeader."QC Type", FQCHeader."QC Type"::FQC);
                FQCHeader.SetRange(FQCHeader."Lot No.", QAShipmentLotNo."Lot No.");
                FQCHeader.SetRange("Item No.", Rec."Item No.");
                if FQCHeader.FindLast() then begin
                    FQCLine.Reset();
                    FQCLine.SetRange(FQCLine."QC No.", FQCHeader."QC No.");
                    FQCLine.SetRange("QC Type", FQCLine."QC Type"::FQC);
                    if FQCLine.FindSet() then begin

                        //create internal QC line based on the FQC Line
                        QAInternalQCResults.Reset();
                        QAInternalQCResults.SetRange("COA No.", Rec."COA No.");
                        QAInternalQCResults.SetRange("COA Lot No.", QAShipmentLotNo."Lot No.");
                        if QAInternalQCResults.FindSet() then
                            repeat
                                QAInternalQCResults.Delete();
                            until QAInternalQCResults.Next() = 0;
                        repeat
                            QAInternalQCResults.Init();
                            QAInternalQCResults."COA No." := Rec."COA No.";
                            QAInternalQCResults."COA Lot No." := QAShipmentLotNo."Lot No.";
                            QAInternalQCResults."COA Container No." := QAShipmentLotNo."Container No.";
                            QAInternalQCResults."QC Specification Name" := FQCLine."QC Specification Name";
                            QAInternalQCResults."QC Internal Spec. Line No." := FQCLine."Line No.";
                            QAInternalQCResults."QC Parameter Name" := FQCLine."QC Parameter Name";
                            QAInternalQCResults."QC Value" := FQCLine."QC Value";
                            QAInternalQCResults."QC Type" := QAInternalQCResults."QC Type"::FQC;
                            QAInternalQCResults."Check Status" := FQCLine."Check Status";
                            QAInternalQCResults."QC Checked Remark" := FQCHeader."QC Checked Remark";
                            QAInternalQCResults."QC Approved Remark" := FQCHeader."QC Approved Remark";
                            QAInternalQCResults."Value Table Type" := FQCLine."Value Table Type";

                            QCValueTable.Reset();
                            QCValueTable.SetRange("Value Table Name", FQCLine."Value Table Name");
                            if not QCValueTable.FindFirst() then
                                QCValueTable.Init();

                            QAInternalQCResults."Alpha. Max" := QCValueTable."Maximum Value";
                            QAInternalQCResults."Alpha. Min" := QCValueTable."Minimum Value";
                            QAInternalQCResults.Insert();
                        until FQCLine.Next() = 0;
                    end;
                end else begin
                    Error('Before QA,Please first create FQC Line for Item %1 and lot %2.', Rec."Item No.", QAShipmentLotNo."Lot No.");
                end;
                //Create external QC results based on the applied QC Resource Group and related External Specification
                QCResourceGroupApply.Reset();
                QCResourceGroupApply.SetRange("Item No.", Rec."Item No.");
                if QCResourceGroupApply.FindLast then begin
                    QCResource.Reset();
                    QCResource.SetFilter("Effective Date", '%1|..%2', 0D, WorkDate());
                    QCResource.SetRange("QC Resource Group No.", QCResourceGroupApply."QC Resource Group No.");
                    if not QCResource.FindLast() OR (QCResource."External Specification" = '') then
                        Error('No QC Resource found for group %1', QCResourceGroupApply."QC Resource Group No.");
                end Else
                    Error('No QC Resource found for group %1', QCResourceGroupApply."QC Resource Group No.");

                //Clear(ExternalSpecNo);
                CustomerExternalSpec.Reset();
                CustomerExternalSpec.SetRange("QC Resource Group No.", QCResource."QC Resource Group No.");
                CustomerExternalSpec.SetRange("Customer No.", rec."Ship-to Customer No.");
                CustomerExternalSpec.SetRange("Ship-to Code", rec."Ship-to Code");
                if CustomerExternalSpec.FindLast() then
                    ExternalSpecNo := CustomerExternalSpec."External Specification"
                else begin
                    CustomerExternalSpec.Reset();
                    CustomerExternalSpec.SetRange("QC Resource Group No.", QCResource."QC Resource Group No.");
                    CustomerExternalSpec.SetRange("Customer No.", rec."Ship-to Customer No.");
                    if CustomerExternalSpec.FindLast() then
                        ExternalSpecNo := CustomerExternalSpec."External Specification";
                end;

                IF ExternalSpecNo = '' then
                    ExternalSpecNo := QCResource."External Specification";

                if ExternalSpecNo = '' then
                    Error('No External Specification found for QC Resource Group %1', QCResource."QC Resource Group No.");

                QCSpecification.Reset;
                QCSpecification.SetRange("QC Specification Name", ExternalSpecNo);

                QCSpecificationLine.reset;
                QCSpecificationLine.SetRange("QC Specification Name", ExternalSpecNo);
                if QCSpecificationLine.findset then begin
                    QAExternalQCResults.Reset();
                    QAExternalQCResults.SetRange("COA No.", Rec."COA No.");
                    //QAExternalQCResults.SetRange("COA Container No.", QAShipmentLotNo."Container No.");
                    QAExternalQCResults.SetRange("COA Lot No.", QAShipmentLotNo."Lot No.");

                    if QAExternalQCResults.FindSet() then begin
                        if Confirm('External QC results already exist. Do you want to overwrite them?', true) then begin
                            repeat
                                QAExternalQCResults.Delete();
                            until QAExternalQCResults.Next() = 0;
                        end Else
                            exit;
                    end;
                    repeat
                        ExternalSpecLineNo += 10000;
                        QAExternalQCResults.Init();

                        QAExternalQCResults."COA No." := Rec."COA No.";
                        QAExternalQCResults."COA Lot No." := QAShipmentLotNo."Lot No.";
                        QAExternalQCResults."COA Container No." := QAShipmentLotNo."Container No.";
                        QAExternalQCResults."QC External Spec. Line No." := ExternalSpecLineNo;
                        QAExternalQCResults.Validate("QC Parameter Name", QCSpecificationLine."QC Parameter Name");
						QAExternalQCResults."QC Specification Name" := QCSpecificationLine."QC Specification Name";
                        QAexternalqcresults."Alpha. Min" := QCSpecificationLine."Minimum Value";
                        QAexternalqcresults."Alpha. Max" := QCSpecificationLine."Maximum Value";
                        QAExternalQCResults.Insert();
                    until QCSpecificationLine.next = 0;
                end;
                CurrPage.Update(true);
            until QAShipmentLotNo.Next() = 0;
    end;

    procedure QACheck_Action()
    begin
        //IsQACheckAllowed
        Rec.IsQACheckAllowed();

        //CheckRemark_Input
        Rec.CheckRemark_Input();

        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);

    end;

    procedure COAApprove_Action()
    begin
        //IsQAApproveAllowed
        Rec.IsQAApproveAllowed();

        //ApprovedRemark_Input
        Rec.ApprovedRemark_Input();

        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);
    end;

    procedure COAReject_Action()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin
        //IsQARejectAllowed
        Rec.IsQARejectAllowed();
        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);

        Rec."QA Status" := Rec."QA Status"::Rejected;
        Rec.Modify();

        QAShipmentLotNo.Reset();
        QAShipmentLotNo.SetRange("COA No.", Rec."COA No.");
        QAShipmentLotNo.ModifyAll("QA Status", Rec."QA Status"::Rejected);
    end;

    procedure COAReverse_Action()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin
        //IsQAReverseAllowed
        Rec.IsQAReverseAllowed();
        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, SubCOACardEditable);

        Clear(Rec."QA Approved By");
        Clear(Rec."QA Approved Date");
        Rec."QA Status" := Rec."QA Status"::Checked;
        Rec.Modify();

        QAShipmentLotNo.Reset();
        QAShipmentLotNo.SetRange("COA No.", Rec."COA No.");
        QAShipmentLotNo.ModifyAll("QA Status", Rec."QA Status"::Checked);
    end;

    procedure COAPrint_Action()
    var
        QAHeader: Record "RV QA Header";
    begin
        CurrPage.SetSelectionFilter(QAHeader);
        REPORT.RUN(Report::"RV_COA Report", true, false, QAHeader);
    end;

}