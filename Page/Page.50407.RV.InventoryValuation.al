
page 50407 "RV Inventory Valuation Name"
{
    ApplicationArea = All;
    Caption = 'Inventory Valuation Name';
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
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
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
                begin
                    Rec.TestField("Starting Date");
                    InvyValuationLine.Reset();
                    InvyValuationLine.SetRange("Inventory Valuation Name", Rec.Name);
                    InvyValuationLine.DeleteAll();
                    VarianceRC := '';
                    WScrapRC := '';
                    SamDisposeRC := '';
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
                    EntryNo := 1;
                    Item.reset;
                    If Rec.Site <> '' then
                        Item.SetFilter("Global Dimension 1 Filter", Rec.Site);
                    Item.SetRange(Type, Item.type::Inventory);
                    If Item.findset then
                        repeat
                            CalculateItem(Item)
                        until Item.Next = 0;
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

        ValueEntry.Reset();
        ValueEntry.SetRange("Item No.", Item."No.");
        ValueEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
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
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, StartingInvoicedQty, StartingExpectedQty, 1);
                IsEmptyLine := IsEmptyLine and ((StartingInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((StartingExpectedQty = 0));
            end;
            //Output Purchase Inbound
            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2|%3',
                    ValueEntry."Item Ledger Entry Type"::Purchase,
                    //ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                    ValueEntry."Item Ledger Entry Type"::Output,
                    ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, IncreaseInvoicedQty, IncreaseExpectedQty, 1);
            end;
            //Sales Consumption Outbound
            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2|%3',
                    ValueEntry."Item Ledger Entry Type"::Sale,
                    //ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                    ValueEntry."Item Ledger Entry Type"::Consumption,
                    ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, DecreaseInvoicedQty, DecreaseExpectedQty, -1);
            end;

            //Dispose
            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange(
                    "Item Ledger Entry Type",
                    ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
                ValueEntry.SetRange("Reason Code", SamDisposeRC);
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, DisposeInvoicedQty, DisposeExpectedQty, -1);
            end;

            //Waste or Scrap
            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange(
                    "Item Ledger Entry Type",
                    ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
                ValueEntry.SetRange("Reason Code", WScrapRC);
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, WasteInvoicedQty, WasteExpectedQty, -1);
            end;

            //Variance
            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange(
                    "Item Ledger Entry Type",
                    ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
                ValueEntry.SetRange("Reason Code", VarianceRC);
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Invoiced Quantity");
                AssignAmounts(ValueEntry, VarianceInvoicedQty, VarianceExpectedQty, -1);
            end;

            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
                if ValueEntry.FindSet() then
                    repeat
                        if true in [ValueEntry."Valued Quantity" < 0, not GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.", Item."No.", Rec.Site)] then
                            AssignAmounts(ValueEntry, DecreaseInvoicedQty, DecreaseExpectedQty, -1)
                        else
                            AssignAmounts(ValueEntry, IncreaseInvoicedQty, IncreaseExpectedQty, 1);
                    until ValueEntry.Next() = 0;

                IsEmptyLine := IsEmptyLine and ((IncreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DecreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((IncreaseExpectedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DecreaseExpectedQty = 0));

                IsEmptyLine := IsEmptyLine and ((WasteInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((VarianceInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DisposeInvoicedQty = 0));

                IsEmptyLine := IsEmptyLine and ((WasteExpectedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DisposeExpectedQty = 0));
                IsEmptyLine := IsEmptyLine and ((VarianceExpectedQty = 0));

            end;
        end;

        if not IsEmptyLine then
            InsertInvyValuationLine(Item, Item."Global Dimension 1 Code");
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
        GLSetup: Record "General Ledger Setup";

    begin
        InvyValuationLine.Init();
        //Filter infromation
        InvyValuationLine."Inventory Valuation Name" := Rec.Name;
        InvyValuationLine."Entry No." := EntryNo;
        EntryNo += 1;
        InvyValuationLine."Item No." := Item."No.";
        InvyValuationLine.Site := SiteNo;

        //Item master infromation
        InvyValuationLine."Item Description" := Item.Description;
        //InvyValuationLine."Standard Cost"
        //InvyValuationLine."Standard Cost UM"
        //InvyValuationLine.Cap.
        //InvyValuationLine.UOM

        InvyValuationLine."Starting Balance Quantity" := StartingInvoicedQty;
        //InvyValuationLine."Starting Balance Amount"

        InvyValuationLine."Period Order Quantity" := IncreaseInvoicedQty;
        //InvyValuationLine."Period Order Amount"

        //InvyValuationLine."Period Credit Quantity"
        //InvyValuationLine."Period Order Credit Amount"

        InvyValuationLine."Sample Dispose Quantity" := DisposeInvoicedQty;
        //InvyValuationLine."Sample Dispose Amount"

        InvyValuationLine."Consumption Quantity" := DecreaseInvoicedQty;
        //InvyValuationLine."Consumption Amount"

        InvyValuationLine."Waste Scrap Quantity" := WasteInvoicedQty;
        //InvyValuationLine."Waste Scrap Amount"

        //InvyValuationLine."Transfer Amount"
        //InvyValuationLine."Transfer Quantity"

        InvyValuationLine."Variance Quantity" := VarianceInvoicedQty;
        //InvyValuationLine."Variance Amount"

        InvyValuationLine."Ending Balance Quantity" := StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty;
        //InvyValuationLine."Ending Balance Amount"
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
        VarianceInvoicedQty: Decimal;
        DisposeInvoicedQty: Decimal;
        WasteInvoicedQty: Decimal;
        VarianceExpectedQty: Decimal;
        DisposeExpectedQty: Decimal;
        WasteExpectedQty: Decimal;
        IsEmptyLine: Boolean;
        InvyValuationLine: record "RV.Inventory Valuation Line";
        EntryNo: Integer;
        VarianceRC: Code[10];
        WScrapRC: Code[10];
        SamDisposeRC: Code[10];

}