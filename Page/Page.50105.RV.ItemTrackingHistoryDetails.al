/// <summary>
/// Page Item Tracking History - Sales (ID 50105).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50105 "RV Item Tracking Hst. - Sales"
{
    ApplicationArea = All;
    Caption = 'Item Tracking History Details';
    PageType = ListPart;
    SourceTable = "Item Entry Relation";//"RV Item Tracking History Dtl."";
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

                field(Qty; Abs(CurQty))
                {
                    ApplicationArea = All;
                    Caption = 'Qty.';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    ToolTip = 'Specifies the shipped quantity for this lot number. Click to view the Item Ledger Entry.';

                    trigger OnDrillDown()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemLedgerEntriesPage: Page "Item Ledger Entries"; // Page 38
                    begin
                        /* ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
                        ItemLedgerEntry.SetRange("Document No.", CurShipNo);
                        ItemLedgerEntry.SetRange("Document Line No.", CurShipLineNo);
                        ItemLedgerEntry.SetRange("Lot No.", CurLotNo);
                        ItemLedgerEntry.SetRange("RV_Container No.", RV_Container_No); */
                        ItemLedgerEntry.SetRange("Entry No.", CurEntryNo);
                        ItemLedgerEntriesPage.SetTableView(ItemLedgerEntry);
                        ItemLedgerEntriesPage.RunModal();
                    end;
                }
                field("RV_Container No."; RV_Container_No)
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
        Clear(CurEntryNo);
        Clear(RV_Container_No);
        Clear(CurLotNo);
        Clear(CurQty);

        CurShipNo := Rec."Source ID";//Posted Sales Shipment #; 
        CurShipLineNo := Rec."Source Ref. No.";//Posted Sales Shipmen Line #; 
        CurEntryNo := Rec."Item Entry No.";

        ItmLedgerEntry.SetRange("Entry No.", CurEntryNo);
        if ItmLedgerEntry.FindFirst() then
            CurQty := Abs(ItmLedgerEntry.Quantity / ItmLedgerEntry."Qty. per Unit of Measure");

        /* ItmLedgerEntry.SetRange("DocumentType", ItmLedgerEntry."DocumentType"::"Sales Shipment");
        ItmLedgerEntry.SetRange("EntryType", ItmLedgerEntry."EntryType"::Sale);
        ItmLedgerEntry.SetRange("SourceType", ItmLedgerEntry."SourceType"::Customer);
        ItmLedgerEntry.SetRange("DocumentNo", CurShipNo); //Item Ledger Entry links to Posted sales shipment lines
        ItmLedgerEntry.SetRange("DocumentLineNo", CurShipLineNo);//Item Ledger Entry links to Posted salse shipment lines
        ItmLedgerEntry.SetFilter("LotNo", '<>%1', '');
        ItmLedgerEntry.Open();
        //if ItmLedgerEntry.FindFirst() then begin
        while ItmLedgerEntry.Read() do begin
            //CurEntryNo := ItmLedgerEntry."EntryNo";
            CurLotNo := ItmLedgerEntry."LotNo";
            RV_Container_No := ItmLedgerEntry."RV_Container_No_";
            CurQty := ItmLedgerEntry.Quantity;
        end; */
    end;


}
