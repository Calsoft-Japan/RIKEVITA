/// <summary>
/// Page Shipping History Summary (ID 50104).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50104 "RV Shipping History Summary"
{
    ApplicationArea = All;
    Caption = 'Shipping History Summary';
    PageType = CardPart;
    SourceTable = "Sales Line";
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(ShippingInfo)
            {
                ShowCaption = false;

                // ── No. of Posted Shipment ─────────────────────────────────
                // DrillDown opens Posted Whse. Shipment Lines filtered by
                // Sales Order No. and Item No.
                field(NoOfPostedShipments; NoOfPostedShipments)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Posted Shipment';
                    DrillDown = true;
                    ToolTip = 'Specifies the total number of posted warehouse shipments for this item on the sales order. Click to view the full list.';

                    trigger OnDrillDown()
                    var
                        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
                        PostedWhseShptLinesPage: Page "Posted Whse. Shipment Lines";
                    begin
                        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
                        PostedWhseShptLine.SetRange("Source No.", Rec."Document No.");
                        PostedWhseShptLine.SetRange("Item No.", Rec."No.");
                        PostedWhseShptLinesPage.SetTableView(PostedWhseShptLine);
                        PostedWhseShptLinesPage.RunModal();
                    end;
                }

                // ── Last Posted Shipment No. ───────────────────────────────
                field(LastPostedShipmentNo; LastPostedShipmentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Last Posted Shipment No.';
                    ToolTip = 'Specifies the document number of the most recent posted warehouse shipment for this item.';
                }

                // ── Quantity ───────────────────────────────────────────────
                // Sourced from the last Posted Whse. Shipment Line.Quantity.
                field(LastQty; LastQty)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity shipped in the most recent posted warehouse shipment for this item.';
                }

                // ── Shipment Method ────────────────────────────────────────
                // Sourced from Posted Whse. Shipment Header."Shipment Method Code"
                // for the header matching the last shipment line.
                field(LastShipmentMethodCode; LastShipmentMethodCode)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Method';
                    ToolTip = 'Specifies the shipment method of the most recent posted warehouse shipment.';
                }

                // ── Location Code ──────────────────────────────────────────
                // Sourced from the last Posted Whse. Shipment Line."Location Code".
                field(LastLocationCode; LastLocationCode)
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the warehouse location of the most recent posted warehouse shipment for this item.';
                }

                // ── Posting Date ───────────────────────────────────────────
                // Sourced from Posted Whse. Shipment Header."Posting Date"
                // for the header matching the last shipment line.
                field(LastPostingDate; LastPostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the most recent posted warehouse shipment for this item.';
                }
            }
        }
    }

    var
        NoOfPostedShipments: Integer;
        LastPostedShipmentNo: Code[20];
        LastQty: Decimal;
        LastShipmentMethodCode: Code[10];
        LastLocationCode: Code[10];
        LastPostingDate: Date;

    trigger OnAfterGetRecord()
    begin
        CalcShippingHistorySummary();
    end;

    // ── Core aggregation procedure ─────────────────────────────────────────
    local procedure CalcShippingHistorySummary()
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
    begin
        ClearSummaryVars();

        // Skip calculation if the Sales Line has no item (e.g. comment lines).
        if Rec."No." = '' then
            exit;

        // Filter all Posted Whse. Shipment Lines for this Sales Order + Item.
        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
        PostedWhseShptLine.SetRange("Source No.", Rec."Document No.");
        PostedWhseShptLine.SetRange("Source Line No.", Rec."Line No.");
        PostedWhseShptLine.SetRange("Item No.", Rec."No.");
        PostedWhseShptLine.FindSet();
        // Total count of posted shipment events for this item-line.
        NoOfPostedShipments := PostedWhseShptLine.Count();

        if NoOfPostedShipments = 0 then
            exit;

        // FindLast() uses the current key (default: "No.", Line No.) and returns
        // the record with the highest "No." — the most recently created shipment.
        // "No." follows a chronological number series, so this is the last shipment.
        if PostedWhseShptLine.FindLast() then begin
            LastPostedShipmentNo := PostedWhseShptLine."No.";
            LastQty := PostedWhseShptLine.Quantity;
            LastLocationCode := PostedWhseShptLine."Location Code";

            // Posting Date and Shipment Method Code are header-level fields.
            // Retrieve the matching header using the line's document number.
            if PostedWhseShptHeader.Get(PostedWhseShptLine."No.") then begin
                LastPostingDate := PostedWhseShptHeader."Posting Date";
                LastShipmentMethodCode := PostedWhseShptHeader."Shipment Method Code";
            end;
        end;
    end;

    local procedure ClearSummaryVars()
    begin
        NoOfPostedShipments := 0;
        LastPostedShipmentNo := '';
        LastQty := 0;
        LastShipmentMethodCode := '';
        LastLocationCode := '';
        LastPostingDate := 0D;
    end;
}
