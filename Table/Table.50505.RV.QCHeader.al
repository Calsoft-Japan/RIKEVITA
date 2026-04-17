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
            ValuesAllowed = 0, 1;
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
                RIKEVITASetup: Record "RIKEVITA Setup";
            begin

                if Rec."Ref. Order Type" = RefOrderType::"Purchase Order" then begin
                    Purchaseline.Reset();
                    Purchaseline.SetRange("Document Type", Purchaseline."Document Type"::Order);
                    if (Page.RunModal(Page::"Purchase Lines", Purchaseline) = Action::LookupOK) then begin
                        "Order No." := Purchaseline."Document No.";
                        "Line No." := Purchaseline."Line No.";
                        "Item No." := Purchaseline."No.";
                        PurchaseHeader.get(Purchaseline."Document Type"::Order, Purchaseline."Document No.");
                        "Customer No." := PurchRcptHeader."Sell-to Customer No.";
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

                        PurchRcptHeader.get(PurchRcptLine."Document No.");
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
                        //"Customer No." := ProdOrderLine."Buy-from Vendor No.";
                        ProductionOrder.get(ProductionOrder.Status::Released, ProdOrderLine."Prod. Order No.");
                        //"Ship-to Code" := ProdOrderLine."Ship-to Code";
                        //"Ship-to Country" := PurchRcptHeader."Ship-to Country/Region Code";
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

            /*
            trigger OnLookup()
            var
                ReservationEntry: Record "Reservation Entry";
                //TrackingLinesPage: Page "Item Tracking Lines";
                RefOrderType: Enum "RV Ref. Order Type";
                Purchaseline: Record "Purchase line";
                JobPlanningLine: Record "Job Planning Line";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                
                if "Ref. Order Type" = RefOrderType::"Purchase Order" then begin
                    Purchaseline.get(Purchaseline."Document Type"::Order, "Order No.", "Line No.");
                    ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                    ReservationEntry.SetRange("Source Subtype", Purchaseline."Document Type".AsInteger());
                    ReservationEntry.SetRange("Source Ref. No.", Purchaseline."Line No.");
                    if not ReservationEntry.IsEmpty then begin
                        Page.RunModal(Page::"Item Tracking Lines", ReservationEntry);
                    end else begin
                        Message('No Lot Numbers have been assigned to this line yet.');
                    end;
                end else if "Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin
                    PurchRcptLine.get("Order No.", "Line No.");
                    ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                    ItemLedgerEntry.SetRange("Document No.", PurchRcptLine."Document No.");
                    ItemLedgerEntry.SetRange("Document Line No.", PurchRcptLine."Line No.");

                    if not ItemLedgerEntry.IsEmpty then begin
                        Page.RunModal(Page::"Item Ledger Entries", ItemLedgerEntry);
                    end else begin
                        Message('No Lot Numbers were recorded for this receipt line.');
                    end;
                end else if "Ref. Order Type" = RefOrderType::"Production Order" then begin



                    JobPlanningLine.get(Purchaseline."Document Type"::Order, "Order No.", "Job Task No.", "Line No.");
                    ReservationEntry.SetRange("Source Type", Database::"Job Planning Line");
                    // Note: Job Planning Lines don't use Subtypes like Purchase (0/1/2)
                    // They usually map Source Subtype to 0
                    ReservationEntry.SetRange("Source Subtype", 0);
                    ReservationEntry.SetRange("Source ID", JobPlanningLine."Job No.");
                    ReservationEntry.SetRange("Source Ref. No.", JobPlanningLine."Line No.");
                    ReservationEntry.SetRange("Source Batch Name", JobPlanningLine."Job Task No.");

                    if not ReservationEntry.IsEmpty then begin
                        Page.RunModal(Page::"Item Tracking Lines", ReservationEntry);
                    end else begin
                        Message('No Lot Numbers are currently tracked/reserved for this Project Planning Line.');
                    end;
                end;
                
            end;
            */

        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            /*
            trigger OnLookup()
            var
                RefOrderType: Enum "RV Ref. Order Type";
                Purchaseline: Record "Purchase line";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                JobPlanningLine: Record "Job Planning Line";
            begin

                if "Ref. Order Type" = RefOrderType::"Purchase Order" then begin

                    Purchaseline.Reset();
                    Purchaseline.SetRange("Document Type", Purchaseline."Document Type"::Order);
                    Purchaseline.SetRange("Document No.", "Order No.");
                    if (Page.RunModal(Page::"Purchase Lines", Purchaseline) = Action::LookupOK) then begin
                        "Order No." := Purchaseline."Document No.";
                        "Line No." := Purchaseline."Line No.";
                    end;

                end else if "Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin

                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Document No.", "Order No.");
                    if (Page.RunModal(Page::"Posted Purchase Receipt Lines", PurchRcptLine) = Action::LookupOK) then begin
                        "Order No." := PurchRcptLine."Document No.";
                        "Line No." := PurchRcptLine."Line No.";
                    end;

                end else if "Ref. Order Type" = RefOrderType::"Production Order" then begin

                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", "Order No.");
                    if (Page.RunModal(Page::"Job Planning Lines", JobPlanningLine) = Action::LookupOK) then begin
                        "Order No." := JobPlanningLine."Document No.";
                        "Line No." := JobPlanningLine."Line No.";
                        "Job Task No." := JobPlanningLine."Job Task No.";

                    end;

                end;
            end;

            trigger OnValidate()
            var
                QCLine: Record "RV QC Line";
            begin
                "Lot No." := '';

                QCLine.SetRange("QC No.", "QC No.");
                QCLine.DeleteAll();

            end;
            */
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
        field(15; "Tan No."; Code[10])
        {
            Caption = 'Tan No.';
            TableRelation = Location;
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
        RIKEVITASetup: Record "RIKEVITA Setup";
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
    begin
        DocumentAttachment.SetRange("Table ID", Database::"RV QC Header");
        DocumentAttachment.SetRange("No.", Rec."QC No.");
        if not DocumentAttachment.IsEmpty then
            DocumentAttachment.DeleteAll();
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

        if "QC Approved By" <> '' then
            Error('You cannot check because it has been approved.');
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
            Error('You need to Check before Approve');
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
        QCParameter: Record "RV QC Parameter";
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

        //QCGroupApply
        if not QCResourceGroupApply.Get("Item No.") then
            Error('Please Setup QC Resource Group Apply');

        //QCGroup
        QCGroup.Reset();
        QCGroup.SetRange("QC Resource Group No.", QCResourceGroupApply."QC Resource Group No.");
        QCGroup.SetFilter("Effective Date", '%1 | %2..', 0D, WorkDate());
        if QCGroup.Find('-') then begin

            //currSpecification
            Clear(currSpecification);
            if "QC Standard Type" = QCStandardType::Internal then
                currSpecification := QCGroup."Internal Specification"
            else if "QC Standard Type" = QCStandardType::External then
                currSpecification := QCGroup."External Specification";
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
                if QCParameter.Get(QCSpecificationLine."QC Parameter Name") then begin
                    QCLine."QC Parameter Name" := QCParameter."Parameter Name";
                    QCLine.Type := QCParameter.Type;
                    QCLine."Value Table Type" := QCParameter."Value Table Type";
                end;
                QCLine.Insert();
            until QCSpecificationLine.Next() = 0;
    end;

}