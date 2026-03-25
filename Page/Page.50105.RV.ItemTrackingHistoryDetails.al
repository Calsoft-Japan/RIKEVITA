/// <summary>
/// Page Item Tracking History - Sales (ID 50105).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50105 "RV Item Tracking Hst. - Sales"
{
    ApplicationArea = All;
    Caption = 'Item Tracking History Details';
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";
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
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Sales;
                    Caption = 'Shipped Lot No.';
                    ToolTip = 'Specifies the lot number of the shipped inventory.';
                }

                field("RV_Container No."; Rec."RV Container No.")
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
                    ApplicationArea = Sales;
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
                        ItemLedgerEntry.SetRange("Entry No.", Rec."Entry No.");
                        ItemLedgerEntriesPage.SetTableView(ItemLedgerEntry);
                        ItemLedgerEntriesPage.RunModal();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Permanent filters applied for the lifetime of this page instance.
        // These combine with the SubPageLink filters ("Order No." and "Item No.")
        // that the parent page 42 extension supplies via Provider = SalesLines.
        Rec.SetRange("Document Type", Rec."Document Type"::"Service Shipment");
        Rec.SetRange("Entry Type", Rec."Entry Type"::Sale);
        //Rec.SetRange("Source Type", Rec."Source Type"::Customer);
        Rec.SetFilter("Lot No.", '<>%1', '');
    end;
}
