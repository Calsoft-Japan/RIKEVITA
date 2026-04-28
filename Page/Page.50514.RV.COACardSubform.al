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
                    trigger OnValidate()
                    begin
                        Rec."Order No." := '';
                        Rec."Item No." := '';

                        //ClearHeaderData
                        Rec.ClearHeaderData;

                        //clear ShipmentLotNo
                        Rec.ClearShipmentLotNo;
                        CurrPage.Update();

                    end;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
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
                            //CurrPage.Update(true);
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

                        CurrPage.Update();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Customer No."; Rec."Ship-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Mark"; Rec."Mark")
                {
                    ApplicationArea = All;
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
                    Editable = false;
                }
                field("COA Date"; Rec."COA Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    /*
        actions
        {
            area(processing)
            {
                action("UpdateQALine")
                {
                    Caption = 'Update QA Line';
                    ApplicationArea = All;
                    Image = UpdateShipment;
                    Enabled = UpdateQALineEnable;

                    trigger OnAction()
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
                                        QAInternalQCResults.SetRange("COA Lot Line No.", QAShipmentLotNo."COA Lot Line No.");
                                        if QAInternalQCResults.FindSet() then
                                            repeat
                                                QAInternalQCResults.Delete();
                                            until QAInternalQCResults.Next() = 0;
                                        repeat
                                            QAInternalQCResults.Init();
                                            QAInternalQCResults."COA No." := Rec."COA No.";
                                            QAInternalQCResults."COA Lot Line No." := Rec."Line No.";
                                            QAInternalQCResults."QC Internal Spec. Line No." := FQCLine."Line No.";
                                            QAInternalQCResults."QC Parameter Name" := FQCLine."QC Parameter Name";
                                            QAInternalQCResults."QC Result" := FQCLine."QC Result";
                                            QAInternalQCResults."QC Type" := QAInternalQCResults."QC Type"::FQC;
                                            //QAInternalQCResults."Check Status" := FQCHeader."QC Status";
                                            QAInternalQCResults."QC Checked Remark" := FQCHeader."QC Checked Remark";
                                            QAInternalQCResults."QC Approved Remark" := FQCHeader."QC Approved Remark";
                                            QAInternalQCResults."Value Table Type" := FQCLine."Value Table Type";
                                            //QAInternalQCResults."Alpha. Max" := FQCLine."Alpha. Max";
                                            //QAInternalQCResults."Alpha. Min" := FQCLine."Alpha. Min";                                
                                            QAInternalQCResults.Insert();
                                        until FQCLine.Next() = 0;
                                    end;
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
                                        ExternalSpecNo := CustomerExternalSpec."External Specification"
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
                                    QAExternalQCResults.SetRange("COA Lot Line No.", Rec."Line No.");
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
                                        QAExternalQCResults."COA Lot Line No." := Rec."Line No.";
                                        QAExternalQCResults."QC External Spec. Line No." := ExternalSpecLineNo;
                                        QAExternalQCResults."QC Parameter Name" := QCSpecificationLine."QC Parameter Name";

                                        //QAExternalQCResults."Alpha. Max"
                                        //QAExternalQCResults."Alpha. Min"
                                        //QAExternalQCResults."QC Value"

                                        QAExternalQCResults.Insert();
                                    until QCSpecificationLine.next = 0;
                                end;
                                CurrPage.Update(true);
                            until QAShipmentLotNo.Next() = 0;
                    end;

                }

                action("External Spec. Check")
                {
                    Caption = 'External Spec. Check';
                    ApplicationArea = All;
                    Image = Check;
                    Enabled = QACheckEnable;
                    trigger OnAction()
                    begin
                        //IsQACheckAllowed
                        Rec.IsQACheckAllowed();

                        //CheckRemark_Input
                        Rec.CheckRemark_Input();

                        //Enable
                        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);
                    end;
                }
                action(COAApprove)
                {
                    Caption = 'COA Approve';
                    ApplicationArea = All;
                    Image = Approval;
                    Enabled = QAApproveEnable;

                    trigger OnAction()
                    begin
                        //IsQAApproveAllowed
                        Rec.IsQAApproveAllowed();

                        //ApprovedRemark_Input
                        Rec.ApprovedRemark_Input();

                        //Enable
                        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);
                    end;
                }
                action(COAReject)
                {
                    Caption = 'COA Reject';
                    ApplicationArea = All;
                    Image = Approval;
                    Enabled = QARejectEnable;

                    trigger OnAction()
                    var
                        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
                    begin
                        //IsQARejectAllowed
                        Rec.IsQARejectAllowed();
                        //Enable
                        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);

                        Rec."QA Status" := Rec."QA Status"::Rejected;
                        Rec.Modify();

                        QAShipmentLotNo.Reset();
                        QAShipmentLotNo.SetRange("COA No.");
                        QAShipmentLotNo.ModifyAll("QA Status", Rec."QA Status"::Rejected);

                    end;
                }
                action(COAPrint)
                {
                    Caption = 'COA Print';
                    ApplicationArea = All;
                    Image = Print;
                    trigger OnAction()
                    var
                        QAHeader: Record "RV QA Header";
                    begin
                        CurrPage.SetSelectionFilter(QAHeader);
                        REPORT.RUN(Report::"RV_COA Report", true, false, QAHeader);
                    end;
                }
            }

        }
    */
    trigger OnOpenPage()
    begin
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);
    end;


    var
        PO: Page "Purchase Order";
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";

        UpdateQALineEnable: Boolean;
        QACheckEnable: Boolean;
        QAApproveEnable: Boolean;
        QARejectEnable: Boolean;

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
                        QAInternalQCResults.SetRange("COA Lot Line No.", QAShipmentLotNo."COA Lot Line No.");
                        if QAInternalQCResults.FindSet() then
                            repeat
                                QAInternalQCResults.Delete();
                            until QAInternalQCResults.Next() = 0;
                        repeat
                            QAInternalQCResults.Init();
                            QAInternalQCResults."COA No." := Rec."COA No.";
                            QAInternalQCResults."COA Lot Line No." := Rec."Line No.";
                            QAInternalQCResults."QC Internal Spec. Line No." := FQCLine."Line No.";
                            QAInternalQCResults."QC Parameter Name" := FQCLine."QC Parameter Name";
                            QAInternalQCResults."QC Result" := FQCLine."QC Result";
                            QAInternalQCResults."QC Type" := QAInternalQCResults."QC Type"::FQC;
                            //QAInternalQCResults."Check Status" := FQCHeader."QC Status";
                            QAInternalQCResults."QC Checked Remark" := FQCHeader."QC Checked Remark";
                            QAInternalQCResults."QC Approved Remark" := FQCHeader."QC Approved Remark";
                            QAInternalQCResults."Value Table Type" := FQCLine."Value Table Type";
                            //QAInternalQCResults."Alpha. Max" := FQCLine."Alpha. Max";
                            //QAInternalQCResults."Alpha. Min" := FQCLine."Alpha. Min";                                
                            QAInternalQCResults.Insert();
                        until FQCLine.Next() = 0;
                    end;
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
                        ExternalSpecNo := CustomerExternalSpec."External Specification"
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
                    QAExternalQCResults.SetRange("COA Lot Line No.", Rec."Line No.");
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
                        QAExternalQCResults."COA Lot Line No." := Rec."Line No.";
                        QAExternalQCResults."QC External Spec. Line No." := ExternalSpecLineNo;
                        QAExternalQCResults."QC Parameter Name" := QCSpecificationLine."QC Parameter Name";

                        //QAExternalQCResults."Alpha. Max"
                        //QAExternalQCResults."Alpha. Min"
                        //QAExternalQCResults."QC Value"

                        QAExternalQCResults.Insert();
                    until QCSpecificationLine.next = 0;
                end;
                CurrPage.Update(true);
            until QAShipmentLotNo.Next() = 0;
    end;

    procedure ExternalSpecCheck_Action()
    begin
        //IsQACheckAllowed
        Rec.IsQACheckAllowed();

        //CheckRemark_Input
        Rec.CheckRemark_Input();

        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);

    end;

    procedure COAApprove_Action()
    begin
        //IsQAApproveAllowed
        Rec.IsQAApproveAllowed();

        //ApprovedRemark_Input
        Rec.ApprovedRemark_Input();

        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);
    end;

    procedure COAReject_Action()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin
        //IsQARejectAllowed
        Rec.IsQARejectAllowed();
        //Enable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable);

        Rec."QA Status" := Rec."QA Status"::Rejected;
        Rec.Modify();

        QAShipmentLotNo.Reset();
        QAShipmentLotNo.SetRange("COA No.");
        QAShipmentLotNo.ModifyAll("QA Status", Rec."QA Status"::Rejected);

    end;

    procedure COAPrint_Action()
    var
        QAHeader: Record "RV QA Header";
    begin
        CurrPage.SetSelectionFilter(QAHeader);
        REPORT.RUN(Report::"RV_COA Report", true, false, QAHeader);
    end;

}