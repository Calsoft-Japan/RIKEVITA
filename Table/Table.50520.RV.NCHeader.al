/// <summary>
/// Table RV NC Header (ID 50520)
/// FDD039 2026/10/09: New. (Mike)
/// </summary>
table 50520 "RV NC Header"
{
    Caption = 'NC Header';
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
        }

        field(40; "Order No."; Code[20])
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

                    end;
                end else if Rec."Ref. Order Type" = RefOrderType::"Posted Purchase Receipt" then begin
                    PurchRcptLine.Reset();
                    if (Page.RunModal(Page::"Posted Purchase Receipt Lines", PurchRcptLine) = Action::LookupOK) then begin
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
                    end;
                end;
            end;
        }

        field(50; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(52; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(60; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(70; "QC Date"; Date)
        {
            Caption = 'QC Date';
        }
        field(80; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(90; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(110; "QC Checked By"; Text[50])
        {
            Caption = 'QC Checked By';
        }
        field(115; "QC Checked Remark"; Text[250])
        {
            Caption = 'QC Checked Remark';
        }
        field(116; "QC Checked Date"; Date)
        {
            Caption = 'QC Checked Date';
        }
        field(120; "QC Rejected By"; Text[50])
        {
            Caption = 'QC Rejected By';
        }
        field(125; "QC Rejected Remark"; Text[250])
        {
            Caption = 'QC Rejected Remark';
        }
        field(126; "QC Rejected Date"; Date)
        {
            Caption = 'QC Rejected Date';
        }

        field(140; "QC Comment"; Text[150])
        {
            Caption = 'QC Comment';
        }
        field(150; "QC Analyzed by"; Text[50])
        {
            Caption = 'QC Analyzed by';
        }
        field(160; "Inspect Bin Code"; Code[20])
        {
            Caption = 'Inspect Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("NC Location Code"));
        }
        field(170; "Storage Bin Code"; Code[20])
        {
            Caption = 'Storage Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("NC Location Code"));
        }
        field(180; "NC Location Code"; Code[10])
        {
            Caption = 'NC Location Code';
            TableRelation = Location;
        }
        field(190; "NC Analyzed by"; Text[50])
        {
            Caption = 'NC Analyzed by';
        }
        field(200; "NC Remark"; Text[150])
        {
            Caption = 'NC Remark';
        }
        field(210; "NC Checked by"; Text[50])
        {
            Caption = 'NC Checked by';
        }
        field(220; "NC Checked Remark"; Text[150])
        {
            Caption = 'NC Checked Remark';
        }
        field(225; "NC Checked Date"; Date)
        {
            Caption = 'NC Checked Date';
        }
        field(230; "NC Approved by"; Text[50])
        {
            Caption = 'NC Approved by';
        }
        field(232; "NC Approved Remark"; Text[150])
        {
            Caption = 'NC Approved Remark';
        }
        field(235; "NC Approved Date"; Date)
        {
            Caption = 'NC Approved Date';
        }
        field(240; "NC Status"; Enum "RV NC Status")
        {
            Caption = 'NC Status';
        }
        field(1000; "Line No."; Integer)
        {
            Caption = 'Line No.';
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
    begin

    end;

    trigger OnDelete()
    var
        QCInyResultLine: Record "RV QC Iny. Result Line";
    begin
        QCInyResultLine.Reset();
        QCInyResultLine.SetRange("QC No.", Rec."QC No.");
        QCInyResultLine.SetRange("QC Type", Rec."QC Type");
        QCInyResultLine.DeleteAll(true);
    end;

    procedure IsNCCheckAllowed(): Boolean
    var
        UserSetup: Record "User Setup";
        TextCheckErr: Label 'You don''t have permission to Check!';
    begin

        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow NC Check" then
                Error(TextCheckErr);
        end else
            Error(TextCheckErr);
    end;

    procedure IsNCApproveAllowed()
    var
        UserSetup: Record "User Setup";
        TextApproveErr: Label 'You don''t have permission to Approve!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow NC Approve" then
                Error(TextApproveErr);
        end else
            Error(TextApproveErr);

        if "NC Checked By" = '' then
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

        if "NC Status" in ["NC Status"::Analyzing, "NC Status"::Checked] then
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
        RemarkText[1] := Rec."NC Checked Remark";// Remark
        RemarkText[2] := 'NC Check Remark'; //Caption       

        RVQCRemarkInput.Caption := 'NC Check Remark';
        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            "NC Status" := Rec."NC Status"::Checked;
            "NC Checked Remark" := RemarkText[1];// set Remark
            "NC Checked By" := UserId;
            "NC Checked Date" := WorkDate();
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
        RemarkText[1] := Rec."NC Approved Remark";// MarkText
        RemarkText[2] := 'NC Approved Remark'; //Caption       

        RVQCRemarkInput.Caption := 'NC Approved Remark';
        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin
            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            Rec."NC Status" := Rec."NC Status"::Approved;
            Rec."NC Approved Remark" := RemarkText[1];// set Remark
            rec."NC Approved By" := UserId;
            rec."NC Approved Date" := WorkDate();
            Modify();
        end;
    end;

    procedure CheckTotalQuantity()
    var
        NCResultLine: Record "RV QC Iny. Result Line";
        TotalNCQuantity: Decimal;
    begin
        NCResultLine.SetRange("QC No.", Rec."QC No.");
        NCResultLine.SetRange("QC Type", Rec."QC Type");
        NCResultLine.CalcSums(Quantity);
        TotalNCQuantity := NCResultLine.Quantity;
        if TotalNCQuantity <> Rec.Quantity then
            Error('The total quantity of NC lines (%1) must equal the Quantity of NC Header (%2).', TotalNCQuantity, Rec.Quantity);
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



    procedure SetQCEnable(var QCCheckEnable: Boolean; var QCApproveEnable: Boolean;
                             var SubInventoryResultEnable: Boolean; var QCCardEnable: Boolean)
    begin

        CASE Rec."NC Status" OF
            (Rec."NC Status"::Analyzing):
                begin

                    QCCheckEnable := true;
                    QCApproveEnable := false;

                    SubInventoryResultEnable := true;
                    QCCardEnable := true;
                end;
            (Rec."NC Status"::Checked):
                begin
                    QCCheckEnable := false;
                    QCApproveEnable := true;

                    SubInventoryResultEnable := true;
                    QCCardEnable := true;
                end;
            (Rec."NC Status"::Approved):
                begin
                    QCCheckEnable := false;
                    QCApproveEnable := false;

                    SubInventoryResultEnable := false;
                    QCCardEnable := false;
                end;
        END;
    end;

    procedure PostItemReclassJournal(var Quantity: Decimal; var NewExpirationDate: Date)
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
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        FromLocation: Code[10];
        ToLocation: Code[10];
        FromBin: Code[20];
        ToBin: Code[20];
        QCInyResultLine: Record "RV QC Iny. Result Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        RIKEVITASetup.Get();
        RIKEVITASetup.TestField("QC Reclass Jnl Template Name");
        RIKEVITASetup.TestField("QC Reclass Jnl Batch Name");
        RIKEVITASetup.TestField("NC Location Code");
        RIKEVITASetup.TestField("NC Bin Code");
        FromLocation := Rec."Location Code";
        FromBin := Rec."Inspect Bin Code";

        //Deletes the new Item Reclass Journal that is generated after the Item Reclass Journal posting.
        //need to correct the delete logic since multiple users can use the same journal template and batch name.
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", RIKEVITASetup."QC Reclass Jnl Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", RIKEVITASetup."QC Reclass Jnl Batch Name");
        if ItemJnlLine.FindSet() then
            ItemJnlLine.DeleteAll();

        //Mark Item Journal Line
        ItemJnlTemplate.Get(RIKEVITASetup."QC Reclass Jnl Template Name");
        ItemJournalBatch.Get(RIKEVITASetup."QC Reclass Jnl Template Name", RIKEVITASetup."QC Reclass Jnl Batch Name");
        ItemJournalBatch.TestField("Reason Code");
        ItemJournalBatch.TestField("No. Series");

        clear(LineNo);
        QCInyResultLine.Reset();
        QCInyResultLine.SetRange("QC No.", Rec."QC No.");
        QCInyResultLine.SetRange("QC Type", Rec."QC Type");
        if QCInyResultLine.FindSet() then
            repeat
                QCInyResultLine.TestField("NC Location Code");
                QCInyResultLine.TestField("NC Bin Code");

                ToLocation := QCInyResultLine."NC Location Code";
                ToBin := QCInyResultLine."NC Bin Code";

                ItemJnlLine.Init();
                ItemJnlLine."Journal Template Name" := RIKEVITASetup."QC Reclass Jnl Template Name";
                ItemJnlLine."Journal Batch Name" := RIKEVITASetup."QC Reclass Jnl Batch Name";

                LineNo += 10000;
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Entry Type" := Enum::"Item Ledger Entry Type"::Transfer;
                ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
                ItemJnlLine."Value Entry Type" := Enum::"Cost Entry Type"::"Direct Cost";

                ItemJnlLine.Validate("Posting Date", WorkDate());
                ItemJnlLine."Document Date" := WorkDate();
                ItemJnlLine."Document No." := NoSeriesBatch.GetNextNo(ItemJournalBatch."No. Series", ItemJnlLine."Posting Date");
                ItemJnlLine.Validate("Item No.", Rec."Item No.");
                ItemJnlLine.Validate("Location Code", FromLocation);
                ItemJnlLine.Validate("New Location Code", ToLocation);
                ItemJnlLine.Validate("Bin Code", FromBin);
                ItemJnlLine.Validate("New Bin Code", ToBin);
                if Rec."Lot No." <> '' then
                    ItemJnlLine."Lot No." := Rec."Lot No.";
                ItemJnlLine.Validate("Unit of Measure Code", Rec."Unit of Measure");
                ItemJnlLine.Validate("Quantity", QCInyResultLine."Quantity");
                ItemJnlLine."reason Code" := ItemJournalBatch."Reason Code";
                ItemJnlLine.Insert(true);
                //Dimension code 1 and dimension code 2 need to be copied from the inventory ILE

                //ReservationEntry
                ReservEntry."Lot No." := Rec."Lot No.";
                CreateReservEntry.SetNewTrackingFromItemJnlLine(ItemJnlLine);
                CreateReservEntry.CreateReservEntryFor(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(),
                                                   ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name",
                                                   0, ItemJnlLine."Line No.", ItemJnlLine."Qty. per Unit of Measure",
                                                   ItemJnlLine.Quantity, ItemJnlLine."Quantity (Base)", ReservEntry);
                ItemTrackingSetup."Lot No." := Rec."Lot No.";
                NewExpirationDate := ItemTrackingMgt.ExistingExpirationDate(Rec."Item No.", ItemJnlLine."Variant Code", ItemTrackingSetup, false, EntriesExist);
                CreateReservEntry.SetNewExpirationDate(NewExpirationDate);
                CreateReservEntry.CreateEntry(ItemJnlLine."Item No.", ItemJnlLine."Variant Code",
                                              ItemJnlLine."Location Code", '',
                                              ItemJnlLine."Posting Date", 0D, 0, ReservEntry."Reservation Status"::Prospect);
                if ItemJnlLine."Lot No." <> '' then begin
                    ItemJnlLine."Lot No." := '';
                    ItemJnlLine.Modify();
                end;

            until QCInyResultLine.Next() = 0;

        //Post Item Reclass Journal

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", RIKEVITASetup."QC Reclass Jnl Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", RIKEVITASetup."QC Reclass Jnl Batch Name");
        Clear(ItemJnlPostBatch);
        ItemJnlPostBatch.SetSuppressCommit(true);
        ItemJnlPostBatch.Run(ItemJnlLine);

    end;

}