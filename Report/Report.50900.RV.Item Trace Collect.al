/// <summary>
/// Report RV Item Trace Collect (ID 50900)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
report 50900 "RV Item Trace Collect"
{
    ApplicationArea = All;
    Caption = 'Item Trace Collect';
    ProcessingOnly = true;


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;
                    }
                    field(ItemNoFilter; ItemNoFilter)
                    {
                        Caption = 'Item No.';
                        ApplicationArea = All;
                    }

                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = Action::OK then begin
                if (StartDate = 0D) and (EndDate = 0D) then begin
                    Error(DateBlankErr);
                end;
                if StartDate > EndDate then begin
                    Error(StartDateAfterEndDateErr);
                end;
            end;
        end;
    }

    trigger OnInitReport()
    begin
        RVSetup.Get();
        StartDate := RVSetup."Start Date (Item Trace)";
        EndDate := RVSetup."End Date (Item Trace)";
        ItemNoFilter := RVSetup."Item No. (Item Trace)";
    end;

    trigger OnPreReport()
    begin

        ItemTraceHistory.Reset();
        if ItemTraceHistory.FindLast() then begin
            HistoryEntryNo := ItemTraceHistory."Entry No." + 1;
        end else begin
            HistoryEntryNo := 1;
        end;

    end;

    trigger OnPostReport()
    begin

        //Create Item Trace History data.
        ItemTraceHistory.Init();
        ItemTraceHistory."Entry No." := HistoryEntryNo;
        ItemTraceHistory."Start Date" := StartDate;
        ItemTraceHistory."End Date" := EndDate;
        ItemTraceHistory."Collected On" := CurrentDateTime;
        ItemTraceHistory.Insert();

        //Create Item Balance by Vendor data, with Openning Balance.
        Clear(QueItemBal);
        QueItemBal.SetDate(0D, StartDate - 1);
        QueItemBal.SetItemNoFilter(ItemNoFilter);
        if QueItemBal.Open() then begin
            while QueItemBal.Read() do begin

                if (QueItemBal.Quantity <> 0)
                    or (QueItemBal.RV_Quantity__KG_ <> 0)
                    or (QueItemBal.Cost_Amount__Actual_ <> 0) then begin

                    ItemBalance.Init();
                    ItemBalance."History Entry No." := HistoryEntryNo;
                    ItemBalance."Vendor No." := QueItemBal.RV_Vendor_No__No_;
                    ItemBalance."Item No." := QueItemBal.Item_No_;
                    ItemBalance."Opening Balance (BUOM)" := QueItemBal.Quantity;
                    ItemBalance."Opening Balance (KG)" := QueItemBal.RV_Quantity__KG_;
                    ItemBalance."Opening Balance (RM)" := QueItemBal.Cost_Amount__Actual_;
                    ItemBalance.Insert();

                end;
            end;
            QueItemBal.Close();
        end;

        //Create Item Trace Detail: Purchase Entry Type.
        //The other types refer to Lot No. of Purchase Type data, that's why Create Purchase data first.
        ILE.Reset();
        ILE.SetRange("Entry Type", Enum::"Item Ledger Entry Type"::Purchase);
        ILE.SetRange("Posting Date", StartDate, EndDate);
        ILE.SetFilter("Item No.", ItemNoFilter);
        if ILE.FindSet() then
            repeat
                CreateItemTraceDetail();
            until ILE.Next() = 0;

        //Create Item Trace Detail: Other Entry Types.
        ILE.Reset();
        ILE.SetFilter("Entry Type", '%1|%2|%3|%4',
                                    Enum::"Item Ledger Entry Type"::Consumption,
                                    Enum::"Item Ledger Entry Type"::Sale,
                                    Enum::"Item Ledger Entry Type"::"Positive Adjmt.",
                                    Enum::"Item Ledger Entry Type"::"Negative Adjmt.");
        ILE.SetRange("Posting Date", StartDate, EndDate);
        ILE.SetFilter("Item No.", ItemNoFilter);
        if ILE.FindSet() then
            repeat
                CreateItemTraceDetail();
            until ILE.Next() = 0;

        //Calculate Closing Balance.
        Clear(QueItemDetail);
        QueItemDetail.SetHistEntryNo(HistoryEntryNo);
        if QueItemDetail.Open() then begin
            while QueItemDetail.Read() do begin
                if ItemBalance.Get(HistoryEntryNo, QueItemDetail.Vendor_No_, QueItemDetail.Item_No_) then begin
                    ItemBalance."Closing Balance (BUOM)" := ItemBalance."Opening Balance (BUOM)" + QueItemDetail.Quantity__BUOM_;
                    ItemBalance."Closing Balance (KG)" := ItemBalance."Opening Balance (KG)" + QueItemDetail.Quantity__KG_;
                    ItemBalance."Closing Balance (RM)" := ItemBalance."Opening Balance (RM)" + QueItemDetail.Cost_Amount__RM_;
                    ItemBalance.Modify();
                end else if (QueItemDetail.Quantity__BUOM_ <> 0)
                    or (QueItemDetail.Quantity__KG_ <> 0)
                    or (QueItemDetail.Cost_Amount__RM_ <> 0) then begin
                    //New transactions only between Start Date and End Date.
                    //Opening Balance should be 0.
                    ItemBalance.Init();
                    ItemBalance."History Entry No." := HistoryEntryNo;
                    ItemBalance."Vendor No." := QueItemDetail.Vendor_No_;
                    ItemBalance."Item No." := QueItemDetail.Item_No_;
                    ItemBalance."Closing Balance (BUOM)" := QueItemDetail.Quantity__BUOM_;
                    ItemBalance."Closing Balance (KG)" := QueItemDetail.Quantity__KG_;
                    ItemBalance."Closing Balance (RM)" := QueItemDetail.Cost_Amount__RM_;
                    ItemBalance.Insert();

                end;
            end;
            QueItemDetail.Close();
        end;

    end;

    local procedure CreateItemTraceDetail()
    var
    begin
        DetailEntryNo += 1;
        ItemDetail.Init();
        ItemDetail."History Entry No." := HistoryEntryNo;
        ItemDetail."Entry No." := DetailEntryNo;
        ItemDetail."Item Ledger Entry No." := ILE."Entry No.";
        ItemDetail.Insert();

        case ILE."Entry Type" of
            Enum::"Item Ledger Entry Type"::Purchase:
                begin
                    ItemDetail."Vendor No." := ILE."RV_Vendor No.";
                    if Vendor.Get(ItemDetail."Vendor No.") then begin
                        ItemDetail."Gen. Bus. Posting Group " := Vendor."Gen. Bus. Posting Group";
                    end;
                    ItemDetail."Item No." := ILE."Item No.";
                    ItemDetail."Posting Date" := ILE."Posting Date";
                    ItemDetail."Entry Type" := ILE."Entry Type";
                    ItemDetail."Document Type" := ILE."Document Type";
                    ItemDetail."Document No." := ILE."Document No.";

                    VL.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                    VL.SetRange("Entry Type", Enum::"Cost Entry Type"::"Direct Cost");
                    if VL.FindFirst() then begin
                        If PurchInvHeader.Get(VL."Document No.") then begin
                            ItemDetail."Vendor Invoice No." := PurchInvHeader."Vendor Invoice No.";
                        end;
                    end;

                    if PurchRcptHeader.Get(ILE."Document No.") then begin
                        ItemDetail."Vendor Shipment No." := PurchRcptHeader."Vendor Shipment No.";
                    end;

                    ItemDetail."Lot No." := ILE."Lot No.";

                    ILE.CalcFields("RV_Base Unit of Measure Code", "Cost Amount (Actual)");
                    ItemDetail."Base Unit of Measure Code" := ILE."RV_Base Unit of Measure Code";
                    ItemDetail."Quantity (BUOM)" := ILE.Quantity;
                    ItemDetail."Quantity (KG)" := ILE."RV_Quantity (Supp. UOM)";
                    ItemDetail."Cost Amount (RM)" := ILE."Cost Amount (Actual)";

                end;

            Enum::"Item Ledger Entry Type"::Consumption:
                begin
                    /*
                    ItemDetailFinder.Reset();
                    ItemDetailFinder.SetRange("Entry Type", Enum::"Item Ledger Entry Type"::Purchase);
                    ItemDetailFinder.SetRange("Item No.", ILE."Item No.");
                    ItemDetailFinder.SetRange("Lot No.", ILE."Lot No.");
                    if ItemDetailFinder.FindFirst() then begin
                        ItemDetail."Vendor No." := ItemDetailFinder."Vendor No.";
                    end;
                    */
                    ItemDetail."Vendor No." := ILE."RV_Vendor No.";

                    if Vendor.Get(ItemDetail."Vendor No.") then begin
                        ItemDetail."Gen. Bus. Posting Group " := Vendor."Gen. Bus. Posting Group";
                    end;

                    ItemDetail."Item No." := ILE."Item No.";
                    ItemDetail."Posting Date" := ILE."Posting Date";
                    ItemDetail."Entry Type" := ILE."Entry Type";
                    ItemDetail."Document Type" := ILE."Document Type";
                    ItemDetail."Document No." := ILE."Document No.";

                    ItemDetail."Lot No." := ILE."Lot No.";

                    ILE.CalcFields("RV_Base Unit of Measure Code", "Cost Amount (Actual)");
                    ItemDetail."Base Unit of Measure Code" := ILE."RV_Base Unit of Measure Code";
                    ItemDetail."Quantity (BUOM)" := ILE.Quantity;
                    ItemDetail."Quantity (KG)" := ILE."RV_Quantity (Supp. UOM)";
                    ItemDetail."Cost Amount (RM)" := ILE."Cost Amount (Actual)";

                    ILEFinder.Reset();
                    ILEFinder.SetRange("Entry Type", Enum::"Item Ledger Entry Type"::Output);
                    ILEFinder.SetRange("Document No.", ItemDetail."Document No.");
                    if ILEFinder.FindFirst() then begin
                        ItemDetail."Item No. (FP)" := ILEFinder."Item No.";
                    end;
                    if Item.Get(ItemDetail."Item No. (FP)") then begin
                        ItemDetail."VAT. Prod. Posting Group" := Item."VAT Prod. Posting Group";
                    end;

                end;

            Enum::"Item Ledger Entry Type"::Sale:
                begin
                    /*
                    ItemDetailFinder.Reset();
                    ItemDetailFinder.SetRange("Entry Type", Enum::"Item Ledger Entry Type"::Purchase);
                    ItemDetailFinder.SetRange("Item No.", ILE."Item No.");
                    ItemDetailFinder.SetRange("Lot No.", ILE."Lot No.");
                    if ItemDetailFinder.FindFirst() then begin
                        ItemDetail."Vendor No." := ItemDetailFinder."Vendor No.";
                    end;
                    */
                    ItemDetail."Vendor No." := ILE."RV_Vendor No.";

                    if Vendor.Get(ItemDetail."Vendor No.") then begin
                        ItemDetail."Gen. Bus. Posting Group " := Vendor."Gen. Bus. Posting Group";
                    end;

                    ItemDetail."Item No." := ILE."Item No.";
                    ItemDetail."Posting Date" := ILE."Posting Date";
                    ItemDetail."Entry Type" := ILE."Entry Type";
                    ItemDetail."Document Type" := ILE."Document Type";
                    ItemDetail."Document No." := ILE."Document No.";

                    ItemDetail."Lot No." := ILE."Lot No.";

                    ILE.CalcFields("RV_Base Unit of Measure Code", "Cost Amount (Actual)");
                    ItemDetail."Base Unit of Measure Code" := ILE."RV_Base Unit of Measure Code";
                    ItemDetail."Quantity (BUOM)" := ILE.Quantity;
                    ItemDetail."Quantity (KG)" := ILE."RV_Quantity (Supp. UOM)";
                    ItemDetail."Cost Amount (RM)" := ILE."Cost Amount (Actual)";

                end;

            Enum::"Item Ledger Entry Type"::"Positive Adjmt.",
            Enum::"Item Ledger Entry Type"::"Negative Adjmt.":
                begin
                    /*
                    ItemDetailFinder.Reset();
                    ItemDetailFinder.SetRange("Entry Type", Enum::"Item Ledger Entry Type"::Purchase);
                    ItemDetailFinder.SetRange("Item No.", ILE."Item No.");
                    ItemDetailFinder.SetRange("Lot No.", ILE."Lot No.");
                    if ItemDetailFinder.FindFirst() then begin
                        ItemDetail."Vendor No." := ItemDetailFinder."Vendor No.";
                    end;
                    */
                    ItemDetail."Vendor No." := ILE."RV_Vendor No.";

                    if Vendor.Get(ItemDetail."Vendor No.") then begin
                        ItemDetail."Gen. Bus. Posting Group " := Vendor."Gen. Bus. Posting Group";
                    end;

                    ItemDetail."Item No." := ILE."Item No.";
                    ItemDetail."Posting Date" := ILE."Posting Date";
                    ItemDetail."Entry Type" := ILE."Entry Type";
                    ItemDetail."Document Type" := ILE."Document Type";
                    ItemDetail."Document No." := ILE."Document No.";

                    ItemDetail."Lot No." := ILE."Lot No.";

                    ILE.CalcFields("RV_Base Unit of Measure Code", "Cost Amount (Actual)");
                    ItemDetail."Base Unit of Measure Code" := ILE."RV_Base Unit of Measure Code";
                    ItemDetail."Quantity (BUOM)" := ILE.Quantity;
                    ItemDetail."Quantity (KG)" := ILE."RV_Quantity (Supp. UOM)";
                    ItemDetail."Cost Amount (RM)" := ILE."Cost Amount (Actual)";

                end;

        end;

        ItemDetail.Modify();

    end;

    var
        DateBlankErr: label 'Start Date and End Date cannot be blank.';
        StartDateAfterEndDateErr: label 'Start Date cannot be later than End Date.';

        RVSetup: Record "RV RIKEVITA Setup";
        ItemTraceHistory: Record "RV Item Trace History";
        ItemBalance: Record "RV Item Balance by Vendor";
        ItemDetail: Record "RV Item Trace Detail";
        ItemDetailFinder: Record "RV Item Trace Detail";
        ILE: Record "Item Ledger Entry";
        ILEFinder: Record "Item Ledger Entry";
        Vendor: Record Vendor;
        Item: Record Item;
        VL: Record "Value Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        QueItemBal: Query "RV Item Balance by Vendor";
        QueItemDetail: Query "RV Item Detail by Vendor";
        StartDate: Date;
        EndDate: Date;
        ItemNoFilter: Text[250];
        HistoryEntryNo: Integer;
        DetailEntryNo: Integer;

}
