/// <summary>
/// Table RV QC Header (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50505 "RV QC Header"
{
    Caption = 'QC Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC No."; Code[20])
        {
            Caption = 'QC No.';
        }
        field(2; "QC Type"; Enum "RV QC Type")
        {
            Caption = 'QC Type';
        }

        field(3; "Ref. Order Type"; Enum "RV Ref. Order Type")
        {
            Caption = 'Ref. Order Type';
            trigger OnValidate()
            begin
                if (xRec."Ref. Order Type" <> Rec."Ref. Order Type") then begin
                    "Order No." := '';
                    "Item No." := '';
                    "Lot No." := '';
                    ClearHeaderData();
                    ClearQCLine();
                end;
            end;
        }

        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';

            trigger OnLookup()
            var
                RefOrderType: Enum "RV Ref. Order Type";
                PurchaseHeader: Record "Purchase Header";
                Purchaseline: Record "Purchase line";
                PurchRcptHeader: Record "Purch. Rcpt. Header";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                ProductionOrder: Record "Production Order";
                ProdOrderLine: Record "Prod. Order Line";
                RIKEVITASetup: Record "RV RIKEVITA Setup";
            begin

                if Rec."Ref. Order Type" = RefOrderType::"Purchase Order" then begin
                    Purchaseline.Reset();
                    Purchaseline.SetRange("Document Type", Purchaseline."Document Type"::Order);
                    if (Page.RunModal(Page::"Purchase Lines", Purchaseline) = Action::LookupOK) then begin
                        "Order No." := Purchaseline."Document No.";
                        "Line No." := Purchaseline."Line No.";
                        "Item No." := Purchaseline."No.";
                        "Item Description" := Purchaseline.Description;
                        "Vendor No." := Purchaseline."Buy-from Vendor No.";
                        PurchaseHeader.get(Purchaseline."Document Type"::Order, Purchaseline."Document No.");
                        "Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                        "Customer No." := PurchaseHeader."Sell-to Customer No.";
                        "Ship-to Code" := PurchaseHeader."Ship-to Code";
                        "Ship-to Country" := PurchaseHeader."Ship-to Country/Region Code";
                        Modify();
                    end;
                end else if Rec."Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin

                    PurchRcptLine.Reset();
                    if (Page.RunModal(Page::"Posted Purchase Receipt Lines", PurchRcptLine) = Action::LookupOK) then begin
                        "Order No." := PurchRcptLine."Document No.";
                        "Line No." := PurchRcptLine."Line No.";
                        "Item No." := PurchRcptLine."No.";
                        "Item Description" := PurchRcptLine.Description;
                        "Vendor No." := PurchRcptLine."Buy-from Vendor No.";
                        PurchRcptHeader.get(PurchRcptLine."Document No.");
                        "Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                        "Customer No." := PurchRcptHeader."Sell-to Customer No.";
                        "Ship-to Code" := PurchRcptHeader."Ship-to Code";
                        "Ship-to Country" := PurchRcptHeader."Ship-to Country/Region Code";
                        Modify();
                    end;
                end else if Rec."Ref. Order Type" = RefOrderType::"Production Order" then begin

                    ProdOrderLine.Reset();
                    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
                    RIKEVITASetup.Get();
                    if "QC Type" = "QC Type"::FQC then begin
                        RIKEVITASetup.TestField("FP Inventory Posting Group");
                        ProdOrderLine.SetRange("Inventory Posting Group", RIKEVITASetup."FP Inventory Posting Group");
                    end else if "QC Type" = "QC Type"::PQC then begin
                        RIKEVITASetup.TestField("WIP Inventory Posting Group");
                        ProdOrderLine.SetRange("Inventory Posting Group", RIKEVITASetup."WIP Inventory Posting Group");
                    end;

                    if (Page.RunModal(Page::"Prod. Order Line List", ProdOrderLine) = Action::LookupOK) then begin
                        "Order No." := ProdOrderLine."Prod. Order No.";
                        "Line No." := ProdOrderLine."Line No.";
                        "Item No." := ProdOrderLine."Item No.";
                        "Item Description" := ProdOrderLine.Description;
                        "Location Code" := ProdOrderLine."Location Code";
                        "Bin Code" := ProdOrderLine."Bin Code";
                        ProductionOrder.get(ProductionOrder.Status::Released, ProdOrderLine."Prod. Order No.");
                        Modify();
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if Rec."Order No." <> xRec."Order No." then
                    Error('Manual entry is not allowed. Please use the Lookup button.');
            end;
        }

        field(5; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            trigger OnLookup()
            var
                RefOrderType: Enum "RV Ref. Order Type";
                Purchaseline: Record "Purchase line";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                ItemLedgerEntry: Record "Item Ledger Entry";
                ProdOrderLine: Record "Prod. Order Line";
            begin

                if "Ref. Order Type" = RefOrderType::"Purchase Order" then begin
                    //nothing
                end else if "Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin
                    PurchRcptLine.get("Order No.", "Line No.");
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                    ItemLedgerEntry.SetRange("Document No.", PurchRcptLine."Document No.");
                    ItemLedgerEntry.SetRange("Document Line No.", PurchRcptLine."Line No.");
                    itemledgerentry.SetRange(Correction, false);

                    if (Page.RunModal(Page::"Item Ledger Entries", ItemLedgerEntry) = Action::LookupOK) then begin
                        Validate("Lot No.", ItemLedgerEntry."Lot No.");
                    end;

                end else if "Ref. Order Type" = RefOrderType::"Production Order" then begin

                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                    ItemLedgerEntry.SetRange("Order No.", "Order No.");
                    ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                    ItemLedgerEntry.SetFilter("Quantity", '>0');

                    if (Page.RunModal(Page::"Item Ledger Entries", ItemLedgerEntry) = Action::LookupOK) then begin
                        Validate("Lot No.", ItemLedgerEntry."Lot No.");
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Lot No." <> '' then
                    CheckDuplicate();
            end;
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(7; "QC Date"; Date)
        {
            Caption = 'QC Date';
        }
        field(8; "QC Standard Type"; Enum "RV QC Standard Type")
        {
            Caption = 'QC Standard Type';
        }

        field(9; "QC Status"; Enum "RV QC Status")
        {
            Caption = 'QC Status';
        }
        field(10; "QC Checked By"; Text[50])
        {
            Caption = 'QC Checked By';
        }
        field(11; "QC Approved By"; Text[50])
        {
            Caption = 'QC Approved By';
        }
        field(12; "QC Checked Remark"; Text[150])
        {
            Caption = 'QC Checked Remark';
        }
        field(13; "QC Approved Remark"; Text[150])
        {
            Caption = 'QC Approved Remark';
        }
        field(14; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }

        field(15; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(16; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
        }
        field(17; "Item Description"; Text[150])
        {
            Caption = 'Item Description';
        }
        field(18; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(19; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(20; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(100; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(101; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(102; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
        }
        field(103; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
        }
        field(104; "QC Comment"; Text[250])
        {
            Caption = 'QC Comment';
        }
    }
    keys
    {
        key(PK; "QC No.", "QC Type")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        "QC Date" := Today;
        RIKEVITASetup.Get();

        case "QC Type" of
            "QC Type"::IQC:
                begin
                    RIKEVITASetup.TestField("IQC No. Nos.");
                    if "QC No." = '' then
                        "QC No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."IQC No. Nos.");
                end;

            "QC Type"::PQC:
                begin
                    RIKEVITASetup.TestField("PQC No. Nos.");
                    if "QC No." = '' then
                        "QC No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."PQC No. Nos.");
                end;

            "QC Type"::FQC:
                begin
                    RIKEVITASetup.TestField("FQC No. Nos.");
                    if "QC No." = '' then
                        "QC No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."FQC No. Nos.");
                end;
        end;
    end;

    trigger OnDelete()
    var
        DocumentAttachment: Record "Document Attachment";
        QCline: Record "RV QC line";
        QCInyResultLine: Record "RV QC Iny. Result Line";
    begin
        DocumentAttachment.SetRange("Table ID", Database::"RV QC Header");
        DocumentAttachment.SetRange("No.", Rec."QC No.");
        if not DocumentAttachment.IsEmpty then
            DocumentAttachment.DeleteAll();

        QCline.Reset();
        QCline.LockTable();
        QCline.SetRange("QC No.", Rec."QC No.");
        QCline.SetRange("QC Type", Rec."QC Type");
        QCline.DeleteAll(true);

        QCInyResultLine.Reset();
        QCInyResultLine.LockTable();
        QCInyResultLine.SetRange("QC No.", Rec."QC No.");
        QCInyResultLine.SetRange("QC Type", Rec."QC Type");
        QCInyResultLine.DeleteAll(true);
    end;

    procedure IsQCCheckAllowed(): Boolean
    var
        UserSetup: Record "User Setup";
        TextCheckErr: Label 'You don''t have permission to Check!';
    begin

        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QC Check" then
                Error(TextCheckErr);
        end else
            Error(TextCheckErr);
    end;

    procedure IsQCApproveAllowed()
    var
        UserSetup: Record "User Setup";
        TextApproveErr: Label 'You don''t have permission to Approve!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QC Approve" then
                Error(TextApproveErr);
        end else
            Error(TextApproveErr);

        if "QC Checked By" = '' then
            Error('You need to Check before Approve.');
    end;

    procedure IsQCReverseAllowed()
    var
        UserSetup: Record "User Setup";
        TextReverseErr: Label 'You don''t have permission to Reverse!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QC Reverse" then
                Error(TextReverseErr);
        end else
            Error(TextReverseErr);

        if "QC Status" in ["QC Status"::Analyzing, "QC Status"::Checked] then
            Error('You can not Reverse, because you need approval or Reject.')
    end;

    procedure CheckRemark_Input()
    var
        UserSetup: Record "User Setup";
        RVQCRemarkInput: Page "RV QC Remark Input";
        RemarkText: array[2] of Text;
    begin
        //Page
        Clear(RVQCRemarkInput);
        Clear(RemarkText);
        RemarkText[1] := Rec."QC Checked Remark";// Remark
        RemarkText[2] := 'QC Check Remark'; //Caption       

        RVQCRemarkInput.Caption := 'QC Check Remark';
        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            "QC Status" := Rec."QC Status"::Checked;
            "QC Checked Remark" := RemarkText[1];// set Remark
            "QC Checked By" := UserId;
            Modify();
        end;
    end;

    procedure ApprovedRemark_Input()
    var
        UserSetup: Record "User Setup";
        RVQCRemarkInput: Page "RV QC Remark Input";
        RemarkText: array[2] of Text;
    begin
        //Page
        Clear(RVQCRemarkInput);
        Clear(RemarkText);
        RemarkText[1] := Rec."QC Approved Remark";// MarkText
        RemarkText[2] := 'QC Approved Remark'; //Caption       

        RVQCRemarkInput.Caption := 'QC Approved Remark';
        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            Rec."QC Status" := Rec."QC Status"::Approved;
            Rec."QC Approved Remark" := RemarkText[1];// set Remark
            rec."QC Approved By" := UserId;
            Modify();
        end;
    end;

    procedure ClearHeaderData()
    begin
        "Order No." := '';
        "Item No." := '';
        "Lot No." := '';
        "Location Code" := '';
        "Bin Code" := '';
        "QC Date" := 0D;

        "QC Standard Type" := "QC Standard Type"::Internal;
        "QC Status" := "QC Status"::Analyzing;
        "QC Checked By" := '';
        "QC Checked Remark" := '';
        "QC Approved By" := '';
        "QC Approved Remark" := '';
    end;

    procedure ClearQCLine()
    var
        QCLine: Record "RV QC Line";
    begin
        //clear QCLine
        QCLine.SetRange("QC No.", Rec."QC No.");
        QCLine.SetRange("QC Type", Rec."QC Type");
        QCLine.DeleteAll();
    end;

    procedure CreateQCLine()
    var
        QCLine: Record "RV QC Line";
        //ResourceQCGroup: Record "RV Resource QC Group";
        //TempResourceQCGroup: Record "RV Resource QC Group" temporary;
        QCResourceGroupApply: Record "RV QC Resource Group Apply";
        //QCCustExterSpec: Record "RV QC Customer External Spec.";
        //TempQCCustExterSpec: Record "RV QC Customer External Spec." temporary;

        QCGroup: Record "RV QC Resource Group";
        QCSpecificationLine: Record "RV QC Specification Line";
        //QCParameter: Record "RV QC Parameter";
        QCListValue: Record "RV Specification Value Setting";
        SpecValueSetting: Record "RV Specification Value Setting";
        QCStandardType: enum "RV QC Standard Type";
        LineNo: Integer;
        currSpecification: Code[20];
        ConfirmChangeLineQst: Label 'The detail line already exists.Do you want to recreate detail line?';
    begin
        QCLine.Reset();
        QCLine.SetRange("QC No.", Rec."QC No.");
        QCLine.SetRange("QC Type", Rec."QC Type");
        if not QCLine.IsEmpty then begin
            if not Confirm(StrSubstNo(ConfirmChangeLineQst), false) then
                exit;
            //clear QCLine
            QCLine.DeleteAll();
        end;

        Clear(currSpecification);
        Clear(LineNo);

        //Item No.
        if "Item No." = '' then
            Error('Please Input Item No.');

        //QCGroupApply
        if not QCResourceGroupApply.Get("Item No.") then
            Error('Please Setup QC Resource Group Apply.');

        //QCGroup
        QCGroup.Reset();
        QCGroup.SetCurrentKey("QC Resource Group No.", "Effective Date");
        QCGroup.SetRange("QC Resource Group No.", QCResourceGroupApply."QC Resource Group No.");
        QCGroup.SetFilter("Effective Date", '%1 | ..%2', 0D, WorkDate());
        if QCGroup.Find('+') then begin

            //currSpecification
            Clear(currSpecification);
            if "QC Standard Type" = QCStandardType::Internal then
                currSpecification := QCGroup."Internal Specification"
            else if "QC Standard Type" = QCStandardType::External then
                currSpecification := QCGroup."External Specification";
        end else begin
            Error('No QC specifications were found for item %1.', "Item No.");
        end;

        //QCSpecificationLine
        QCSpecificationLine.Reset();
        QCSpecificationLine.SetRange("QC Specification Name", currSpecification);
        if QCSpecificationLine.FindSet() then
            repeat
                //QCLine
                LineNo := LineNo + 10000;
                QCLine.Init();
                QCLine."QC Type" := "QC Type";
                QCLine."QC No." := "QC No.";
                QCLine."Line No." := LineNo;
                //QCParameter
                //QCParameter.Reset();
                //QCParameter.Get(QCSpecificationLine."QC Parameter Name");
                //QCParameter.CalcFields(Type, "Value Table Type");
                QCLine."QC Specification Name" := QCSpecificationLine."QC Specification Name";
                QCLine."QC Parameter Name" := QCSpecificationLine."QC Parameter Name";
                QCLine.Type := QCSpecificationLine.Type;
                QCLine."Value Table Type" := QCSpecificationLine."Value Table Type";
                QCLine."Value Table Name" := QCSpecificationLine."Value Table Name";
                if QCLine."Value Table Type" = QCLine."Value Table Type"::Single then begin
                    SpecValueSetting.Reset();
                    SpecValueSetting.SetRange("QC Specification Name", QCLine."QC Specification Name");
                    SpecValueSetting.SetRange("QC Parameter Name", QCLine."QC Parameter Name");
                    SpecValueSetting.SetRange("Value Table Name", QCLine."Value Table Name");
                    if SpecValueSetting.FindFirst() then begin
                        QCLine."QC Value" := SpecValueSetting."List Value";
                        QCLine."Check Status" := SpecValueSetting."Check Status";
                    end;
                    //end;
                end;
                QCLine.Insert();
            until QCSpecificationLine.Next() = 0;
    end;


    procedure SetQCEnable(var CreateQCLineEnable: Boolean; var QCCheckEnable: Boolean; var QCApproveEnable: Boolean; var QCReverseEnable: Boolean;
                            var SubQCLineEnable: Boolean; var SubInventoryResultEnable: Boolean; var QCCardEnable: Boolean)
    begin

        CASE Rec."QC Status" OF
            (Rec."QC Status"::Analyzing):
                begin

                    CreateQCLineEnable := true;
                    QCCheckEnable := true;
                    QCApproveEnable := false;
                    QCReverseEnable := false;

                    SubQCLineEnable := true;
                    SubInventoryResultEnable := true;
                    QCCardEnable := true;
                end;
            (Rec."QC Status"::Checked):
                begin
                    CreateQCLineEnable := false;
                    QCCheckEnable := false;
                    QCApproveEnable := true;
                    QCReverseEnable := false;

                    SubQCLineEnable := true;
                    SubInventoryResultEnable := true;
                    QCCardEnable := true;
                end;
            (Rec."QC Status"::Approved):
                begin
                    CreateQCLineEnable := false;
                    QCCheckEnable := false;
                    QCApproveEnable := false;
                    QCReverseEnable := true;

                    SubQCLineEnable := false;
                    SubInventoryResultEnable := false;
                    QCCardEnable := false;
                end;
            (Rec."QC Status"::Rejected):
                begin
                    CreateQCLineEnable := false;
                    QCCheckEnable := false;
                    QCApproveEnable := false;
                    QCReverseEnable := true;

                    SubQCLineEnable := false;
                    SubInventoryResultEnable := false;
                    QCCardEnable := false;
                end;
        END;

    end;

    local procedure CheckDuplicate()
    var
        QCHeader: Record "RV QC Header";
    begin
        QCHeader.Reset();
        QCHeader.SetRange("Item No.", Rec."Item No.");
        QCHeader.SetRange("Lot No.", Rec."Lot No.");

        if Rec."QC No." <> '' then
            QCHeader.SetFilter("QC No.", '<>%1', Rec."QC No.");

        if not QCHeader.IsEmpty() then
            Error('Item %1 and Lot No. %2 have already been inspected; please confirm.', "Item No.", "Lot No.");
    end;

    procedure CheckFail(): Boolean
    var
        QCline: Record "RV QC line";
        ConfirmCheckFail: Label 'QC results has failed case, Do you continue?';
    begin
        QCline.Reset();
        QCline.SetRange("QC No.", Rec."QC No.");
        QCline.SetRange("QC Type", Rec."QC Type");
        QCline.SetRange("Check Status", QCline."Check Status"::FAILED);
        if not QCline.IsEmpty() then begin
            if CONFIRM(ConfirmCheckFail) then
                EXIT(false)
            else
                EXIT(true);
        end else
            EXIT(false);
    end;

    procedure CheckInit()
    var
        QCline: Record "RV QC line";
        ErrorCheckInit: Label 'QC results has Init data, please check and correct before continuing.';
    begin
        QCline.Reset();
        QCline.SetRange("QC No.", Rec."QC No.");
        QCline.SetRange("QC Type", Rec."QC Type");
        IF QCLine.IsEmpty then
            error('QC results has no data, please enter QC line before continuing.');
        QCline.SetRange("Check Status", QCline."Check Status"::Init);
        if not QCline.IsEmpty() then
            Error(ErrorCheckInit);
    end;
}