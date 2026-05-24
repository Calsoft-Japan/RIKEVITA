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
                    begin
                        ItemRelation.Reset();
                        ItemRelation.SetRange("Source Type", Database::"Sales Shipment Line");
                        ItemRelation.SetRange("Order No.", Rec."Sales Order No.");
                        ItemRelation.SetRange("Order Line No.", Rec."Sales Order Line No.");
                        if ItemRelation.FindSet() then begin
                            repeat
                                ItemEntryNoList += Format(ItemRelation."Item Entry No.") + '|';
                            until ItemRelation.Next() = 0;

                            ItemEntryNoList := DelStr(ItemEntryNoList, StrLen(ItemEntryNoList), 1);
                        end;


                        /* ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
                        ItemLedgerEntry.SetRange("Document No.", CurShipNo);
                        ItemLedgerEntry.SetRange("Document Line No.", CurShipLineNo);
                        ItemLedgerEntry.SetRange("Lot No.", CurLotNo);
                        ItemLedgerEntry.SetRange("RV_Container No.", RV_Container_No); */
                        //ItemLedgerEntry.SetRange("Entry No.", CurEntryNo);

                        ItemLedgerEntry.SetFilter("Entry No.", ItemEntryNoList);
                        ItemLedgerEntriesPage.SetTableView(ItemLedgerEntry);
                        ItemLedgerEntriesPage.RunModal();
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

}
