/// <summary>
/// Page Item Tracking History - Sales (ID 50105).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50105 "RV Item Tracking Hst. - Sales"
{
    ApplicationArea = All;
    Caption = 'Item Tracking History Details';
    PageType = ListPart;
    SourceTable = "RV Item Tracking History Dtl.";//"Item Entry Relation";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Shipped Lot No.';
                    ToolTip = 'Specifies the lot number of the shipped inventory.';
                }

                field(Qty; Abs(Rec.Qty))// Abs(CurQty))
                {
                    ApplicationArea = All;
                    Caption = 'Qty.';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    ToolTip = 'Specifies the shipped quantity for this lot number. Click to view the Item Ledger Entry.';

                    trigger OnDrillDown()
                    var
                        ItemRelation: Record "Item Entry Relation";
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemLedgerEntriesPage: Page "Item Ledger Entries"; // Page 38
                        ItemEntryNoList: Text;
                        T_WhsPackInfo: Record "RV Warehouse Packing Info.";
                        P_WhsPackInfo: Page "Warehouse Packing Info";
                    begin
                        /* ItemRelation.Reset();
                        ItemRelation.SetRange("Source Type", Database::"Sales Shipment Line");
                        //ItemRelation.SetRange("Order No.", Rec."Sales Order No.");
                        //ItemRelation.SetRange("Order Line No.", Rec."Sales Order Line No.");
                        if SONoFilter <> '' then
                            ItemRelation.SetFilter("Order No.", SONoFilter);


                        if ItemRelation.FindSet() then begin
                            repeat
                                ItemEntryNoList += Format(ItemRelation."Item Entry No.") + '|';
                            until ItemRelation.Next() = 0;

                            ItemEntryNoList := DelStr(ItemEntryNoList, StrLen(ItemEntryNoList), 1);
                        end; */


                        /* ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
                        ItemLedgerEntry.SetRange("Document No.", CurShipNo);
                        ItemLedgerEntry.SetRange("Document Line No.", CurShipLineNo);
                        ItemLedgerEntry.SetRange("Lot No.", CurLotNo);
                        ItemLedgerEntry.SetRange("RV_Container No.", RV_Container_No); */
                        //ItemLedgerEntry.SetRange("Entry No.", CurEntryNo);

                        //ItemLedgerEntry.SetFilter("Entry No.", ItemEntryNoList);
                        /* ItemLedgerEntry.SetRange("External Document No.", Rec."External Document No.");
                        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
                        ItemLedgerEntry.SetRange("Source No.", Rec."Sell-to Customer No.");
                        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                        ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
                        ItemLedgerEntry.SetRange("RV_Container No.", Rec."Container No.");
                        ItemLedgerEntriesPage.SetTableView(ItemLedgerEntry);
                        ItemLedgerEntriesPage.RunModal(); */
                        T_WhsPackInfo.Reset();
                        T_WhsPackInfo.SetRange("External Document No.", Rec."External Document No.");
                        T_WhsPackInfo.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        T_WhsPackInfo.SetRange("Item No.", Rec."Item No.");
                        T_WhsPackInfo.SetRange("Lot No.", Rec."Lot No.");
                        T_WhsPackInfo.SetRange("Container No", Rec."Container No.");
                        P_WhsPackInfo.SetTableView(T_WhsPackInfo);
                        P_WhsPackInfo.RunModal();
                    end;
                }
                field("RV_Container No."; Rec."Container No.")//RV_Container_No)
                {
                    ApplicationArea = All;
                    Caption = 'Container No.';
                    Description = 'FDD008';
                }
            }
        }
    }


    var
        CurEntryNo: Integer;
        RV_Container_No: Code[20];
        CurLotNo: Code[50];
        CurQty: Decimal;

        CurShipNo: Text;
        CurShipLineNo: Integer;
        ILE: Record "Item Ledger Entry";
    //SONoFilter: Text;

    trigger OnAfterGetRecord()
    var
        ItmLedgerEntry: Record "Item Ledger Entry";
    //ItmLedgerEntry: Query "RV ItemLedgerHist";
    begin
        /* Clear(CurEntryNo);
        Clear(RV_Container_No);
        Clear(CurLotNo);
        Clear(CurQty);

        CurShipNo := Rec."Source ID";//Posted Sales Shipment #; 
        CurShipLineNo := Rec."Source Ref. No.";//Posted Sales Shipmen Line #; 
        CurEntryNo := Rec."Item Entry No.";

        ItmLedgerEntry.SetRange("Entry No.", CurEntryNo);
        if ItmLedgerEntry.FindFirst() then
            CurQty := Abs(ItmLedgerEntry.Quantity / ItmLedgerEntry."Qty. per Unit of Measure");

        if ItmLedgerEntry.Get(CurEntryNo) then begin
            RV_Container_No := ItmLedgerEntry."RV_Container No.";
        end; */
    end;


    procedure setGlobalSOFiler()
    var
        SOHeader: Record "Sales Header";
        SOLines: Record "Sales Line";
        //QrySOShptDtl: Query "RV Query SO Detail";

        DistSONoList: List of [Text];
        ExtDocNo: Text;
    begin
        /* Clear(SONoFilter);
        Clear(DistSONoList);

        QrySOShptDtl.SetRange(ExternalDocumentNo, Rec."External Document No.");
        QrySOShptDtl.SetRange(SelltoCustomerNo, Rec."Sell-to Customer No.");
        QrySOShptDtl.SetRange(Item_No_, Rec."Item No.");
        QrySOShptDtl.Open();
        while QrySOShptDtl.Read() do begin
            if QrySOShptDtl.SO_No_ <> '' then begin
                if not DistSONoList.Contains(QrySOShptDtl.SO_No_) then begin
                    DistSONoList.Add(QrySOShptDtl.SO_No_);
                    SONoFilter := SONoFilter + QrySOShptDtl.SO_No_ + '|';
                end;
            end;
        end;
        if SONoFilter <> '' then
            SONoFilter := SONoFilter.Remove(StrLen(SONoFilter)); */

        /* if SOHeader.Get("Sales Document Type"::Order, Rec."Sales Order No.") then begin
            ExtDocNo := SOHeader."External Document No.";

            SOLines.Reset();
            SOLines.SetRange("Document Type", SOHeader."Document Type");
            SOLines.SetRange("Document No.", SOHeader."No.");
            SOLines.SetRange("Line No.", Rec."Sales Order Line No.");
            if SOLines.FindSet() then begin
                //repeat
                QrySOShptDtl.SetRange(ExternalDocumentNo, ExtDocNo);
                QrySOShptDtl.SetRange(SelltoCustomerNo, SOLines."Sell-to Customer No.");
                QrySOShptDtl.SetRange(Item_No_, SOLines."No.");
                QrySOShptDtl.Open();
                while QrySOShptDtl.Read() do begin
                    if QrySOShptDtl.SO_No_ <> '' then begin
                        if not DistSONoList.Contains(QrySOShptDtl.SO_No_) then begin
                            DistSONoList.Add(QrySOShptDtl.SO_No_);
                            SONoFilter := SONoFilter + QrySOShptDtl.SO_No_ + '|';
                        end;
                    end;
                end;
                QrySOShptDtl.Close();
                //until SOLines.Next() = 0;

                if SONoFilter <> '' then
                    SONoFilter := SONoFilter.Remove(StrLen(SONoFilter));
            end;
        end; */
    end;

}
