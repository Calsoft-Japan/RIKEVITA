/// <summary>
/// Page RV Prod. Result Journal Line (ID 50601)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
page 50601 "RV Prod. Result Journal Line"
{
    ApplicationArea = All;
    Caption = 'Prod. Result Journal';
    PageType = Worksheet;
    SourceTable = "RV Prod. Result Journal Line";
    UsageCategory = Tasks;
    AutoSplitKey = true;
    DelayedInsert = true;
    SaveValues = true;

    layout
    {
        area(Content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    RVProdResultsMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    RVProdResultsMgt.CheckName(CurrentJnlBatchName, Rec);
                end;

            }
            repeater(General)
            {
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Output Item No."; Rec."Output Item No.")
                {
                    ToolTip = 'Specifies the value of the Output Item No. field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ToolTip = 'Specifies the value of the Operation No. field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ToolTip = 'Specifies the value of the Work Center No. field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    Editable = CanEdit;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Scrap Quantity"; Rec."Scrap Quantity")
                {
                    ToolTip = 'Specifies the value of the Scrap Quantity field.', Comment = '%';
                    Editable = CanEdit;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                    Editable = CanEdit;

                    trigger OnAssistEdit()
                    var
                        ItemTrackingSummaryForm: Page "Item Tracking Summary";
                        TempTrackingSpecification: Record "Tracking Specification" temporary;
                        SearchForSupply: Boolean;
                        LookupMode: Enum "Item Tracking Type";
                        MaxQuantity: Decimal;
                        TrackingSpecification: Record "Tracking Specification";
                        ProdBOM: Record "Prod. Order Component";
                        ProdLine: Record "Prod. Order Line";
                    begin
                        // InitFromItemJnlLine(TrackingSpecification, Rec);
                        // SetSourceSpec(TrackingSpecification, Rec."Posting Date");
                        CurrPage.SaveRecord();
                        commit;
                        case rec."Data Type" of
                            rec."Data Type"::"Adjust Consumption",
                            rec."Data Type"::"Planned Consumption",
                            rec."Data Type"::"Recycle Consumption":
                                begin

                                    recTrackingSpec.Reset();
                                    recTrackingSpec.DeleteAll();
                                    recTrackingSpec.Init();
                                    recTrackingSpec."Entry No." := 1;
                                    recTrackingSpec."Item No." := Rec."Item No.";
                                    recTrackingSpec."Location Code" := Rec."Location Code";
                                    recTrackingSpec."Variant Code" := Rec."Variant Code";
                                    recTrackingSpec."Bin Code" := Rec."Bin Code";
                                    recTrackingSpec."Qty. per Unit of Measure" := Rec."Qty. per Unit of Measure";
                                    recTrackingSpec.Insert();

                                    AssistEditTrackingNo(recTrackingSpec,
                                                        true,
                                                        -1,
                                                        "Item Tracking Type"::"Lot No.",
                                                        0
                                                        );
                                end;
                            rec."Data Type"::"Adjust Output",
                            rec."Data Type"::"Planned Output":
                                begin
                                    ProdLine.get(ProdLine.Status::Released, rec."Prod. Order No.", rec."Prod. Order Line No.");
                                    recTrackingSpec.DeleteAll();
                                    recTrackingSpec.Init();
                                    recTrackingSpec."Entry No." := 1;
                                    recTrackingSpec."Item No." := Rec."Output Item No.";
                                    recTrackingSpec."Location Code" := ProdLine."Location Code";
                                    recTrackingSpec."Variant Code" := ProdLine."Variant Code";
                                    recTrackingSpec."Bin Code" := ProdLine."Bin Code";
                                    recTrackingSpec."Qty. per Unit of Measure" := ProdLine."Qty. per Unit of Measure";
                                    recTrackingSpec.Insert();

                                    AssistEditTrackingNo(recTrackingSpec,
                                                        false,
                                                        1,
                                                        "Item Tracking Type"::"Lot No.",
                                                        Rec.Quantity
                                                        );
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if rec."Lot No." = '' then begin
                            Rec."Manufacturing Date" := 0D;
                            rec."Expire Date" := 0D;
                        end else begin
                            UpdateExpireDate();
                        end;
                    end;
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ToolTip = 'Specifies the value of the Manufacturing Date field.', Comment = '%';
                    Editable = CanEdit;

                    trigger OnValidate()
                    begin
                        UpdateExpireDate();
                    end;
                }
                field("Expire Date"; Rec."Expire Date")
                {
                    ToolTip = 'Specifies the value of the Expire Date field.', Comment = '%';
                    Editable = CanEdit;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = CanEdit;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies the value of the Error Message field.', Comment = '%';
                    Editable = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ToolTip = 'Specifies the value of the Routing No. field.', Comment = '%';
                    Editable = false;
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Comp. Line No. field.', Comment = '%';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Imported Date';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalProdJouornal)
            {
                Caption = 'Cal. Prod. Journal';
                Image = Calculate;

                trigger OnAction()
                var
                    ProdResultLine: Record "RV Prod. Result Journal Line";
                    CalcConsumption: Report "RV Calc. Consumption";
                begin
                    CalcConsumption.SetBatchName(CurrentJnlBatchName);
                    CalcConsumption.Run();
                end;
            }

            group(ApprovalRequest)
            {
                Caption = 'Approve Request';
                action(SendApprovalRequest)
                {

                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange("Data Type", ProdResultLine."Data Type"::"Recycle Consumption");
                        ProdResultLine.SetFilter(Status, '%1|%2', ProdResultLine.Status::Rejected, ProdResultLine.Status::Preparing);
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::"Pending Approve");
                    end;
                }
                action(CancelApprovalRequest)
                {

                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Preparing);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approve';
                action(Approve)
                {

                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Approved);
                    end;
                }
                action(RejectApprovalRequest)
                {

                    Caption = 'Reject';
                    Image = Reject;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Rejected);
                    end;
                }
            }
            group(DoPost)
            {
                Caption = 'Post';
                action(ChangeToReadyToPost)
                {

                    Caption = 'Ready Post';
                    Image = Approval;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        if ProdResultLine.FindSet() then
                            repeat
                                case ProdResultLine."Data Type" of
                                    ProdResultLine."Data Type"::"Adjust Consumption",
                                    ProdResultLine."Data Type"::"Adjust Output",
                                    ProdResultLine."Data Type"::"Planned Consumption",
                                    ProdResultLine."Data Type"::"Planned Output":
                                        begin
                                            if (ProdResultLine.Status = ProdResultLine.Status::Preparing)
                                            or (ProdResultLine.Status = ProdResultLine.Status::"Post Error") then begin
                                                ProdResultLine.Status := ProdResultLine.Status::"Ready Post";
                                                ProdResultLine."Error Message" := '';
                                                ProdResultLine.Modify();
                                            end;
                                        end;
                                    ProdResultLine."Data Type"::"Recycle Consumption":
                                        if (ProdResultLine.Status = ProdResultLine.Status::Approved)
                                        or (ProdResultLine.Status = ProdResultLine.Status::"Post Error") then begin
                                            ProdResultLine.Status := ProdResultLine.Status::"Ready Post";
                                            ProdResultLine."Error Message" := '';
                                            ProdResultLine.Modify();
                                        end;
                                end;
                            until ProdResultLine.Next() = 0;
                    end;
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;

                    trigger OnAction()
                    var
                        PostProdResultLineBatch: codeunit "RV Post Prod Result Line Batch";
                    begin
                        PostProdResultLineBatch.SetBatchName(CurrentJnlBatchName);
                        PostProdResultLineBatch.Run();
                    end;
                }
                action(CancelPostReady)
                {
                    Caption = 'Cancel Post Ready';
                    Image = Delete;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        if ProdResultLine.FindSet() then
                            repeat
                                case ProdResultLine."Data Type" of
                                    ProdResultLine."Data Type"::"Adjust Consumption",
                                    ProdResultLine."Data Type"::"Adjust Output",
                                    ProdResultLine."Data Type"::"Planned Consumption",
                                    ProdResultLine."Data Type"::"Planned Output":
                                        begin
                                            if (ProdResultLine.Status = ProdResultLine.Status::"Ready Post")
                                            or (ProdResultLine.Status = ProdResultLine.Status::"Post Error") then begin
                                                ProdResultLine.Status := ProdResultLine.Status::Preparing;
                                                ProdResultLine."Error Message" := '';
                                                ProdResultLine.Modify();
                                            end;
                                        end;
                                end;
                            until ProdResultLine.Next() = 0;
                    end;
                }
            }
        }
        area(Promoted)
        {

            actionref(CalProdJouornal_Promoted; CalProdJouornal)
            {

            }
            group(ApprovalRequestGrp)
            {
                Caption = 'Approve Request';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {

                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {

                }
            }
            group(ApproveGrp)
            {
                Caption = 'Approve';
                actionref(Approve_Promoted; Approve)
                {

                }
                actionref(RejectApprovalRequest_Promoted; RejectApprovalRequest)
                {

                }
            }
            group(ReadyToPostGrp)
            {
                Caption = 'Post';
                actionref(ChangeToReadyToPost_Promoted; ChangeToReadyToPost)
                {

                }
                actionref(CancelPostReady_Promoted; CancelPostReady)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        OpenedFromBatch := (Rec."Batch Name" <> '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Batch Name";
            RVProdResultsMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        RVProdResultsMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        case Rec.Status of
            Rec.Status::Preparing,
            Rec.Status::Rejected:
                CanEdit := true;
            Rec.Status::"Pending Approve",
            Rec.Status::Approved,
            Rec.Status::"Ready Post",
            Rec.Status::"Post Error":
                CanEdit := false;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Preparing,
            Rec.Status::Rejected:
                CanEdit := true;
            Rec.Status::"Pending Approve",
            Rec.Status::Approved,
            Rec.Status::"Ready Post",
            Rec.Status::"Post Error":
                CanEdit := false;
        end;
    end;

    var
        CurrentJnlBatchName: Code[10];
        RVProdResultsMgt: Codeunit "RV Prod. Results Management";
        OpenedFromBatch: Boolean;
        CanEdit: Boolean;
        Text004: Label 'Counting records...';
        FullGlobalDataSetExists: Boolean;
        TempGlobalReservEntry: Record "Reservation Entry" temporary;
        TempGlobalAdjustEntry: Record "Reservation Entry" temporary;
        TempGlobalEntrySummary: Record "Entry Summary" temporary;
        TempGlobalChangedEntrySummary: Record "Entry Summary" temporary;
        LastSummaryEntryNo: Integer;
        LastReservEntryNo: Integer;
        CurrBinCode: Code[20];
        CurrItemTrackingCode: Record "Item Tracking Code";
        TempGlobalTrackingSpec: Record "Tracking Specification" temporary;
        SkipLot: Boolean;
        PartialGlobalDataSetExists: Boolean;
        ListTxt: Label '%1 List', Comment = '%1 - field caption';
        DirectTransfer: Boolean;
        Text013: Label 'Neutralize consumption/output';
        SourceTrackingSpecification: Record "Tracking Specification";
        Item: Record Item;
        ForBinCode: Code[20];
        recTrackingSpec: Record "Tracking Specification" temporary;
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        TempReservEntry: Record "Reservation Entry" temporary;
        LastEntryNo: Integer;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        CurrentRunMode: Enum "Item Tracking Run Mode";
        CurrentEntryStatus: Enum "Reservation Status";
        CurrentSignFactor: Integer;
        CurrentSourceCaption: Text[255];
        CurrentSourceType: Integer;
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        ItemTrackingCode: Record "Item Tracking Code";
        UndefinedQtyArray: array[3] of Decimal;
        SourceQuantityArray: array[5] of Decimal;
        QtyPerUOM: Decimal;
        QtyRoundingPerBase: Decimal;
        SecondSourceID: Integer;
        IsAssembleToOrder: Boolean;
        DeleteIsBlocked: Boolean;
        CurrentSourceRowID: Text[250];
        BlockCommit: Boolean;
        SecondSourceRowID: Text[250];
        ItemLedgerEntryFilter: Text;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        TotalTrackingSpecification: Record "Tracking Specification";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        FunctionsDemandVisible: Boolean;
        FunctionsSupplyVisible: Boolean;
        IsInvtDocumentCorrection: Boolean;
        InsertIsBlocked: Boolean;
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        InboundIsSet: Boolean;
        Inbound: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        RVProdResultsMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure DoSearchForSupply(SearchSupply: Boolean): Boolean
    begin
        if not IsInvtDocumentCorrection then
            exit(SearchSupply);

        if InsertIsBlocked then
            exit(false);

        if recTrackingSpec."Source Type" <> DATABASE::"Invt. Document Line" then
            exit(SearchSupply);

        exit(recTrackingSpec."Source Subtype" = 0);
    end;

    procedure AssistEditTrackingNo(var TempTrackingSpecification: Record "Tracking Specification" temporary; SearchForSupply: Boolean; CurrentSignFactor: Integer; LookupMode: Enum "Item Tracking Type"; MaxQuantity: Decimal)
    var
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        LotNoInfo: Record "Lot No. Information";
    begin
        InitItemTrackingSummaryForm(ItemTrackingSummaryForm, TempTrackingSpecification, SearchForSupply, CurrentSignFactor, LookupMode, MaxQuantity);
        if ItemTrackingSummaryForm.RunModal() = ACTION::LookupOK then begin
            ItemTrackingSummaryForm.GetRecord(TempGlobalEntrySummary);
            CalculateQtyAfterEditingTrackingLine(TempTrackingSpecification, CurrentSignFactor, LookupMode, MaxQuantity);
            Rec."Lot No." := TempTrackingSpecification."Lot No.";
            if LotNoInfo.get(TempTrackingSpecification."Item No.",
                            TempTrackingSpecification."Variant Code",
                            TempTrackingSpecification."Lot No.") then begin
                Rec."Manufacturing Date" := LotNoInfo."RV_Manufacture Date";
                Rec."Expire Date" := TempTrackingSpecification."Expiration Date";
            end;
            Rec.Modify();
        end;
    end;

    procedure InitFromItemJnlLine(var TrackingSpecification: Record "Tracking Specification"; ProdResultLine: Record "RV Prod. Result Journal Line")
    var
        ProdBomLine: Record "Prod. Order Component";
        ProdLine: Record "Prod. Order Line";
        ItemJournalLine: Record "Item Journal Line" temporary;
    begin
        TrackingSpecification.Init();
        case ProdResultLine."Data Type" of
            ProdResultLine."Data Type"::"Adjust Consumption",
            ProdResultLine."Data Type"::"Planned Consumption",
            ProdResultLine."Data Type"::"Recycle Consumption":
                begin
                    ProdBomLine.get(ProdBomLine.Status::Released,
                    ProdResultLine."Prod. Order No.",
                    ProdResultLine."Prod. Order Line No.",
                    ProdResultLine."Prod. Order Comp. Line No.");
                    TrackingSpecification.SetItemData(
                        ProdResultLine."Item No.", ProdBomLine.Description, ProdBomLine."Location Code", ProdBomLine."Variant Code",
                        ProdBomLine."Bin Code", ProdBomLine."Qty. per Unit of Measure", ProdBomLine."Qty. Rounding Precision (Base)");

                end;
            ProdResultLine."Data Type"::"Adjust Output",
            ProdResultLine."Data Type"::"Planned Output":
                begin
                    ProdLine.get(ProdLine.Status::Released, ProdResultLine."Prod. Order No.", ProdResultLine."Prod. Order Line No.");
                    TrackingSpecification.SetItemData(
                         ProdResultLine."Output Item No.", ProdLine.Description, ProdLine."Location Code", ProdLine."Variant Code",
                         ProdLine."Bin Code", ProdLine."Qty. per Unit of Measure", ProdLine."Qty. Rounding Precision (Base)");
                end;
        end;

        SetTemplateAndBatchName();

        ItemJournalLine.DeleteAll();
        ItemJournalLine.Init();
        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Consumption;
        ItemJournalLine."Journal Template Name" := ItemJnlBatch."Journal Template Name";
        ItemJournalLine."Line No." := 10000;
        ItemJournalLine."Journal Batch Name" := ItemJnlBatch.Name;
        ItemJournalLine.Insert();

        TrackingSpecification.SetSource(
            Database::"Item Journal Line",
            ItemJournalLine."Entry Type".AsInteger(),
            ItemJournalLine."Journal Template Name",
            ItemJournalLine."Line No.",
            ItemJournalLine."Journal Batch Name", 0);

        TrackingSpecification.SetQuantities(
        ProdResultLine.Quantity * ProdBomLine."Qty. per Unit of Measure",
        ProdResultLine.Quantity,
        ProdResultLine.Quantity * ProdBomLine."Qty. per Unit of Measure",
        ProdResultLine.Quantity,
        ProdResultLine.Quantity * ProdBomLine."Qty. per Unit of Measure",
        0, 0);
    end;

    procedure SetTemplateAndBatchName()
    var
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        User: Text;
        IsHandled: Boolean;
        PageID: Integer;
        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        ItemJnlLine: Record "Item Journal Line";
        Text000: Label '%1 journal';
        Text003: Label 'DEFAULT';
        Text004: Label 'Production Journal';
    begin
        PageID := Page::"Production Journal";
        PageTemplate := PageTemplate::"Prod. Order";

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
            if (StrLen(User) < MaxStrLen(ItemJnlLine."Journal Batch Name")) and (ItemJnlLine."Journal Batch Name" <> '') then
                ToBatchName := CopyStr(ItemJnlLine."Journal Batch Name", 1, MaxStrLen(ItemJnlLine."Journal Batch Name") - 1) + 'A'
            else
                ToBatchName := DelChr(CopyStr(User, 1, MaxStrLen(ItemJnlLine."Journal Batch Name")), '>', '0123456789');

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

    procedure SetSourceSpec(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        CurrentEntryStatusOption: Option;
    begin
        SourceTrackingSpecification := TrackingSpecification;
        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);
        TempTrackingSpecification.DeleteAll();
        TempItemTrackLineInsert.DeleteAll();
        TempItemTrackLineModify.DeleteAll();
        TempItemTrackLineDelete.DeleteAll();

        TempReservEntry.DeleteAll();
        LastEntryNo := 0;
        if ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype") and not (CurrentRunMode = CurrentRunMode::"Drop Shipment")
        then
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        else
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and (CurrentRunMode = CurrentRunMode::Reclass) then
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        CurrentEntryStatusOption := CurrentEntryStatus.AsInteger();
        CurrentEntryStatus := Enum::"Reservation Status".FromInteger(CurrentEntryStatusOption);

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        ReservEntry."Source ID" := TrackingSpecification."Source ID";
        if CurrentSignFactor = 0 then
            CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption();
        CurrentSourceType := ReservEntry."Source Type";

        if CurrentSignFactor < 0 then begin
            ExpectedReceiptDate := 0D;
            ShipmentDate := AvailabilityDate;
        end else begin
            ExpectedReceiptDate := AvailabilityDate;
            ShipmentDate := 0D;
        end;

        FillSourceQuantityArray(TrackingSpecification);
        QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";
        QtyRoundingPerBase := TrackingSpecification."Qty. Rounding Precision (Base)";

        ReservEntry.SetSourceFilter(
          TrackingSpecification."Source Type", TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID", TrackingSpecification."Source Ref. No.", true);
        ReservEntry.SetSourceFilter(
          TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line");
        if CheckTrackingSpecificationSource(TrackingSpecification) then
            ReservEntry.SetRange("Untracked Surplus", false);

        // Transfer Receipt gets special treatment:
        SetSourceSpecForTransferReceipt(TrackingSpecification, ReservEntry, TempTrackingSpecification2);

        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, false, 0, QtyRoundingPerBase);

        TempReservEntry.CopyFilters(ReservEntry);

        TrackingSpecification.SetSourceFilter(
          TrackingSpecification."Source Type", TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID", TrackingSpecification."Source Ref. No.", true);
        TrackingSpecification.SetSourceFilter(
          TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line");

        if TrackingSpecification.FindSet() then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.Insert();
            until TrackingSpecification.Next() = 0;

        // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = Database::"Transfer Line" then
            CollectPostedTransferEntries(TrackingSpecification, TempTrackingSpecification);

        // Data regarding posted quantities on assembly or production orders is collected from Item Ledger Entries:
        // OnSetSourceSpecOnCollectTrackingData(
        //     TrackingSpecification, TempTrackingSpecification, ExcludePostedEntries, CurrentSignFactor, SourceQuantityArray[1]);

        // If run for Drop Shipment a RowID is prepared for synchronisation:
        if CurrentRunMode = CurrentRunMode::"Drop Shipment" then
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");

        // If run for Combined Shipment/Receipt "Receipt/Shipment No." is updated:
        if CurrentRunMode = CurrentRunMode::"Combined Ship/Rcpt" then
            UpdateReceiptShipmentNo(TempTrackingSpecification);

        // Synchronization of outbound transfer order:
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 0)
        then begin
            BlockCommit := true;
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");
            SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                1, TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");
            CurrentRunMode := CurrentRunMode::Transfer;
        end;

        AddToGlobalRecordSet(TempTrackingSpecification);
        AddToGlobalRecordSet(TempTrackingSpecification2);
        CalculateSums();

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode, ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(recTrackingSpec, false);

        FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
        FunctionsSupplyVisible := not FunctionsDemandVisible;
    end;

    procedure CalculateSums()
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        xTrackingSpec.Copy(recTrackingSpec);
        recTrackingSpec.Reset();
        recTrackingSpec.CalcSums("Quantity (Base)", "Qty. to Handle (Base)", "Qty. to Invoice (Base)");
        TotalTrackingSpecification := recTrackingSpec;
        recTrackingSpec.Copy(xTrackingSpec);

        UpdateUndefinedQtyArray();
    end;

    local procedure UpdateUndefinedQtyArray()
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalTrackingSpecification."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalTrackingSpecification."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalTrackingSpecification."Qty. to Invoice (Base)";
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        TempTrackingSpecification.SetTrackingKey();

        if TempTrackingSpecification.Find('-') then
            repeat
                if ItemLedgerEntryFilter = '' then begin
                    TempTrackingSpecification.SetTrackingFilterFromSpec(TempTrackingSpecification);
                    TempTrackingSpecification.CalcSums(
                        "Quantity (Base)", "Qty. to Handle (Base)", "Qty. to Invoice (Base)",
                        "Quantity Handled (Base)", "Quantity Invoiced (Base)");
                end;

                if TempTrackingSpecification."Quantity (Base)" <> 0 then begin
                    recTrackingSpec := TempTrackingSpecification;
                    recTrackingSpec."Quantity (Base)" *= CurrentSignFactor;
                    recTrackingSpec."Qty. to Handle (Base)" *= CurrentSignFactor;
                    recTrackingSpec."Qty. to Invoice (Base)" *= CurrentSignFactor;
                    recTrackingSpec."Quantity Handled (Base)" *= CurrentSignFactor;
                    recTrackingSpec."Quantity Invoiced (Base)" *= CurrentSignFactor;
                    recTrackingSpec."Qty. to Handle" := recTrackingSpec.CalcQty(recTrackingSpec."Qty. to Handle (Base)");
                    recTrackingSpec."Qty. to Invoice" := recTrackingSpec.CalcQty(recTrackingSpec."Qty. to Invoice (Base)");
                    recTrackingSpec."Entry No." := NextEntryNo();

                    // skip expiration date check for performance
                    // item tracking code is cached at the beginning of the caller method
                    if not ItemTrackingCode."Use Expiration Dates" then
                        recTrackingSpec."Buffer Status2" := recTrackingSpec."Buffer Status2"::"ExpDate blocked"
                    else begin
                        ExpDate := ItemTrackingMgt.ExistingExpirationDate(recTrackingSpec, false, EntriesExist);
                        if ExpDate <> 0D then begin
                            recTrackingSpec."Expiration Date" := ExpDate;
                            recTrackingSpec."Buffer Status2" := recTrackingSpec."Buffer Status2"::"ExpDate blocked";
                        end;
                    end;

                    recTrackingSpec.Insert();

                    if recTrackingSpec."Buffer Status" = 0 then begin
                        TempTrackingSpecification2 := recTrackingSpec;
                        TempTrackingSpecification2.Insert();
                    end;
                end;

                if ItemLedgerEntryFilter = '' then begin
                    TempTrackingSpecification.Find('+');
                    TempTrackingSpecification.ClearTrackingFilter();
                end;
            until TempTrackingSpecification.Next() = 0;
    end;

    procedure NextEntryNo(): Integer
    begin
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    local procedure UpdateReceiptShipmentNo(var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if TempTrackingSpecification.FindSet() then
            repeat
                ItemLedgerEntry.SetLoadFields("Document No.");
                if ItemLedgerEntry.Get(TempTrackingSpecification."Item Ledger Entry No.") then begin
                    TempTrackingSpecification."Receipt/Shipment No." := ItemLedgerEntry."Document No.";
                    TempTrackingSpecification.Modify();
                end;
            until TempTrackingSpecification.Next() = 0;
    end;

    local procedure CollectPostedTransferEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> Database::"Transfer Line" then
            exit;

        ItemEntryRelation.SetCurrentKey("Order No.", "Order Line No.");
        ItemEntryRelation.SetRange("Order No.", TrackingSpecification."Source ID");
        ItemEntryRelation.SetRange("Order Line No.", TrackingSpecification."Source Ref. No.");

        case TrackingSpecification."Source Subtype" of
            0: // Outbound
                ItemEntryRelation.SetRange("Source Type", Database::"Transfer Shipment Line");
            1: // Inbound
                ItemEntryRelation.SetRange("Source Type", Database::"Transfer Receipt Line");
        end;

        if ItemEntryRelation.Find('-') then
            repeat
                ItemLedgerEntry.Get(ItemEntryRelation."Item Entry No.");
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip();
                TempTrackingSpecification.Insert();
            until ItemEntryRelation.Next() = 0;
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification")
    begin
        recTrackingSpec.FilterGroup := 2;
        recTrackingSpec.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        recTrackingSpec.SetRange("Source ID", TrackingSpecification."Source ID");
        recTrackingSpec.SetRange("Source Type", TrackingSpecification."Source Type");
        recTrackingSpec.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
        recTrackingSpec.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
            recTrackingSpec.SetFilter("Source Prod. Order Line", '0 | ' + Format(TrackingSpecification."Source Ref. No."));
            recTrackingSpec.SetRange("Source Ref. No.");
        end else begin
            recTrackingSpec.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
            recTrackingSpec.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        end;
        recTrackingSpec.SetRange("Item No.", TrackingSpecification."Item No.");
        recTrackingSpec.SetRange("Location Code", TrackingSpecification."Location Code");
        recTrackingSpec.SetRange("Variant Code", TrackingSpecification."Variant Code");
        recTrackingSpec.FilterGroup := 0;
    end;

    local procedure FillSourceQuantityArray(TrackingSpecification: Record "Tracking Specification")
    var
        IsHandled: Boolean;
    begin
        SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
        SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
        SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
        SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
        SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
    end;

    local procedure CheckTrackingSpecificationSource(TrackingSpecification: Record "Tracking Specification"): Boolean
    begin
        if not ((TrackingSpecification."Source Type" = Database::"Sales Line") and (TrackingSpecification."Source Subtype" = TrackingSpecification."Source Subtype"::"1")) then
            exit(true);

        if ((TrackingSpecification."Source Type" = Database::"Sales Line") and (TrackingSpecification."Source Subtype" = TrackingSpecification."Source Subtype"::"1") and
           (TrackingSpecification."Lot No." <> '')) then
            exit(true)
        else
            exit(false);
    end;

    local procedure SetSourceSpecForTransferReceipt(TrackingSpecification: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification2: Record "Tracking Specification" temporary)
    var
        IsHandled: Boolean;
    begin
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (CurrentRunMode <> CurrentRunMode::Transfer) and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
            ReservEntry.SetRange("Source Subtype", 0);
            AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification2, true, 8421504);
            ReservEntry.SetRange("Source Subtype", 1);
            ReservEntry.SetRange("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            ReservEntry.SetRange("Source Ref. No.");
            DeleteIsBlocked := true;
        end;
    end;

    protected procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer)
    begin
        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, SwapSign, Color, 0);
    end;

    protected procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer; SrcQtyRoundingPrecision: Decimal)
    var
        FromReservEntry: Record "Reservation Entry";
        AddTracking: Boolean;
    begin
        if ReservEntry.FindSet() then
            repeat
                if Color = 0 then begin
                    TempReservEntry := ReservEntry;
                    TempReservEntry.Insert();
                end;
                if ReservEntry.TrackingExists() or (ReservEntry.IsReclass() and ReservEntry.NewTrackingExists()) then begin
                    AddTracking := true;
                    if SecondSourceID = Database::"Warehouse Shipment Line" then
                        if FromReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then
                            AddTracking := (FromReservEntry."Source Type" = 900) = IsAssembleToOrder // Database::"Assembly Header"
                        else
                            AddTracking := not IsAssembleToOrder;

                    if AddTracking then begin
                        TempTrackingSpecification.TransferFields(ReservEntry);
                        TempTrackingSpecification."Qty. Rounding Precision (Base)" := SrcQtyRoundingPrecision;
                        // Ensure uniqueness of Entry No. by making it negative:
                        TempTrackingSpecification."Entry No." *= -1;
                        if SwapSign then
                            TempTrackingSpecification."Quantity (Base)" *= -1;
                        if Color <> 0 then begin
                            TempTrackingSpecification."Quantity Handled (Base)" := TempTrackingSpecification."Quantity (Base)";
                            TempTrackingSpecification."Quantity Invoiced (Base)" := TempTrackingSpecification."Quantity (Base)";
                            TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                            TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                        end;
                        TempTrackingSpecification."Buffer Status" := Color;
                        TempTrackingSpecification.Insert();
                    end;
                end;
            until ReservEntry.Next() = 0;
    end;

    protected procedure GetItem(ItemNo: Code[20])
    begin
        if Item."No." <> ItemNo then begin
            Item.Get(ItemNo);
            Item.TestField("Item Tracking Code");
            if ItemTrackingCode.Code <> Item."Item Tracking Code" then
                ItemTrackingCode.Get(Item."Item Tracking Code");
        end;
    end;

    local procedure InitItemTrackingSummaryForm(var ItemTrackingSummaryForm: Page "Item Tracking Summary"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SearchForSupply: Boolean; CurrentSignFactor: Integer; LookupMode: Enum "Item Tracking Type"; MaxQuantity: Decimal)
    var
        Window: Dialog;
        IsHandled: Boolean;
    begin
        Window.Open(Text004);

        // if not FullGlobalDataSetExists then
        RetrieveLookupData(TempTrackingSpecification, true);

        TempGlobalReservEntry.Reset();
        TempGlobalEntrySummary.Reset();

        // Select the proper key on form
        TempGlobalEntrySummary.SetCurrentKey("Expiration Date");
        TempGlobalEntrySummary.SetFilter("Expiration Date", '<>%1', 0D);
        if TempGlobalEntrySummary.IsEmpty() then
            TempGlobalEntrySummary.SetTrackingKey();
        TempGlobalEntrySummary.SetRange("Expiration Date");
        ItemTrackingSummaryForm.SetTableView(TempGlobalEntrySummary);

        TempGlobalEntrySummary.SetTrackingKey();
        case LookupMode of
            LookupMode::"Lot No.":
                AssistEditTrackingNoLookupLotNo(TempTrackingSpecification, ItemTrackingSummaryForm);
        end;

        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode, CurrItemTrackingCode);
        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry, TempGlobalEntrySummary);
        ItemTrackingSummaryForm.LookupMode(SearchForSupply);
        ItemTrackingSummaryForm.SetSelectionMode(false);

        Window.Close();
    end;

    local procedure AssistEditTrackingNoLookupLotNo(TempTrackingSpecification: Record "Tracking Specification" temporary; var ItemTrackingSummaryPage: Page "Item Tracking Summary")
    begin
        if TempTrackingSpecification."Serial No." <> '' then
            TempGlobalEntrySummary.SetRange("Serial No.", TempTrackingSpecification."Serial No.")
        else
            TempGlobalEntrySummary.SetRange("Serial No.", '');
        TempGlobalEntrySummary.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
        if TempGlobalEntrySummary.FindFirst() then
            ItemTrackingSummaryPage.SetRecord(TempGlobalEntrySummary);
        TempGlobalEntrySummary.SetRange("Lot No.");
        TempGlobalEntrySummary.SetRange("Non Serial Tracking", true);
        ItemTrackingSummaryPage.Caption := StrSubstNo(ListTxt, TempGlobalEntrySummary.FieldCaption("Lot No."));
    end;

    procedure RetrieveLookupData(var TempTrackingSpecification: Record "Tracking Specification" temporary; FullDataSet: Boolean)
    begin
        RetrieveLookupData(TempTrackingSpecification, FullDataSet, IsolationLevel::Default);
    end;

    local procedure RetrieveLookupData(var TempTrackingSpecification: Record "Tracking Specification" temporary; FullDataSet: Boolean; ReservEntryReadIsolation: IsolationLevel)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        LotNo, PackageNo : Code[50];
    begin
        LastSummaryEntryNo := 0;
        LastReservEntryNo := 2147483647;
        TempTrackingSpecification2 := TempTrackingSpecification;
        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.DeleteAll();
        TempGlobalEntrySummary.Reset();
        TempGlobalEntrySummary.DeleteAll();

        ReservEntry.Reset();
        ReservEntry.ReadIsolation := ReservEntryReadIsolation;
        ReservEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Item Tracking");
        ReservEntry.SetRange("Item No.", TempTrackingSpecification."Item No.");
        ReservEntry.SetRange("Variant Code", TempTrackingSpecification."Variant Code");
        ReservEntry.SetRange("Location Code", TempTrackingSpecification."Location Code");
        ReservEntry.SetFilter("Item Tracking", '<>%1', ReservEntry."Item Tracking"::None);
        if ReservEntry.FindSet() then
            repeat
                TempReservEntry := ReservEntry;
                if CanIncludeReservEntryToTrackingSpec(TempReservEntry) then
                    TempReservEntry.Insert();
            until ReservEntry.Next() = 0;

        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Entry No.");
        ItemLedgEntry.SetRange("Item No.", TempTrackingSpecification."Item No.");
        ItemLedgEntry.SetRange("Variant Code", TempTrackingSpecification."Variant Code");
        ItemLedgEntry.SetRange(Open, true);
        ItemLedgEntry.SetRange("Location Code", TempTrackingSpecification."Location Code");

        LotNo := '';
        PackageNo := '';
        if FullDataSet then begin
            TransferReservEntryToTempRec(TempReservEntry, TempTrackingSpecification);
            TransferItemLedgToTempRec(ItemLedgEntry, TempTrackingSpecification);
        end else
            if TempTrackingSpecification.FindSet() then
                repeat
                    ItemLedgEntry.ClearTrackingFilter();
                    TempReservEntry.ClearTrackingFilter();

                    if (TempTrackingSpecification."Lot No." <> '') and (TempTrackingSpecification."Lot No." <> LotNo) then begin
                        LotNo := TempTrackingSpecification."Lot No.";
                        ItemLedgEntry.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
                        TempReservEntry.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
                        TransferReservEntryToTempRec(TempReservEntry, TempTrackingSpecification);
                        TransferItemLedgToTempRec(ItemLedgEntry, TempTrackingSpecification);
                    end;

                    ItemLedgEntry.ClearTrackingFilter();
                    TempReservEntry.ClearTrackingFilter();
                    if (TempTrackingSpecification."Package No." <> '') and (TempTrackingSpecification."Package No." <> PackageNo) then begin
                        PackageNo := TempTrackingSpecification."Package No.";
                        ItemLedgEntry.SetRange("Package No.", TempTrackingSpecification."Package No.");
                        TempReservEntry.SetRange("Package No.", TempTrackingSpecification."Package No.");
                        TransferReservEntryToTempRec(TempReservEntry, TempTrackingSpecification);
                        TransferItemLedgToTempRec(ItemLedgEntry, TempTrackingSpecification);
                    end;

                    if (TempTrackingSpecification."Lot No." = '') and (TempTrackingSpecification."Package No." = '') and (TempTrackingSpecification."Serial No." <> '') then begin
                        ItemLedgEntry.SetTrackingFilterFromSpec(TempTrackingSpecification);
                        TempReservEntry.SetTrackingFilterFromSpec(TempTrackingSpecification);
                        TransferReservEntryToTempRec(TempReservEntry, TempTrackingSpecification);
                        TransferItemLedgToTempRec(ItemLedgEntry, TempTrackingSpecification);
                    end;
                until TempTrackingSpecification.Next() = 0;

        TempGlobalEntrySummary.Reset();
        UpdateCurrentPendingQty();
        TempTrackingSpecification := TempTrackingSpecification2;

        PartialGlobalDataSetExists := true;
        FullGlobalDataSetExists := FullDataSet;
        AdjustForDoubleEntriesForManufacturing();
        AdjustForDoubleEntriesForJobs();
    end;

    local procedure AdjustForDoubleEntriesForManufacturing()
    begin
        TempGlobalAdjustEntry.Reset();
        TempGlobalAdjustEntry.DeleteAll();

        TempGlobalTrackingSpec.Reset();
        TempGlobalTrackingSpec.DeleteAll();

        // Check if there is any need to investigate:
        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type", Database::"Item Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype", 5, 6); // Consumption, Output
        if TempGlobalReservEntry.IsEmpty() then  // No journal lines with consumption or output exist
            exit;

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Source Type", 5406); // Database::"Prod. Order Line"
        TempGlobalReservEntry.SetRange("Source Subtype", 3); // Released order
        if TempGlobalReservEntry.FindSet() then
            repeat
                // Sum up per prod. order line per lot/sn
                SumUpTempTrkgSpec(TempGlobalTrackingSpec, TempGlobalReservEntry);
            until TempGlobalReservEntry.Next() = 0;

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Source Type", 5407); // Database::"Prod. Order Component"
        TempGlobalReservEntry.SetRange("Source Subtype", 3); // Released order
        if TempGlobalReservEntry.FindSet() then
            repeat
                // Sum up per prod. order component per lot/sn
                SumUpTempTrkgSpec(TempGlobalTrackingSpec, TempGlobalReservEntry);
            until TempGlobalReservEntry.Next() = 0;

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type", Database::"Item Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype", 5, 6); // Consumption, Output

        if TempGlobalReservEntry.FindSet() then
            repeat
                // Sum up per Component line per lot/sn
                RelateJnlLineToTempTrkgSpec(TempGlobalReservEntry, TempGlobalTrackingSpec);
            until TempGlobalReservEntry.Next() = 0;

        InsertAdjustmentEntries();
    end;

    local procedure InsertAdjustmentEntries()
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        TempGlobalAdjustEntry.Reset();
        if not TempGlobalAdjustEntry.FindSet() then
            exit;

        TempTrackingSpecification.Init();
        TempTrackingSpecification.Insert();
        repeat
            CreateEntrySummary(TempTrackingSpecification, TempGlobalAdjustEntry); // TrackingSpecification is a dummy record
            TempGlobalReservEntry := TempGlobalAdjustEntry;
            TempGlobalReservEntry.Insert();
        until TempGlobalAdjustEntry.Next() = 0;
    end;

    procedure RelateJnlLineToTempTrkgSpec(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemTrackingSetup: Record "Item Tracking Setup";
        RemainingQty: Decimal;
        AdjustQty: Decimal;
        QtyOnJnlLine: Decimal;
    begin
        // Pre-check
        ReservEntry.TestField("Reservation Status", ReservEntry."Reservation Status"::Prospect);
        ReservEntry.TestField("Source Type", Database::"Item Journal Line");
        if not (ReservEntry."Source Subtype" in [5, 6]) then
            ReservEntry.FieldError("Source Subtype");

        if not ItemJnlLine.Get(ReservEntry."Source ID",
             ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.")
        then
            exit;

        if (ItemJnlLine."Order Type" <> ItemJnlLine."Order Type"::Production) or
           (ItemJnlLine."Order No." = '') or
           (ItemJnlLine."Order Line No." = 0)
        then
            exit;

        // Buffer fields are used as follows:
        // "Buffer Value1" : Summed up quantity on journal line(s)
        // "Buffer Value2" : Adjustment needed to neutralize double entries

        ItemTrackingSetup.CopyTrackingFromReservEntry(ReservEntry);
        if FindRelatedParentTrkgSpec(ItemJnlLine, TempTrackingSpecification, ItemTrackingSetup) then begin
            RemainingQty := TempTrackingSpecification."Quantity (Base)" + TempTrackingSpecification."Buffer Value2";
            QtyOnJnlLine := ReservEntry."Quantity (Base)";
            ReservEntry."Transferred from Entry No." := Abs(TempTrackingSpecification."Entry No.");
            ReservEntry.Modify();

            if (RemainingQty <> 0) and (RemainingQty * QtyOnJnlLine > 0) then
                if Abs(QtyOnJnlLine) <= Abs(RemainingQty) then
                    AdjustQty := -QtyOnJnlLine
                else
                    AdjustQty := -RemainingQty;

            TempTrackingSpecification."Buffer Value1" += QtyOnJnlLine;
            TempTrackingSpecification."Buffer Value2" += AdjustQty;
            TempTrackingSpecification.Modify();
            AddToAdjustmentEntryDataSet(ReservEntry, AdjustQty);
        end;
    end;

    local procedure AddToAdjustmentEntryDataSet(var ReservEntry: Record "Reservation Entry"; AdjustQty: Decimal)
    begin
        if AdjustQty = 0 then
            exit;

        TempGlobalAdjustEntry := ReservEntry;
        TempGlobalAdjustEntry."Source Type" := -ReservEntry."Source Type";
        TempGlobalAdjustEntry.Description := CopyStr(Text013, 1, MaxStrLen(TempGlobalAdjustEntry.Description));
        TempGlobalAdjustEntry."Quantity (Base)" := AdjustQty;
        TempGlobalAdjustEntry."Entry No." := LastReservEntryNo; // Use last entry no as offset to avoid inserting existing entry
        LastReservEntryNo -= 1;
        TempGlobalAdjustEntry.Insert();
    end;

    procedure SumUpTempTrkgSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservEntry: Record "Reservation Entry")
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        TempTrackingSpecification.SetSourceFilter(
          ReservEntry."Source Type", ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.", false);
        TempTrackingSpecification.SetSourceFilter(ReservEntry."Source Batch Name", ReservEntry."Source Prod. Order Line");
        TempTrackingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
        if TempTrackingSpecification.FindFirst() then begin
            TempTrackingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
            TempTrackingSpecification.Modify();
        end else begin
            ItemTrackingMgt.CreateTrackingSpecification(ReservEntry, TempTrackingSpecification);
            if not ReservEntry.Positive then               // To avoid inserting existing entry when both sides of the reservation
                TempTrackingSpecification."Entry No." *= -1; // are handled.
            TempTrackingSpecification.Insert();
        end;
    end;

    local procedure AdjustForDoubleEntriesForJobs()
    begin
        TempGlobalAdjustEntry.Reset();
        TempGlobalAdjustEntry.DeleteAll();

        TempGlobalTrackingSpec.Reset();
        TempGlobalTrackingSpec.DeleteAll();

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type", Database::"Job Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype", 0); // Job Journal
        if TempGlobalReservEntry.IsEmpty() then  // No journal lines with reservation exists
            exit;

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Source Type", Database::"Job Planning Line");
        TempGlobalReservEntry.SetRange("Source Subtype", 2);
        if TempGlobalReservEntry.FindSet() then
            repeat
                // Sum up per job planning line per lot/sn
                SumUpTempTrkgSpec(TempGlobalTrackingSpec, TempGlobalReservEntry);
            until TempGlobalReservEntry.Next() = 0;

        TempGlobalReservEntry.Reset();
        TempGlobalReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type", Database::"Job Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype", 0);

        if TempGlobalReservEntry.FindSet() then
            repeat
                // Sum up per qty. line per lot/sn
                RelateJobJnlLineToTempTrkgSpec(TempGlobalReservEntry, TempGlobalTrackingSpec);
            until TempGlobalReservEntry.Next() = 0;

        InsertAdjustmentEntries();
    end;

    procedure RelateJobJnlLineToTempTrkgSpec(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        JobJnlLine: Record "Job Journal Line";
        ItemTrackingSetup: Record "Item Tracking Setup";
        RemainingQty: Decimal;
        AdjustQty: Decimal;
        QtyOnJnlLine: Decimal;
    begin
        // Pre-check
        ReservEntry.TestField("Reservation Status", ReservEntry."Reservation Status"::Prospect);
        ReservEntry.TestField("Source Type", Database::"Job Journal Line");
        if not (ReservEntry."Source Subtype" = 0) then
            ReservEntry.FieldError("Source Subtype");

        if not JobJnlLine.Get(ReservEntry."Source ID",
             ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.")
        then
            exit;

        // Buffer fields are used as follows:
        // "Buffer Value1" : Summed up quantity on journal line(s)
        // "Buffer Value2" : Adjustment needed to neutralize double entries

        ItemTrackingSetup.CopyTrackingFromReservEntry(ReservEntry);
        if FindRelatedJobParentTrkgSpec(JobJnlLine, TempTrackingSpecification, ItemTrackingSetup) then begin
            RemainingQty := TempTrackingSpecification."Quantity (Base)" + TempTrackingSpecification."Buffer Value2";
            QtyOnJnlLine := ReservEntry."Quantity (Base)";
            ReservEntry."Transferred from Entry No." := Abs(TempTrackingSpecification."Entry No.");
            ReservEntry.Modify();

            if (RemainingQty <> 0) and (RemainingQty * QtyOnJnlLine > 0) then
                if Abs(QtyOnJnlLine) <= Abs(RemainingQty) then
                    AdjustQty := -QtyOnJnlLine
                else
                    AdjustQty := -RemainingQty;
            TempTrackingSpecification."Buffer Value1" += QtyOnJnlLine;
            TempTrackingSpecification."Buffer Value2" += AdjustQty;
            TempTrackingSpecification.Modify();
            AddToAdjustmentEntryDataSet(ReservEntry, AdjustQty);
        end;
    end;

    local procedure FindRelatedJobParentTrkgSpec(JobJnlLine: Record "Job Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; ItemTrackingSetup: Record "Item Tracking Setup"): Boolean
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        if JobPlanningLine.Get(JobJnlLine."Job No.", JobJnlLine."Job Task No.", JobJnlLine."Job Planning Line No.") then begin
            TempTrackingSpecification.Reset();
            TempTrackingSpecification.SetSourceFilter(
            Database::"Job Planning Line", 2, JobJnlLine."Job No.", JobPlanningLine."Job Contract Entry No.", false);
            TempTrackingSpecification.SetSourceFilter('', 0);
            TempTrackingSpecification.SetTrackingFilterFromItemTrackingSetup(ItemTrackingSetup);
            exit(TempTrackingSpecification.FindFirst());
        end;
    end;

    local procedure UpdateCurrentPendingQty()
    var
        TempLastGlobalEntrySummary: Record "Entry Summary" temporary;
        IsHandled: Boolean;
    begin
        TempGlobalChangedEntrySummary.Reset();
        TempGlobalChangedEntrySummary.SetTrackingKey();
        if TempGlobalChangedEntrySummary.FindSet() then
            repeat
                IsHandled := false;
                if not IsHandled then begin
                    if TempGlobalChangedEntrySummary.HasNonSerialTracking() then begin
                        // only last record with Lot Number updates Summary
                        if not TempGlobalChangedEntrySummary.HasSameNonSerialTracking(TempLastGlobalEntrySummary) then
                            FindLastGlobalEntrySummary(TempGlobalChangedEntrySummary, TempLastGlobalEntrySummary);
                        SkipLot := not (TempGlobalChangedEntrySummary."Entry No." = TempLastGlobalEntrySummary."Entry No.");
                    end;
                    UpdateTempSummaryWithChange(TempGlobalChangedEntrySummary);
                end;
            until TempGlobalChangedEntrySummary.Next() = 0;
    end;

    local procedure FindLastGlobalEntrySummary(var GlobalChangedEntrySummary: Record "Entry Summary"; var LastGlobalEntrySummary: Record "Entry Summary")
    var
        TempGlobalChangedEntrySummary2: Record "Entry Summary" temporary;
    begin
        TempGlobalChangedEntrySummary2 := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.SetNonSerialTrackingFilterFromEntrySummary(GlobalChangedEntrySummary);
        if GlobalChangedEntrySummary.FindLast() then
            LastGlobalEntrySummary := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.Copy(TempGlobalChangedEntrySummary2);
    end;

    local procedure UpdateTempSummaryWithChange(var TempChangedEntrySummary: Record "Entry Summary" temporary)
    var
        LastEntryNo: Integer;
        SumOfSNPendingQuantity: Decimal;
        SumOfSNRequestedQuantity: Decimal;
        IsHandled: Boolean;
    begin
        TempGlobalEntrySummary.Reset();
        LastEntryNo := TempGlobalEntrySummary.GetLastEntryNo();

        TempGlobalEntrySummary.SetTrackingKey();
        if TempChangedEntrySummary."Serial No." <> '' then begin
            TempGlobalEntrySummary.SetTrackingFilterFromEntrySummary(TempChangedEntrySummary);
            if TempGlobalEntrySummary.FindFirst() then begin
                TempGlobalEntrySummary."Current Pending Quantity" := TempChangedEntrySummary."Current Pending Quantity" -
                  TempGlobalEntrySummary."Current Requested Quantity";
                TempGlobalEntrySummary.UpdateAvailable();
                TempGlobalEntrySummary.Modify();
            end else begin
                TempGlobalEntrySummary := TempChangedEntrySummary;
                TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
                LastEntryNo := TempGlobalEntrySummary."Entry No.";
                TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
                UpdateBinContent(TempGlobalEntrySummary);
                TempGlobalEntrySummary.UpdateAvailable();
                TempGlobalEntrySummary.Insert();
            end;

            if TempChangedEntrySummary.HasNonSerialTracking() and not SkipLot then begin
                TempGlobalEntrySummary.SetFilter("Serial No.", '<>%1', '');
                TempGlobalEntrySummary.SetNonSerialTrackingFilterFromEntrySummary(TempChangedEntrySummary);
                TempGlobalEntrySummary.CalcSums("Current Pending Quantity", "Current Requested Quantity");
                SumOfSNPendingQuantity := TempGlobalEntrySummary."Current Pending Quantity";
                SumOfSNRequestedQuantity := TempGlobalEntrySummary."Current Requested Quantity";
            end;
        end;

        if TempChangedEntrySummary.HasNonSerialTracking() and not SkipLot then begin
            TempGlobalEntrySummary.SetRange("Serial No.", '');
            TempGlobalEntrySummary.SetNonSerialTrackingFilterFromEntrySummary(TempChangedEntrySummary);

            if TempChangedEntrySummary."Serial No." <> '' then
                TempGlobalEntrySummary.SetRange("Table ID", 0)
            else
                TempGlobalEntrySummary.SetFilter("Table ID", '<>%1', 0);

            if TempGlobalEntrySummary.FindFirst() then begin
                if TempChangedEntrySummary."Serial No." <> '' then begin
                    TempGlobalEntrySummary."Current Pending Quantity" := SumOfSNPendingQuantity;
                    TempGlobalEntrySummary."Current Requested Quantity" := SumOfSNRequestedQuantity;
                end else
                    TempGlobalEntrySummary."Current Pending Quantity" := TempChangedEntrySummary."Current Pending Quantity" -
                      TempGlobalEntrySummary."Current Requested Quantity";

                TempGlobalEntrySummary.UpdateAvailable();
                TempGlobalEntrySummary.Modify();
            end else begin
                TempGlobalEntrySummary := TempChangedEntrySummary;
                TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
                TempGlobalEntrySummary."Serial No." := '';
                if TempChangedEntrySummary."Serial No." <> '' then // Mark as summation
                    TempGlobalEntrySummary."Table ID" := 0
                else
                    TempGlobalEntrySummary."Table ID" := Database::"Tracking Specification";
                TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
                UpdateBinContent(TempGlobalEntrySummary);
                TempGlobalEntrySummary.UpdateAvailable();
                TempGlobalEntrySummary.Insert();
            end;
        end;
    end;

    local procedure CanIncludeReservEntryToTrackingSpec(TempReservEntry: Record "Reservation Entry" temporary) Result: Boolean
    var
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        if (TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Prospect) and
               (TempReservEntry."Source Type" = Database::"Sales Line") and
               (TempReservEntry."Source Subtype" = 2)
        then begin
            SalesLine.SetLoadFields("Shipment No.");
            SalesLine.Get(TempReservEntry."Source Subtype", TempReservEntry."Source ID", TempReservEntry."Source Ref. No.");
            if SalesLine."Shipment No." <> '' then
                exit(false);
        end;

        exit(true);
    end;

    procedure TransferReservEntryToTempRec(var TempReservEntry: Record "Reservation Entry" temporary; var TrackingSpecification: Record "Tracking Specification" temporary)
    var
        IsHandled: Boolean;
    begin
        if TempReservEntry.FindSet() then
            repeat
                if not TempGlobalReservEntry.Get(TempReservEntry."Entry No.", TempReservEntry.Positive) then begin
                    TempGlobalReservEntry := TempReservEntry;
                    TempGlobalReservEntry."Transferred from Entry No." := 0;
                    IsHandled := false;

                    if not IsHandled then begin
                        TempGlobalReservEntry.Insert();
                        CreateEntrySummary(TrackingSpecification, TempGlobalReservEntry);
                    end;
                end;
            until TempReservEntry.Next() = 0;
    end;

    local procedure CreateEntrySummary(TrackingSpecification: Record "Tracking Specification" temporary; TempReservEntry: Record "Reservation Entry" temporary)
    begin
        CreateEntrySummary2(TrackingSpecification, TempReservEntry, true);
        CreateEntrySummary2(TrackingSpecification, TempReservEntry, false);
    end;

    local procedure CreateEntrySummary2(TempTrackingSpecification: Record "Tracking Specification" temporary; TempReservEntry: Record "Reservation Entry" temporary; SerialNoLookup: Boolean)
    var
        LateBindingManagement: Codeunit "Late Binding Management";
        DoInsert: Boolean;
    begin
        TempGlobalEntrySummary.Reset();
        TempGlobalEntrySummary.SetTrackingKey();

        if SerialNoLookup then begin
            if TempReservEntry."Serial No." = '' then
                exit;

            TempGlobalEntrySummary.SetTrackingFilterFromReservEntry(TempReservEntry);
        end else begin
            if not TempReservEntry.NonSerialTrackingExists() then
                exit;

            TempGlobalEntrySummary.SetRange("Serial No.", '');
            TempGlobalEntrySummary.SetNonSerialTrackingFilterFromReservEntry(TempReservEntry);
            if TempReservEntry."Serial No." <> '' then
                TempGlobalEntrySummary.SetRange("Table ID", 0)
            else
                TempGlobalEntrySummary.SetFilter("Table ID", '<>%1', 0);
        end;

        // If no summary exists, create new record
        if not TempGlobalEntrySummary.FindFirst() then begin
            TempGlobalEntrySummary.Init();
            TempGlobalEntrySummary."Entry No." := LastSummaryEntryNo + 1;
            LastSummaryEntryNo := TempGlobalEntrySummary."Entry No.";

            if not SerialNoLookup and (TempReservEntry."Serial No." <> '') then
                TempGlobalEntrySummary."Table ID" := 0 // Mark as summation
            else
                TempGlobalEntrySummary."Table ID" := TempReservEntry."Source Type";
            if SerialNoLookup then
                TempGlobalEntrySummary."Serial No." := TempReservEntry."Serial No."
            else
                TempGlobalEntrySummary."Serial No." := '';
            TempGlobalEntrySummary."Lot No." := TempReservEntry."Lot No.";
            TempGlobalEntrySummary."Non Serial Tracking" := TempGlobalEntrySummary.HasNonSerialTracking();
            TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
            UpdateBinContent(TempGlobalEntrySummary);

            // If consumption/output fill in double entry value here:
            TempGlobalEntrySummary."Double-entry Adjustment" :=
              MaxDoubleEntryAdjustQty(TempTrackingSpecification, TempGlobalEntrySummary);
            DoInsert := true;
        end;

        // Sum up values
        if TempReservEntry.Positive then begin
            TempGlobalEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
            TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
            if TempReservEntry."Entry No." < 0 then begin // The record represents an Item ledger entry
                TempGlobalEntrySummary."Non-specific Reserved Qty." +=
                  LateBindingManagement.NonSpecificReservedQtyExceptForSource(-TempReservEntry."Entry No.", TempTrackingSpecification);
                TempGlobalEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
            end;
            if TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation then
                TempGlobalEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
        end else begin
            if TempReservEntry."Qty. to Handle (Base)" <> 0 then
                TempGlobalEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
            if TempReservEntry.HasSamePointerWithSpec(TempTrackingSpecification) then begin
                if TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation then
                    TempGlobalEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
                if TempReservEntry."Entry No." > 0 then // The record represents a reservation entry
                    TempGlobalEntrySummary."Current Requested Quantity" -= TempReservEntry."Quantity (Base)";
            end;
        end;

        // Update available quantity on the record
        TempGlobalEntrySummary.UpdateAvailable();
        if DoInsert then
            TempGlobalEntrySummary.Insert()
        else
            TempGlobalEntrySummary.Modify();
    end;

    local procedure UpdateBinContent(var TempEntrySummary: Record "Entry Summary" temporary)
    var
        WarehouseEntry: Record "Warehouse Entry";
        WhseItemTrackingSetup: Record "Item Tracking Setup";
        IsHandled: Boolean;
    begin
        if CurrBinCode = '' then
            exit;

        CurrItemTrackingCode.TestField(Code);

        WarehouseEntry.Reset();
        WarehouseEntry.SetCurrentKey(
          "Item No.", "Bin Code", "Location Code", "Variant Code",
          "Unit of Measure Code", "Lot No.", "Serial No.", "Package No.");
        WarehouseEntry.SetRange("Item No.", TempGlobalReservEntry."Item No.");
        WarehouseEntry.SetRange("Bin Code", CurrBinCode);
        WarehouseEntry.SetRange("Location Code", TempGlobalReservEntry."Location Code");
        WarehouseEntry.SetRange("Variant Code", TempGlobalReservEntry."Variant Code");
        WhseItemTrackingSetup.CopyTrackingFromItemTrackingCodeWarehouseTracking(CurrItemTrackingCode);
        WhseItemTrackingSetup.CopyTrackingFromEntrySummary(TempEntrySummary);
        WarehouseEntry.SetTrackingFilterFromItemTrackingSetupIfRequiredIfNotBlank(WhseItemTrackingSetup);
        WarehouseEntry.CalcSums("Qty. (Base)");

        TempEntrySummary."Bin Content" := WarehouseEntry."Qty. (Base)";
    end;

    local procedure MaxDoubleEntryAdjustQty(var TempItemTrackLineChanged: Record "Tracking Specification" temporary; var ChangedEntrySummary: Record "Entry Summary" temporary): Decimal
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemTrackingSetup: Record "Item Tracking Setup";
    begin
        if not (TempItemTrackLineChanged."Source Type" = Database::"Item Journal Line") then
            exit;

        if not (TempItemTrackLineChanged."Source Subtype" in [5, 6]) then
            exit;

        if not ItemJnlLine.Get(TempItemTrackLineChanged."Source ID",
             TempItemTrackLineChanged."Source Batch Name", TempItemTrackLineChanged."Source Ref. No.")
        then
            exit;

        TempGlobalTrackingSpec.Reset();
        ItemTrackingSetup.CopyTrackingFromEntrySummary(ChangedEntrySummary);
        if FindRelatedParentTrkgSpec(ItemJnlLine, TempGlobalTrackingSpec, ItemTrackingSetup) then
            exit(-TempGlobalTrackingSpec."Quantity (Base)" - TempGlobalTrackingSpec."Buffer Value2");
    end;

    local procedure FindRelatedParentTrkgSpec(ItemJnlLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; ItemTrackingSetup: Record "Item Tracking Setup"): Boolean
    begin
        ItemJnlLine.TestField("Order Type", ItemJnlLine."Order Type"::Production);
        TempTrackingSpecification.Reset();
        TempTrackingSpecification.SetTrackingFilterFromItemTrackingSetup(ItemTrackingSetup);
        exit(TempTrackingSpecification.FindFirst());
    end;

    procedure TransferItemLedgToTempRec(var ItemLedgEntry: Record "Item Ledger Entry"; var TrackingSpecification: Record "Tracking Specification" temporary)
    var
        IsHandled: Boolean;
    begin
        ItemLedgEntry.SetLoadFields(
          "Entry No.", "Item No.", "Variant Code", Positive, "Location Code", "Serial No.", "Lot No.", "Package No.",
          "Remaining Quantity", "Warranty Date", "Expiration Date");
        if ItemLedgEntry.FindSet() then
            repeat
                if ItemLedgEntry.TrackingExists() and
                   not TempGlobalReservEntry.Get(-ItemLedgEntry."Entry No.", ItemLedgEntry.Positive)
                then begin
                    TempGlobalReservEntry.Init();
                    TempGlobalReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
                    TempGlobalReservEntry."Reservation Status" := TempGlobalReservEntry."Reservation Status"::Surplus;
                    TempGlobalReservEntry.Positive := ItemLedgEntry.Positive;
                    TempGlobalReservEntry."Item No." := ItemLedgEntry."Item No.";
                    TempGlobalReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
                    TempGlobalReservEntry."Location Code" := ItemLedgEntry."Location Code";
                    TempGlobalReservEntry."Quantity (Base)" := ItemLedgEntry."Remaining Quantity";
                    TempGlobalReservEntry."Source Type" := Database::"Item Ledger Entry";
                    TempGlobalReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
                    TempGlobalReservEntry.CopyTrackingFromItemLedgEntry(ItemLedgEntry);
                    if TempGlobalReservEntry.Positive then begin
                        TempGlobalReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
                        TempGlobalReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                        TempGlobalReservEntry."Expected Receipt Date" := 0D
                    end else
                        TempGlobalReservEntry."Shipment Date" := DMY2Date(31, 12, 9999);

                    IsHandled := false;
                    if not IsHandled then begin
                        TempGlobalReservEntry.Insert();
                        CreateEntrySummary(TrackingSpecification, TempGlobalReservEntry);
                    end;
                end;
            until ItemLedgEntry.Next() = 0;
    end;

    local procedure CalculateQtyAfterEditingTrackingLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; CurrentSignFactor: Integer; LookupMode: Enum "Item Tracking Type"; MaxQuantity: Decimal)
    var
        AvailableQty: Decimal;
        AdjustmentQty: Decimal;
        QtyOnLine: Decimal;
        QtyHandledOnLine: Decimal;
        NewQtyOnLine: Decimal;
    begin
        if TempGlobalEntrySummary."Bin Active" then
            AvailableQty := MinValueAbs(TempGlobalEntrySummary."Bin Content", TempGlobalEntrySummary."Total Available Quantity")
        else
            AvailableQty := TempGlobalEntrySummary."Total Available Quantity";
        QtyHandledOnLine := TempTrackingSpecification."Quantity Handled (Base)";
        QtyOnLine := TempTrackingSpecification."Quantity (Base)" - QtyHandledOnLine;

        if CurrentSignFactor > 0 then begin
            AvailableQty := -AvailableQty;
            QtyHandledOnLine := -QtyHandledOnLine;
            QtyOnLine := -QtyOnLine;
        end;

        if MaxQuantity < 0 then begin
            AdjustmentQty := MaxQuantity;
            if AvailableQty < 0 then
                if AdjustmentQty > AvailableQty then
                    AdjustmentQty := AvailableQty;
            if QtyOnLine + AdjustmentQty < 0 then
                AdjustmentQty := -QtyOnLine;
        end else begin
            AdjustmentQty := AvailableQty;
            if AvailableQty < 0 then begin
                if QtyOnLine + AdjustmentQty < 0 then
                    AdjustmentQty := -QtyOnLine;
            end else
                AdjustmentQty := MinValueAbs(MaxQuantity, AvailableQty);
        end;
        if LookupMode = LookupMode::"Serial No." then
            TempTrackingSpecification.Validate("Serial No.", TempGlobalEntrySummary."Serial No.");
        TempTrackingSpecification.Validate("Lot No.", TempGlobalEntrySummary."Lot No.");

        TransferExpDateFromSummary(TempTrackingSpecification, TempGlobalEntrySummary);
        if TempTrackingSpecification.IsReclass() or DirectTransfer then
            TempTrackingSpecification.CopyNewTrackingFromTrackingSpec(TempTrackingSpecification);

        NewQtyOnLine := CalcNewQtyOnLine(TempTrackingSpecification, QtyOnLine, AdjustmentQty, QtyHandledOnLine);

        TempTrackingSpecification.Validate("Quantity (Base)", NewQtyOnLine);
    end;

    local procedure CalcNewQtyOnLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; QtyOnLine: Decimal; AdjustmentQty: Decimal; QtyHandledOnLine: Decimal) NewQtyOnLine: Decimal
    var
        IsHandled: Boolean;
    begin
        NewQtyOnLine := QtyOnLine + AdjustmentQty + QtyHandledOnLine;
        if TempTrackingSpecification."Serial No." <> '' then
            if Abs(NewQtyOnLine) > 1 then
                NewQtyOnLine := NewQtyOnLine / Abs(NewQtyOnLine); // Set to a signed value of 1.
    end;

    local procedure MinValueAbs(Value1: Decimal; Value2: Decimal): Decimal
    begin
        if Abs(Value1) < Abs(Value2) then
            exit(Value1);

        exit(Value2);
    end;

    local procedure TransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification" temporary; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        // Handle Expiration Date
        if TempEntrySummary."Total Quantity" <> 0 then begin
            TrackingSpecification."Buffer Status2" := TrackingSpecification."Buffer Status2"::"ExpDate blocked";
            TrackingSpecification."Expiration Date" := TempEntrySummary."Expiration Date";
            TrackingSpecification."Warranty Date" := TempEntrySummary."Warranty Date";
            if TrackingSpecification.IsReclass() then
                TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date"
            else
                TrackingSpecification."New Expiration Date" := 0D;
        end else begin
            TrackingSpecification."Buffer Status2" := 0;
            TrackingSpecification."Expiration Date" := 0D;
            TrackingSpecification."New Expiration Date" := 0D;
            TrackingSpecification."Warranty Date" := 0D;
        end;
    end;

    procedure UpdateExpireDate()
    begin
        if rec."Data Type" IN [rec."Data Type"::"Adjust Output", rec."Data Type"::"Planned Output"] then begin
            Item.Get(Rec."Output Item No.");
            if Format(Item."Expiration Calculation") <> '' then begin
                if rec."Manufacturing Date" <> 0D then
                    Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Manufacturing Date")
                else
                    Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Posting Date");
            end;
        end else begin
            Item.Get(Rec."Item No.");
            if Format(Item."Expiration Calculation") <> '' then begin
                if rec."Manufacturing Date" <> 0D then
                    Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Manufacturing Date")
                else
                    Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Posting Date");
            end;
        end;
    end;
}
