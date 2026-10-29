/// <summary>
/// Table RV QC Header (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50505 "RV QC Header"
{
    Caption = 'QC Header';
    DataClassification = CustomerContent;
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD;
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
                    RIKEVITASetup.Get();
                    Purchaseline.Reset();
                    Purchaseline.SetRange("Document Type", Purchaseline."Document Type"::Order);
                    if (Page.RunModal(Page::"Purchase Lines", Purchaseline) = Action::LookupOK) then begin

                        if Purchaseline."Quantity received" > 0 then
                            error('The purchase has already been received. please use the Posted Purchase Receipt for IQC.');

                        "Order No." := Purchaseline."Document No.";
                        "Line No." := Purchaseline."Line No.";
                        "Item No." := Purchaseline."No.";
                        "Item Description" := Purchaseline.Description;
                        "Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        "Location Code" := Purchaseline."Location Code";
                        "Bin Code" := Purchaseline."Bin Code";
                        PurchaseHeader.get(Purchaseline."Document Type"::Order, Purchaseline."Document No.");
                        "Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                        "Customer No." := PurchaseHeader."Sell-to Customer No.";
                        "Ship-to Code" := PurchaseHeader."Ship-to Code";
                        "Ship-to Country" := PurchaseHeader."Ship-to Country/Region Code";
                        "Quantity" := Purchaseline."Quantity";
                        "UOM" := Purchaseline."unit of Measure Code";
                        "Quantity (Base)" := Purchaseline."Quantity (Base)";
                        rec."NC Bin Code" := RIKEVITASetup."NC Bin Code";
                        rec."NC Location Code" := RIKEVITASetup."NC Location Code";
                        Modify();
                    end;
                end else if Rec."Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin
                    RIKEVITASetup.Get();
                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
                    PurchRcptLine.SetRange("RV_IQC Status", false);
                    if (Page.RunModal(Page::"Posted Purchase Receipt Lines", PurchRcptLine) = Action::LookupOK) then begin
                        "Order No." := PurchRcptLine."Document No.";
                        "Line No." := PurchRcptLine."Line No.";
                        "Item No." := PurchRcptLine."No.";
                        "Item Description" := PurchRcptLine.Description;
                        "Vendor No." := PurchRcptLine."Buy-from Vendor No.";
                        "Location Code" := PurchRcptLine."Location Code";
                        "Bin Code" := PurchRcptLine."Bin Code";
                        PurchRcptHeader.get(PurchRcptLine."Document No.");
                        "Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                        "Customer No." := PurchRcptHeader."Sell-to Customer No.";
                        "Ship-to Code" := PurchRcptHeader."Ship-to Code";
                        "Ship-to Country" := PurchRcptHeader."Ship-to Country/Region Code";
                        "Quantity" := PurchRcptLine."Quantity";
                        "UOM" := PurchRcptLine."unit of Measure Code";
                        "Quantity (Base)" := PurchRcptLine."Quantity (Base)";
                        "Lot No." := '';
                        CLEAR("RM Manufacture Date");
                        CLEAR("Expiration Date");
                        "NC Bin Code" := RIKEVITASetup."NC Bin Code";
                        "NC Location Code" := RIKEVITASetup."NC Location Code";
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
                        "Quantity" := ProdOrderLine."Quantity";
                        "UOM" := ProdOrderLine."unit of Measure Code";
                        "Quantity (Base)" := ProdOrderLine."Quantity (Base)";
                        ProductionOrder.get(ProductionOrder.Status::Released, ProdOrderLine."Prod. Order No.");
                        CLEAR("RM Manufacture Date");
                        CLEAR("Expiration Date");
                        "NC Bin Code" := RIKEVITASetup."NC Bin Code";
                        "NC Location Code" := RIKEVITASetup."NC Location Code";
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

        field(5; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            trigger OnLookup()
            var
                Purchaseline: Record "Purchase line";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                ItemLedgerEntry: Record "Item Ledger Entry";
                LotItemLedgerEntry: Record "Item Ledger Entry";
                ProdOrderLine: Record "Prod. Order Line";
                CompletedLotNos: List of [Code[50]];
                QCHeader: Record "RV QC Header";
                GetManufacturingDate: Codeunit "RV Whse. Posting Subscriber";
            begin

                case "Ref. Order Type" of
                    "Ref. Order Type"::"Posted Purchase Receipt":
                        begin
                            PurchRcptLine.get("Order No.", "Line No.");
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                            ItemLedgerEntry.SetRange("Document No.", PurchRcptLine."Document No.");
                            ItemLedgerEntry.SetRange("Document Line No.", PurchRcptLine."Line No.");
                            ItemLedgerEntry.SetRange("Item No.", PurchRcptLine."No.");
                            ItemLedgerEntry.SetRange(Correction, false);
                            if (PurchRcptLine."RV_IQC Status") or
                               ((PurchRcptLine."Quantity (Base)" > 0) and
                                (PurchRcptLine."RV_IQC Quantity" >= PurchRcptLine."Quantity (Base)"))
                            then begin
                                ItemLedgerEntry.SetRange("Lot No.", '');
                            end else begin
                                QCHeader.SetRange("QC Type", QCHeader."QC Type"::IQC);
                                QCHeader.SetRange("Ref. Order Type", QCHeader."Ref. Order Type"::"Posted Purchase Receipt");
                                QCHeader.SetRange("Order No.", PurchRcptLine."Document No.");
                                QCHeader.SetRange("Line No.", PurchRcptLine."Line No.");
                                QCHeader.SetRange("Item No.", PurchRcptLine."No.");
                                QCHeader.SetFilter("QC Status", '%1|%2', QCHeader."QC Status"::Approved, QCHeader."QC Status"::Rejected);
                                if QCHeader.FindSet() then
                                    repeat
                                        if QCHeader."Lot No." <> '' then
                                            if not CompletedLotNos.Contains(QCHeader."Lot No.") then
                                                CompletedLotNos.Add(QCHeader."Lot No.");
                                    until QCHeader.Next() = 0;

                                ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                                ItemLedgerEntry.ClearMarks();
                                if ItemLedgerEntry.FindSet() then
                                    repeat
                                        ItemLedgerEntry.Mark(not CompletedLotNos.Contains(ItemLedgerEntry."Lot No."));
                                    until ItemLedgerEntry.Next() = 0;
                                ItemLedgerEntry.MarkedOnly(true);
                            end;
                            ItemLedgerEntry.MarkedOnly(true);
                            if (Page.RunModal(Page::"RV Item Ledger Entries", ItemLedgerEntry) = Action::LookupOK) then begin
                                Validate("Lot No.", ItemLedgerEntry."Lot No.");
                                GetManufacturingDate.GetManufacturingDate(itemledgerentry."Item No.", ItemLedgerEntry."Lot No.", "Manufacturing Date");
                                "Expiration Date" := ItemLedgerEntry."Expiration Date";
                                LotItemLedgerEntry.SetRange("Document Type", LotItemLedgerEntry."Document Type"::"Purchase Receipt");
                                LotItemLedgerEntry.SetRange("Document No.", PurchRcptLine."Document No.");
                                LotItemLedgerEntry.SetRange("Document Line No.", PurchRcptLine."Line No.");
                                LotItemLedgerEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                LotItemLedgerEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                LotItemLedgerEntry.SetRange(Correction, false);
                                LotItemLedgerEntry.CalcSums(Quantity);
                                "Quantity (Base)" := LotItemLedgerEntry.Quantity;
                                if ItemLedgerEntry."Qty. per Unit of Measure" <> 0 then
                                    Quantity := LotItemLedgerEntry.Quantity / ItemLedgerEntry."Qty. per Unit of Measure";
                                "UOM" := ItemLedgerEntry."Unit of Measure Code";
                            end;
                        end;
                    "Ref. Order Type"::"Production Order":
                        begin
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                            ItemLedgerEntry.SetRange("Order No.", "Order No.");
                            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                            ItemLedgerEntry.SetFilter("Quantity", '>0');

                            if (Page.RunModal(Page::"RV Item Ledger Entries", ItemLedgerEntry) = Action::LookupOK) then begin
                                Validate("Lot No.", ItemLedgerEntry."Lot No.");
                                "Manufacturing Date" := ItemLedgerEntry."Posting Date";
                                "Expiration Date" := ItemLedgerEntry."Expiration Date";

                                "Quantity (Base)" := ItemLedgerEntry.Quantity;
                                if ItemLedgerEntry."Qty. per Unit of Measure" <> 0 then
                                    Quantity := ItemLedgerEntry.Quantity / ItemLedgerEntry."Qty. per Unit of Measure";
                                "UOM" := ItemLedgerEntry."Unit of Measure Code";
                            end;
                        end;
                End;
            end;

            trigger OnValidate()
            var
                LotNoInformation: Record "Lot No. Information";
                ItemLedgerEntry: Record "Item Ledger Entry";
                GetManufacturingDate: Codeunit "RV Whse. Posting Subscriber";
            begin

                if "Lot No." <> '' then
                    CheckDuplicate();

                if "Lot No." <> '' then begin
                    if "Ref. Order Type" in ["Ref. Order Type"::"Purchase Order", "Ref. Order Type"::"Posted Purchase Receipt"] then begin
                        //LotNoInformation
                        LotNoInformation.Reset();
                        LotNoInformation.SetRange("Item No.", "Item No.");
                        LotNoInformation.SetRange("Lot No.", "Lot No.");
                        if not LotNoInformation.FindFirst() then
                            LotNoInformation.Init();
                        "RM Manufacture Date" := LotNoInformation."RV_Manufacture Date";
                    end else begin
                        GetManufacturingDate.GetManufacturingDate("Item No.", "Lot No.", "Manufacturing Date");
                    end;
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Item No.", "Item No.");
                    itemledgerentry.SetRange("Lot No.", "Lot No.");
                    if itemledgerentry.FindFirst() then
                        "Expiration Date" := itemledgerentry."Expiration Date";

                end else begin
                    Clear("RM Manufacture Date");
                end;
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
        field(21; "RM Manufacture Date"; Date)
        {
            Caption = 'RM Manufacture Date';
        }
        field(22; "QC Checked Date"; Date)
        {
            Caption = 'QC Checked Date';
        }
        field(23; "QC Approved Date"; Date)
        {
            Caption = 'QC Approved Date';
        }
        field(24; "QC Rejected Remark"; Text[150])
        {
            Caption = 'QC Rejected Remark';
        }
        field(25; "QC Rejected Date"; Date)
        {
            Caption = 'QC Rejected Date';
        }
        field(26; "QC Rejected By"; Text[50])
        {
            Caption = 'QC Rejected By';
        }
        field(27; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(28; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = "Unit of Measure";
        }
        field(29; "Storage Bin Code"; Code[20])
        {
            Caption = 'Storage Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
        }
        field(30; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(31; "NC Location Code"; Code[10])
        {
            Caption = 'NC Location Code';
            TableRelation = Location;
        }
        field(32; "NC Bin Code"; Code[20])
        {
            Caption = 'NC Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("NC Location Code"));
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
        NCHeader: Record "RV NC Header";
    begin
        DocumentAttachment.SetRange("Table ID", Database::"RV QC Header");
        DocumentAttachment.SetRange("No.", Rec."QC No.");
        if not DocumentAttachment.IsEmpty then
            DocumentAttachment.DeleteAll();

        QCline.Reset();
        QCline.SetRange("QC No.", Rec."QC No.");
        QCline.SetRange("QC Type", Rec."QC Type");
        QCline.DeleteAll(true);

        if ("QC Type" = "QC Type"::IQC) and
           ("Ref. Order Type" = "Ref. Order Type"::"Posted Purchase Receipt")
        then
            RecalculatePostedReceiptIQCProgress("Order No.", "Line No.", "Item No.", "QC No.");

        QCInyResultLine.Reset();
        QCInyResultLine.SetRange("QC No.", Rec."QC No.");
        QCInyResultLine.SetRange("QC Type", Rec."QC Type");
        QCInyResultLine.DeleteAll(true);

        NCHeader.Reset();
        NCHeader.SetRange("QC No.", Rec."QC No.");
        NCHeader.SetRange("QC Type", Rec."QC Type");
        NCHeader.DeleteAll(true);
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
        TextReverseErr2: Label 'Please delete the related non-conformance data before run Reverse!';
        NCHeader: Record "RV NC Header";
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QC Reverse" then
                Error(TextReverseErr);
        end else
            Error(TextReverseErr);

        if "QC Status" in ["QC Status"::Analyzing, "QC Status"::Checked] then
            Error('You can not Reverse, because you need approval or Reject.');
        //Check the NC data has been created
        NCHeader.Reset();
        NCHeader.SetRange("Ref. Order Type", Rec."Ref. Order Type");
        NCHeader.SetRange("Order No.", Rec."Order No.");
        if not NCHeader.IsEmpty then
            error(TextReverseErr2);


    end;

    procedure IsQCRejectAllowed()
    var
        UserSetup: Record "User Setup";
        TextRejectErr: Label 'You don''t have permission to Reject!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QC Reject" then
                Error(TextRejectErr);
        end else
            Error(TextRejectErr);

        if "QC Checked By" = '' then
            Error('You need to Check before Reject.');
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
            "QC Checked Date" := WorkDate();
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
            rec."QC Approved Date" := WorkDate();
            Modify();
        end;
    end;

    procedure RejectedRemark_Input()
    var
        UserSetup: Record "User Setup";
        RVQCRemarkInput: Page "RV QC Remark Input";
        RemarkText: array[2] of Text;
    begin
        //Page
        Clear(RVQCRemarkInput);
        Clear(RemarkText);
        RemarkText[1] := Rec."QC Rejected Remark";// MarkText
        RemarkText[2] := 'QC Rejected Remark'; //Caption       

        RVQCRemarkInput.Caption := 'QC Rejected Remark';
        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            Rec."QC Status" := Rec."QC Status"::Rejected;
            Rec."QC Rejected Remark" := RemarkText[1];// set Remark
            rec."QC Rejected By" := UserId;
            rec."QC Rejected Date" := WorkDate();
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
        Clear("RM Manufacture Date");
        Clear("Expiration Date");

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
                end else if QCLine."Value Table Type" = QCLine."Value Table Type"::Range then begin
                    QCLine."Minimum Value" := QCSpecificationLine."Minimum Value";
                    QCLine."Maximum Value" := QCSpecificationLine."Maximum Value";
                end;
                QCLine.Insert();
            until QCSpecificationLine.Next() = 0;
    end;

    procedure CreateNCHeader()
    var
        NCHeader: Record "RV NC Header";
    begin
        CreateNCHeaderRecord(NCHeader);

        Page.Run(Page::"RV NC Card", NCHeader);
    end;

    procedure CreateNCHeaderRecord(var NCHeader: Record "RV NC Header")
    var
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        RIKEVITASetup.Get();
        RIKEVITASetup.TestField("NC Location Code");
        if not NCHeader.Get(Rec."QC No.", Rec."QC Type") then begin
            NCHeader.Init();
            NCHeader."QC No." := Rec."QC No.";
            NCHeader."QC Type" := Rec."QC Type";
            NCHeader."Ref. Order Type" := Rec."Ref. Order Type";
            NCHeader."Order No." := Rec."Order No.";
            NCHeader."Lot No." := Rec."Lot No.";
            NCHeader."Item No." := Rec."Item No.";
            NCHeader."Quantity" := Rec."Quantity";
            NCHeader."Expiration Date" := Rec."Expiration Date";
            NCHeader."QC Date" := Rec."QC Date";
            NCHeader."Stock Transfer to Location" := Rec."Location Code";
            NCHeader."Stock Transfer to Bin" := Rec."Storage Bin Code";
            NCHeader."Unit of Measure" := Rec."UOM";
            NCHeader."NC Location Code" := Rec."NC Location Code";
            NCHeader."Inspect Bin Code" := Rec."NC Bin Code";
            NCHeader."QC Checked By" := Rec."QC Checked By";
            NCHeader."QC Checked Remark" := Rec."QC Checked Remark";
            NCHeader."QC Checked Date" := Rec."QC Checked Date";
            NCHeader."QC Rejected By" := Rec."QC Rejected By";
            NCHeader."QC Rejected Remark" := Rec."QC Rejected Remark";
            NCHeader."QC Rejected Date" := Rec."QC Rejected Date";
            NCHeader."QC Comment" := Rec."QC Comment";
            NCHeader."NC Analyzed by" := userid;
            NCHeader."NC Date" := WorkDate();
            NCHeader."NC Status" := NCHeader."NC Status"::Analyzing;
            NCHeader.Insert();
        end;
    end;

    procedure UpdatePostedReceiptIQCProgress()
    begin
        if ("QC Type" <> "QC Type"::IQC) or
           ("Ref. Order Type" <> "Ref. Order Type"::"Posted Purchase Receipt")
        then
            exit;

        RecalculatePostedReceiptIQCProgress("Order No.", "Line No.", "Item No.", '');
    end;

    local procedure RecalculatePostedReceiptIQCProgress(PostedReceiptNo: Code[20]; PostedReceiptLineNo: Integer; ItemNo: Code[20]; ExcludedQCNo: Code[20])
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        QCHeader: Record "RV QC Header";
        CompletedIQCQuantity: Decimal;
    begin
        QCHeader.SetRange("QC Type", QCHeader."QC Type"::IQC);
        QCHeader.SetRange("Ref. Order Type", QCHeader."Ref. Order Type"::"Posted Purchase Receipt");
        QCHeader.SetRange("Order No.", PostedReceiptNo);
        QCHeader.SetRange("Line No.", PostedReceiptLineNo);
        QCHeader.SetRange("Item No.", ItemNo);
        QCHeader.SetFilter("QC Status", '%1|%2', QCHeader."QC Status"::Approved, QCHeader."QC Status"::Rejected);
        if ExcludedQCNo <> '' then
            QCHeader.SetFilter("QC No.", '<>%1', ExcludedQCNo);
        if QCHeader.FindSet() then
            repeat
                CompletedIQCQuantity += QCHeader."Quantity (Base)";
            until QCHeader.Next() = 0;

        if not PurchRcptLine.Get(PostedReceiptNo, PostedReceiptLineNo) then
            exit;

        PurchRcptLine."RV_IQC Quantity" := CompletedIQCQuantity;
        PurchRcptLine."RV_IQC Status" :=
            (PurchRcptLine."Quantity (Base)" > 0) and
            (CompletedIQCQuantity >= PurchRcptLine."Quantity (Base)");
        PurchRcptLine.Modify();
    end;

    procedure SetQCEnable(var CreateQCLineEnable: Boolean; var QCCheckEnable: Boolean; var QCApproveEnable: Boolean; var QCReverseEnable: Boolean; var QCRejectEnable: Boolean; var NCResultEnable: Boolean;
                            var SubQCLineEnable: Boolean; var SubInventoryResultEnable: Boolean; var QCCardEnable: Boolean)
    begin

        CASE Rec."QC Status" OF
            (Rec."QC Status"::Analyzing):
                begin

                    CreateQCLineEnable := true;
                    QCCheckEnable := true;
                    QCApproveEnable := false;
                    QCReverseEnable := false;
                    NCResultEnable := false;

                    QCRejectEnable := false;
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
                    QCRejectEnable := true;
                    NCResultEnable := false;

                    SubQCLineEnable := true;
                    SubInventoryResultEnable := true;
                    //QCCardEnable := true;
                    QCCardEnable := false;
                end;
            (Rec."QC Status"::Approved):
                begin
                    CreateQCLineEnable := false;
                    QCCheckEnable := false;
                    QCApproveEnable := false;
                    QCReverseEnable := true;
                    QCRejectEnable := false;
                    NCResultEnable := false;

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
                    QCRejectEnable := false;
                    NCResultEnable := true;

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

    procedure PostItemReclassJournal(var FromLocation: Code[10]; var ToLocation: Code[10]; var FromBin: Code[20]; var ToBin: Code[20]; var Quantity: Decimal; var NewExpirationDate: Date)
    var
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        ItemTrackingSetup: Record "Item Tracking Setup";
        EntriesExist: Boolean;
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpec: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        ReceiptILE: Record "Item Ledger Entry";
        ReasonCode: Record "Reason Code";
    begin
        RIKEVITASetup.Get();
        //Deletes the new Item Reclass Journal that is generated after the Item Reclass Journal posting.
        // ItemJnlLine.Reset();
        // ItemJnlLine.SetRange("Journal Template Name", RIKEVITASetup."QC Reclass Jnl Template Name");
        // ItemJnlLine.SetRange("Journal Batch Name", RIKEVITASetup."QC Reclass Jnl Batch Name");
        // if ItemJnlLine.FindSet() then
        //     ItemJnlLine.DeleteAll();
        SetTemplateAndBatchName();
        DeleteJnlLines(ToTemplateName, ToBatchName);

        //Mark Item Journal Line
        // ItemJnlTemplate.Get(RIKEVITASetup."QC Reclass Jnl Template Name");
        // ItemJournalBatch.Get(RIKEVITASetup."QC Reclass Jnl Template Name", RIKEVITASetup."QC Reclass Jnl Batch Name");
        // ItemJournalBatch.TestField("Reason Code");
        // ItemJournalBatch.TestField("No. Series");

        ItemJnlLine.Init();
        // ItemJnlLine."Journal Template Name" := RIKEVITASetup."QC Reclass Jnl Template Name";
        // ItemJnlLine."Journal Batch Name" := RIKEVITASetup."QC Reclass Jnl Batch Name";
        ItemJnlLine."Journal Template Name" := ToTemplateName;
        ItemJnlLine."Journal Batch Name" := ToBatchName;

        clear(LineNo);
        LineNo += 10000;

        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine.Insert();
        ItemJnlLine."Entry Type" := Enum::"Item Ledger Entry Type"::Transfer;
        ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        ItemJnlLine."Value Entry Type" := Enum::"Cost Entry Type"::"Direct Cost";
        //ItemJnlLine.Type := Enum::"Capacity Type"::"Work Center";
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine.Validate("Document Date", WorkDate());
        // ItemJnlLine."Document No." := NoSeriesBatch.GetNextNo(ItemJournalBatch."No. Series", ItemJnlLine."Posting Date");
        ItemJnlLine."Document No." := Rec."QC No.";
        ItemJnlLine.Validate("Item No.", Rec."Item No.");
        ItemJnlLine.Validate("Location Code", FromLocation);
        ItemJnlLine.Validate("New Location Code", ToLocation);
        ItemJnlLine.Validate("Bin Code", FromBin);
        ItemJnlLine.Validate("New Bin Code", ToBin);
        // if Rec."Lot No." <> '' then
        //     ItemJnlLine."Lot No." := Rec."Lot No.";
        ItemJnlLine.Validate("Unit of Measure Code", Rec."UOM");
        ItemJnlLine.Validate("Quantity", Rec."Quantity");
        //set dimension and reason informaiton
        ReasonCode.Reset();
        ReasonCode.SetRange("RV_Reason Code Type", ReasonCode."RV_Reason Code Type"::"Transfer Site");
        if ReasonCode.FindFirst() then
            ItemJnlLine."reason Code" := ReasonCode.Code
        else
            Error('Please set a Reason Code for QC inventory transfers with the Reason Code Type set to Transfer Site');
        ReceiptILE.reset;
        ReceiptILE.SetRange("Document No.", Rec."Order No.");
        ReceiptILE.SetRange("Item No.");
        ReceiptILE.SetRange("Lot No.", Rec."Lot No.");
        case Rec."QC Type" of
            "RV QC Type"::IQC:
                ReceiptILE.SetRange("Entry Type", ReceiptILE."Entry Type"::Purchase);
            "RV QC Type"::FQC,
            "RV QC Type"::PQC:
                ReceiptILE.SetRange("Entry Type", ReceiptILE."Entry Type"::Output);
        end;
        if ReceiptILE.FindFirst() then begin
            ItemJnlLine.Validate("Shortcut Dimension 1 Code", ReceiptILE."Global Dimension 1 Code");
            ItemJnlLine.Validate("Shortcut Dimension 2 Code", ReceiptILE."Global Dimension 2 Code");
            ItemJnlLine.Validate("New Shortcut Dimension 1 Code", ReceiptILE."Global Dimension 1 Code");
            ItemJnlLine.Validate("New Shortcut Dimension 2 Code", ReceiptILE."Global Dimension 2 Code");
        end else begin
            ReceiptILE.SetRange("Entry Type");
            if ReceiptILE.FindFirst() then begin
                ItemJnlLine.Validate("Shortcut Dimension 1 Code", ReceiptILE."Global Dimension 1 Code");
                ItemJnlLine.Validate("Shortcut Dimension 2 Code", ReceiptILE."Global Dimension 2 Code");
                ItemJnlLine.Validate("New Shortcut Dimension 1 Code", ReceiptILE."Global Dimension 1 Code");
                ItemJnlLine.Validate("New Shortcut Dimension 2 Code", ReceiptILE."Global Dimension 2 Code");
            end;
        end;

        ItemJnlLine.Modify(true);

        //ReservationEntry
        if Rec."Lot No." <> '' then begin
            // Lot is unchanged; reclass posting still requires New Lot No. (= Lot No.)
            ReservEntry."Lot No." := Rec."Lot No.";
            TempTrackingSpec."New Lot No." := Rec."Lot No.";
            CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TempTrackingSpec);
            CreateReservEntry.CreateReservEntryFor(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(),
                                               ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name",
                                               0, ItemJnlLine."Line No.", ItemJnlLine."Qty. per Unit of Measure",
                                               ItemJnlLine.Quantity, ItemJnlLine."Quantity (Base)", ReservEntry);
            ItemTrackingSetup."Lot No." := Rec."Lot No.";
            NewExpirationDate := ItemTrackingMgt.ExistingExpirationDate(Rec."Item No.", ItemJnlLine."Variant Code", ItemTrackingSetup, false, EntriesExist);
            CreateReservEntry.SetNewExpirationDate(NewExpirationDate);
            CreateReservEntry.CreateEntry(ItemJnlLine."Item No.", ItemJnlLine."Variant Code",
                                          ItemJnlLine."Location Code", '',
                                          0D, ItemJnlLine."Posting Date", 0, ReservEntry."Reservation Status"::Prospect);
        end;
        Clear(ItemJnlPostBatch);
        ItemJnlPostBatch.SetSuppressCommit(true);
        ItemJnlPostBatch.Run(ItemJnlLine);
    end;

    procedure SetTemplateAndBatchName()
    var
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        User: Text;
        IsHandled: Boolean;
        PageID: Integer;
        ItemJnlLine2: Record "Item Journal Line";
    begin
        PageID := Page::"Item Reclass. Journal";
        PageTemplate := PageTemplate::Transfer;

        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange("Page ID", PageID);
        ItemJnlTemplate.SetRange(Recurring, false);
        ItemJnlTemplate.SetRange(Type, PageTemplate);
        if not ItemJnlTemplate.FindFirst() then begin
            ItemJnlTemplate.Init();
            ItemJnlTemplate.Recurring := false;
            ItemJnlTemplate.Validate(Type, PageTemplate);
            ItemJnlTemplate.Validate("Page ID");

            ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name));
            ItemJnlTemplate.Description := StrSubstNo(Text000, ItemJnlTemplate.Type);
            ItemJnlTemplate.Insert();
        end;

        ToTemplateName := ItemJnlTemplate.Name;
        ToBatchName := '';
        User := UpperCase(UserId); // Uppercase in case of Windows Login
        if User <> '' then
            // if (StrLen(User) < MaxStrLen(ItemJnlLine2."Journal Batch Name")) and (ItemJnlLine2."Journal Batch Name" <> '') then
            //     ToBatchName := CopyStr(ItemJnlLine2."Journal Batch Name", 1, MaxStrLen(ItemJnlLine2."Journal Batch Name") - 1) + 'A'
            // else
                ToBatchName := DelChr(CopyStr(User, 1, MaxStrLen(ItemJnlLine2."Journal Batch Name")), '>', '0123456789');
        if ToBatchName = '' then
            ToBatchName := Text003;
        if not ItemJnlBatch.Get(ToTemplateName, ToBatchName) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
            ItemJnlBatch.SetupNewBatch();
            ItemJnlBatch.Name := ToBatchName;
            ItemJnlBatch.Description := Text004;
            ItemJnlBatch.Insert(true);
        end;
    end;

    procedure DeleteJnlLines(TemplateName: Code[10]; BatchName: Code[10])
    var
        ItemJnlLine2: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        IsHandled: Boolean;
    begin
        ItemJnlLine2.Reset();
        ItemJnlLine2.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine2.SetRange("Journal Batch Name", BatchName);
        // ItemJnlLine2.SetRange("Order Type", ItemJnlLine2."Order Type"::Production);
        // ItemJnlLine2.SetRange("Order No.", ProdOrderNo);
        // if ProdOrderLineNo <> 0 then
        // ItemJnlLine2.SetRange("Order Line No.", ProdOrderLineNo);
        if ItemJnlLine2.Find('-') then begin
            repeat
                if ReservEntryExist(ItemJnlLine2, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            until ItemJnlLine2.Next() = 0;

            ItemJnlLine2.DeleteAll(true);
        end;
    end;

    procedure ReservEntryExist(ItemJnlLine2: Record "Item Journal Line"; var ReservEntry: Record "Reservation Entry"): Boolean
    begin
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line");
        ReservEntry.SetRange("Source ID", ItemJnlLine2."Journal Template Name");
        ReservEntry.SetRange("Source Ref. No.", ItemJnlLine2."Line No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservEntry.SetRange("Source Subtype", ItemJnlLine2."Entry Type");
        ReservEntry.SetRange("Source Batch Name", ItemJnlLine2."Journal Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        if not ReservEntry.IsEmpty() then
            exit(true);

        exit(false);
    end;

    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        Text000: Label '%1 journal';
        Text003: Label 'QCTC';
        Text004: Label 'Item Reclass Journal';
}