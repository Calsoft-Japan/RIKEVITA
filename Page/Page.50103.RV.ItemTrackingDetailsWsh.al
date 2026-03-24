/// <summary>
/// Page Item Tracking Details - Warehouse (ID 50103).
/// FDD008 2026/03/09: New. (Liuyang)
/// </summary>
page 50103 "Item Tracking Details - Whse."
{
    ApplicationArea = All;
    PageType = ListPart;
    Caption = 'Item Tracking Details - Warehouse';
    SourceTable = "Reservation Entry";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the lot number of the item that is being handled with the associated document line.';
                }
                field("Qty."; Abs(Rec."Qty. to Handle (Base)"))
                {
                    ToolTip = 'Specifies the quantity of the item that has been reserved in the entry.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        ReservEntry: Record "Reservation Entry";
                        ReservEntriesPage: Page "Reservation Entries";
                    begin
                        ReservEntry.SetRange("Source Type", Rec."Source Type");
                        ReservEntry.SetRange("Source Subtype", Rec."Source Subtype");
                        ReservEntry.SetRange("Source ID", Rec."Source ID");
                        ReservEntry.SetRange("Source Ref. No.", Rec."Source Ref. No.");
                        ReservEntry.SetRange("Item No.", Rec."Item No.");
                        ReservEntry.SetRange("Lot No.", Rec."Lot No.");
                        ReservEntriesPage.SetTableView(ReservEntry);
                        ReservEntriesPage.RunModal();
                    end;
                }
                field("RV_Container No."; Rec."RV_Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.', Comment = '%';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // These filters are permanent for the lifetime of the page instance.
        // SubPageLink filters are layered on top when the parent line selection changes.
        Rec.SetRange(Positive, false);
        Rec.SetRange("Reservation Status", Rec."Reservation Status"::Reservation);
        Rec.SetFilter("Lot No.", '<>%1', '');
    end;


}
