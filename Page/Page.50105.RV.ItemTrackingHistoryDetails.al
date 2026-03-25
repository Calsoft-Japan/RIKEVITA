/// <summary>
/// Page Item Tracking History - Sales (ID 50105).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50105 "RV Item Tracking Hst. - Sales"
{
    ApplicationArea = All;
    Caption = 'Item Tracking History Details';
    PageType = ListPart;
    SourceTable = "Sales Shipment Line";
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
                // ── Shipped Lot No. ────────────────────────────────────────
                // Per requirements: "Shipped Lot No." = Item Ledger Entry."Lot No."
                field("Lot No."; CurLotNo)
                {
                    ApplicationArea = All;
                    Caption = 'Shipped Lot No.';
                    ToolTip = 'Specifies the lot number of the shipped inventory.';
                }

                field("RV_Container No."; RV_Container_No)
                {
                    ApplicationArea = All;
                    Caption = 'Container No.';
                    Description = 'FDD008';
                }

                // ── Qty. ───────────────────────────────────────────────────
                // Per requirements: "Qty." = Item Ledger Entry.Quantity
                // Sale ILEs store Quantity as a negative number (inventory out).
                // Abs() normalises it to a positive display value.
                // DrillDown = true activates the OnDrillDown trigger below.
                field(Qty; Abs(Rec.Quantity))
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
                        // Filter page 38 to the single ILE for this row.
                        // "Entry No." is the primary key of table 32 and
                        // uniquely identifies this item ledger entry.
                        ItemLedgerEntry.SetRange("Entry No.", CurEntryNo);
                        ItemLedgerEntriesPage.SetTableView(ItemLedgerEntry);
                        ItemLedgerEntriesPage.RunModal();
                    end;
                }
            }
        }
    }

    var
        CurEntryNo: Integer;
        RV_Container_No: Code[20];
        CurLotNo: Code[50];

    trigger OnAfterGetRecord()
    var
        ItmLedgerEntry: Record "Item Ledger Entry";
    begin
        Clear(CurEntryNo);

        ItmLedgerEntry.SetRange("Document Type", ItmLedgerEntry."Document Type"::"Sales Shipment");
        ItmLedgerEntry.SetRange("Entry Type", ItmLedgerEntry."Entry Type"::Sale);
        ItmLedgerEntry.SetRange("Source Type", ItmLedgerEntry."Source Type"::Customer);
        ItmLedgerEntry.SetRange("Document No.", Rec."Document No."); //Item Ledger Entry links to Posted Sales shipment lines
        ItmLedgerEntry.SetRange("Document Line No.", Rec."Line No.");//Item Ledger Entry links to Posted Sales shipment lines
        ItmLedgerEntry.SetFilter("Lot No.", '<>%1', '');

        if ItmLedgerEntry.FindFirst() then begin
            CurEntryNo := ItmLedgerEntry."Entry No.";
            CurLotNo := ItmLedgerEntry."Lot No.";
            RV_Container_No := ItmLedgerEntry."RV Container No.";
        end;
    end;

    var

}
