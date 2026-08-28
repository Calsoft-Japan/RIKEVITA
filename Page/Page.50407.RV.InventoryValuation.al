
page 50407 "RV Inventory Valuation Name"
{
    ApplicationArea = All;
    Caption = 'Inventory Valuation';
    PageType = Card;
    //UsageCategory = tasks;
    SourceTable = "RV Invy. Valuation Name";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
                }
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Item Filter"; Rec."Item Filter")
                {
                    caption = 'Item Filter';
                    ToolTip = 'Specifies the value of the Item Filter field.', Comment = '%';
                    applicationarea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(ItemList);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text := ItemList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }

            }
            Part(DeliverySchedulingLines; "RV Inventory Valuation Line")
            {
                ApplicationArea = All;
                Caption = 'Delivery Scheduling Lines';
                UpdatePropagation = Both;
                SubPageLink = "Inventory Valuation Name" = field(Name);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Collect Data")
            {
                Caption = 'Collect Data';
                ApplicationArea = All;
                Image = InventoryCalculation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = false;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ReasonCode: Record "Reason Code";
                    SITEDimValue: Record "Dimension Value";
                begin
                    Rec.TestField("Starting Date");
                    InvyValuationLine.Reset();
                    InvyValuationLine.SetRange("Inventory Valuation Name", Rec.Name);
                    InvyValuationLine.DeleteAll();
                    VarianceRC := '';
                    WScrapRC := '';
                    SamDisposeRC := '';
                    SiteTransferRC := '';
                    InvyAdjustRC := '';
                    ReasonCode.Reset();
                    ReasonCode.SetRange("RV_Reason Code Type", reasoncode."RV_Reason Code Type"::"Sample Dispose");
                    IF ReasonCode.FindFirst() Then
                        SamDisposeRC := ReasonCode.Code
                    else
                        Error('please set the Sample Dispose reason code');
                    ReasonCode.SetRange("RV_Reason Code Type", reasoncode."RV_Reason Code Type"::Variance);
                    IF ReasonCode.FindFirst() Then
                        VarianceRC := ReasonCode.Code
                    else
                        Error('please set the Vaniance reason code');
                    ReasonCode.SetRange("RV_Reason Code Type", reasoncode."RV_Reason Code Type"::"Waste Scrap");
                    IF ReasonCode.FindFirst() Then
                        WScrapRC := ReasonCode.Code
                    else
                        Error('please set the Waste Scrap reason code');

                    ReasonCode.SetRange("RV_Reason Code Type", reasoncode."RV_Reason Code Type"::"Transfer Site");
                    IF ReasonCode.FindFirst() Then
                        SiteTransferRC := ReasonCode.Code
                    else
                        Error('please set the Transfer Site reason code');
                    ReasonCode.SetRange("RV_Reason Code Type", reasoncode."RV_Reason Code Type"::Blank);
                    IF ReasonCode.FindFirst() Then
                        InvyAdjustRC := ReasonCode.Code
                    else
                        Error('please set the Inventory Adjustment reason code');
                    StandardCostPeriod.reset;
                    StandardCostPeriod.Setfilter("Effective Start Date", '<=%1', Rec."Ending Date");
                    StandardCostPeriod.Setfilter("Effective End Date", '>=%1', Rec."Ending Date");
                    IF NOT StandardCostPeriod.FindLast() then begin
                        if NOT Dialog.Confirm('No found effective standart cost with the valuation date, Do you continute ?') then
                            Error('');
                        StandardCostPeriod.Init();
                    end;
                    GLSetup.get();
                    EntryNo := 1;
                    SITEDimValue.reset;
                    SITEDimValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                    If Rec.Site <> '' then
                        SITEDimValue.SetRange(Code, Rec.Site);
                    if SITEDimValue.FindSet() then
                        repeat
                            Item.reset;
                            Item.SetRange(Type, Item.type::Inventory);
                            if Rec."Item Filter" <> '' then
                                Item.SetFilter("No.", Rec."Item Filter");
                            If Item.findset then
                                repeat
                                    item.SetFilter("Global Dimension 2 Filter", SITEDimValue.Code);
                                    CalculateItem(Item)
                                until Item.Next = 0;
                        until SITEDimValue.next = 0;

                end;

            }

        }
    }


    procedure CalculateItem(var Item: Record Item)
    var
        HasEntriesWithinDateRange: Boolean;

    begin
        //Item.CalcFields("Assembly BOM");
        EndDate := Rec."Ending Date";
        StartDate := Rec."Starting Date";
        if EndDate = 0D then
            EndDate := DMY2Date(31, 12, 9999);

        StartingInvoicedQty := 0;
        StartingExpectedQty := 0;
        IncreaseInvoicedQty := 0;
        IncreaseExpectedQty := 0;
        DecreaseInvoicedQty := 0;
        DecreaseExpectedQty := 0;
        VarianceInvoicedQty := 0;
        DisposeInvoicedQty := 0;
        WasteInvoicedQty := 0;
        VarianceExpectedQty := 0;
        DisposeExpectedQty := 0;
        WasteExpectedQty := 0;
        CreditExpectedQty := 0;
        CreditInvoicedQty := 0;

        StandardCostElent.Reset();

        RIKEVITASetup.get();
        ValueEntry.Reset();
        ValueEntry.SetRange("Item No.", Item."No.");
        ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        ValueEntry.SetRange("Posting Date", 0D, EndDate);
        IsEmptyLine := ValueEntry.IsEmpty();
        if not IsEmptyLine then begin
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            HasEntriesWithinDateRange := not ValueEntry.IsEmpty();
        end;
        ValueEntry.SetRange("Posting Date");

        if not IsEmptyLine then begin
            IsEmptyLine := true;
            if StartDate > 0D then begin
                ValueEntry.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
                ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, StartingInvoicedQty, StartingExpectedQty, 1);
                IsEmptyLine := IsEmptyLine and ((StartingInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((StartingExpectedQty = 0));
            end;
        end;
        if HasEntriesWithinDateRange then begin
            //Output Purchase Inbound
            //The purchase credit can not devide by ILE type and document type
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                "Item Ledger Entry Type", '%1',
                ValueEntry."Item Ledger Entry Type"::Purchase);
            ValueEntry.SetFilter("Invoiced Quantity", '>0');
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, IncreaseInvoicedQty, IncreaseExpectedQty, 1);

            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                "Item Ledger Entry Type", '%1|%2',
                ValueEntry."Item Ledger Entry Type"::Output,
                ValueEntry."Item Ledger Entry Type"::"Assembly Output");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, IncreaseInvoicedQty, IncreaseExpectedQty, 1);

            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2',
                ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.");
            ValueEntry.SetRange("Reason Code", InvyAdjustRC);
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, IncreaseInvoicedQty, IncreaseExpectedQty, -1);

            //Sales Consumption Outbound
            //The Sales credit can not devide by ILE type and document type
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetRange(
                "Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
            ValueEntry.SetFilter("Invoiced Quantity", '<0');
            ValueEntry.SetRange("Reason Code");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, DecreaseInvoicedQty, DecreaseExpectedQty, -1);

            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                "Item Ledger Entry Type", '%1|%2',
                  ValueEntry."Item Ledger Entry Type"::Consumption,
                ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
            ValueEntry.SetRange("Invoiced Quantity");
            ValueEntry.SetRange("Reason Code");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, DecreaseInvoicedQty, DecreaseExpectedQty, -1);

            //Purchase Credit quantity
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                "Item Ledger Entry Type", '%1',
                ValueEntry."Item Ledger Entry Type"::Purchase);
            ValueEntry.SetFilter("Invoiced Quantity", '<0');
            ValueEntry.SetRange("Reason Code");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, CreditInvoicedQty, CreditExpectedQty, -1);

            //Sales Credit quantity
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetRange(
                "Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
            ValueEntry.SetFilter("Invoiced Quantity", '>0');
            ValueEntry.SetRange("Reason Code");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, CreditInvoicedQty, CreditExpectedQty, 1);

            //Dispose
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                "Item Ledger Entry Type", '%1|%2',
                ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.");
            ValueEntry.SetRange("Reason Code", SamDisposeRC);
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, DisposeInvoicedQty, DisposeExpectedQty, -1);

            //Waste or Scrap
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                                "Item Ledger Entry Type", '%1|%2',
                ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.");
            ValueEntry.SetRange("Reason Code", WScrapRC);
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, WasteInvoicedQty, WasteExpectedQty, -1);

            //Variance
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2',
                ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.");
            ValueEntry.SetRange("Reason Code", VarianceRC);
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, VarianceInvoicedQty, VarianceExpectedQty, -1);

            //Site Transfer
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
            ValueEntry.SetRange("Reason Code", SiteTransferRC);
            ValueEntry.Setrange("Invoiced Quantity");
            ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
            ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
            AssignAmounts(ValueEntry, TransferExpectedQty, TransferInvoicedQty, -1);
            /*
            if ValueEntry.FindSet() then
                repeat
                    if true in [ValueEntry."Valued Quantity" < 0, not GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.", Item."No.", Rec.Site)] then
                        AssignAmounts(ValueEntry, TransferInvoicedQty, TransferExpectedQty, -1)
                    else
                        AssignAmounts(ValueEntry, TransferInvoicedQty, TransferExpectedQty, 1);
                until ValueEntry.Next() = 0;*/
        end;
        IsEmptyLine := IsEmptyLine and ((IncreaseInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((IncreaseExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((DecreaseExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((DecreaseInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((CreditInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((CreditExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((WasteExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((WasteInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((DisposeExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((DisposeInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((VarianceInvoicedQty = 0));
        IsEmptyLine := IsEmptyLine and ((VarianceExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((TransferExpectedQty = 0));
        IsEmptyLine := IsEmptyLine and ((TransferInvoicedQty = 0));

        if not IsEmptyLine then
            InsertInvyValuationLine(Item, Item.GetFilter("Global Dimension 2 Filter"));
    end;


    procedure AssignAmounts(ValueEntry: Record "Value Entry"; var InvoicedQty: Decimal; var ExpectedQty: Decimal; Sign: Decimal)
    begin

        InvoicedQty += ValueEntry."Invoiced Quantity" * Sign;
        ExpectedQty += ValueEntry."Item Ledger Entry Quantity" * Sign;
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer; ItemNo: Code[20]; SiteNo: Code[20]): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SetCurrentKey("Item Ledger Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
        if not ItemApplnEntry.FindFirst() then
            exit(true);

        ItemLedgEntry.SetRange("Item No.", ItemNo);
        ItemLedgEntry.SetFilter("Global Dimension 1 Code", SiteNo);
        ItemLedgEntry.SetRange("Entry No.", ItemApplnEntry."Outbound Item Entry No.");
        exit(ItemLedgEntry.IsEmpty());
    end;

    procedure InsertInvyValuationLine(Item: Record Item; SiteNo: Code[20])
    var

        LotInfo: Record "Lot No. Information";
        ItemCategory: Record "Item Category";
        StandardCostElent: Record "Standard Cost Element Details";
        StandUnitCost: Decimal;
        DefaultDim: Record "Default Dimension";
    begin
        InvyValuationLine.Init();
        //Filter infromation
        InvyValuationLine."Inventory Valuation Name" := Rec.Name;
        InvyValuationLine."Entry No." := EntryNo;
        EntryNo += 1;
        InvyValuationLine."Item No." := Item."No.";
        InvyValuationLine.Site := SiteNo;

        //Item master infromation
        StandardCostElent.Reset();
        StandardCostElent.SetRange("Item No.", Item."No.");
        StandardCostElent.SetRange(StandardCostElent."Period Code", StandardCostPeriod.Code);
        If StandardCostElent.FindFirst() then begin
            //InvyValuationLine."Standard Cost"
            //InvyValuationLine."Standard Cost UM"
            StandUnitCost := StandardCostElent."Direct Dep. Exp." +
                                   StandardCostElent."Direct Fixed Cost" +
                                   StandardCostElent."Direct Labor Cost" +
                                   StandardCostElent."Electricity Fee" +
                                   StandardCostElent."Gas Fee" +
                                   StandardCostElent."Indirect Cost" +
                                   StandardCostElent."Raw Material Cost" +
                                   StandardCostElent."Package Material Cost" +
                                   StandardCostElent.Water;
        end;
        InvyValuationLine."Item Description" := Item.Description;
        InvyValuationLine."Unit of Measure" := item."Base Unit of Measure";
        //InvyValuationLine."Standard Cost UM"
        //InvyValuationLine.Cap.
        DefaultDim.Reset();
        DefaultDim.SetRange("No.", Item."No.");
        DefaultDim.SetRange("Table ID", 27);
        DefaultDim.SetRange("Dimension Code", RIKEVITASetup."Segment Dim. Code");
        if DefaultDim.FindFirst() then
            InvyValuationLine.Segment := DefaultDim."Dimension Value Code";

        InvyValuationLine."Starting Balance Quantity" := StartingInvoicedQty;
        InvyValuationLine."Starting Balance Amount" := Round(StandUnitCost * StartingInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Period Order Quantity" := IncreaseInvoicedQty;
        InvyValuationLine."Period Order Amount" := Round(StandUnitCost * IncreaseInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Period Credit Quantity" := CreditInvoicedQty;
        InvyValuationLine."Period Order Credit Amount" := Round(StandUnitCost * InvyValuationLine."Period Credit Quantity", GLSetup."Amount Rounding Precision");

        InvyValuationLine."Sample Dispose Quantity" := DisposeInvoicedQty;
        InvyValuationLine."Sample Dispose Amount" := Round(StandUnitCost * DisposeInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Consumption Quantity" := DecreaseInvoicedQty;
        InvyValuationLine."Consumption Amount" := Round(StandUnitCost * DecreaseInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Waste Scrap Quantity" := WasteInvoicedQty;
        InvyValuationLine."Waste Scrap Amount" := Round(StandUnitCost * WasteInvoicedQty, GLSetup."Amount Rounding Precision");

        //InvyValuationLine."Transfer Quantity"
        InvyValuationLine."Transfer Amount" := Round(StandUnitCost * TransferInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Variance Quantity" := VarianceInvoicedQty;
        InvyValuationLine."Variance Amount" := Round(StandUnitCost * VarianceInvoicedQty, GLSetup."Amount Rounding Precision");

        InvyValuationLine."Ending Balance Quantity" := StartingInvoicedQty
        + IncreaseInvoicedQty
        + TransferInvoicedQty
        - CreditInvoicedQty
        - DisposeInvoicedQty
        - WasteInvoicedQty
        - VarianceInvoicedQty
        - DecreaseInvoicedQty;
        InvyValuationLine."Ending Balance Amount" := InvyValuationLine."Starting Balance Amount" +
                                                       InvyValuationLine."Period Order Amount" +
                                                       InvyValuationLine."Transfer Amount" -
                                                       InvyValuationLine."Period Order Credit Amount" -
                                                       InvyValuationLine."Sample Dispose Amount" -
                                                       InvyValuationLine."Consumption Amount" -
                                                       InvyValuationLine."Waste Scrap Amount" -
                                                       InvyValuationLine."Variance Amount";

        InvyValuationLine.Insert();
    end;

    var


    protected var
        ValueEntry: Record "Value Entry";
        StartDate: Date;
        EndDate: Date;
        ItemFilter: Text;
        StartDateText: Text[10];
        StartingInvoicedQty: Decimal;
        StartingExpectedQty: Decimal;
        IncreaseInvoicedQty: Decimal;
        IncreaseExpectedQty: Decimal;
        DecreaseInvoicedQty: Decimal;
        DecreaseExpectedQty: Decimal;
        VarianceExpectedQty: Decimal;
        VarianceInvoicedQty: Decimal;
        DisposeExpectedQty: Decimal;
        DisposeInvoicedQty: Decimal;
        WasteExpectedQty: Decimal;
        WasteInvoicedQty: Decimal;
        CreditExpectedQty: Decimal;
        CreditInvoicedQty: Decimal;
        TransferExpectedQty: Decimal;
        TransferInvoicedQty: Decimal;
        IsEmptyLine: Boolean;
        InvyValuationLine: record "RV.Inventory Valuation Line";
        EntryNo: Integer;
        VarianceRC: Code[10];
        WScrapRC: Code[10];
        SamDisposeRC: Code[10];
        SiteTransferRC: Code[10];
        InvyAdjustRC: Code[10];
        StandardCostElent: Record "Standard Cost Element Details";
        StandardCostPeriod: Record "Standard Cost Element Period";
        GLSetup: Record "General Ledger Setup";
        RIKEVITASetup: Record "RV RIKEVITA Setup";

}