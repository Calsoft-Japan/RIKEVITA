/// <summary>
/// pageextension Warehouse Shipment Ext (ID 50106) extends "Warehouse Shipment" page
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50106 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    layout
    {
        addlast(Shipping)
        {
            group("RIKE")
            {
                ShowCaption = false;

                field("RV_B/L Date"; Rec."RV_B/L Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Cosing Date"; Rec."RV_Cosing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field(RV_VIA; Rec.RV_VIA)
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Final Destination"; Rec."RV_Final Destination")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Feeder Vessel"; Rec."RV_Feeder Vessel")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Mother Vessel"; Rec."RV_Mother Vessel")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field(RV_ETD; Rec.RV_ETD)
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field(RV_ETA; Rec.RV_ETA)
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }

            }
        }

        addlast(factboxes)
        {
            // ── Factbox 1: Customer Details ──────────────────────────────────
            part(CustomerDetailsFB; "Customer Details - Warehouse")
            {
                ApplicationArea = Warehouse;
                Caption = 'Customer Details - Warehouse';
                // Provider shifts FIELD() resolution to Warehouse Shipment Line.
                // The factbox refreshes automatically on every line selection change.
                Provider = WhseShptLines;
                SubPageLink = "Document Type" = CONST(Order),
                              "No." = FIELD("Source No.");
            }

            // ── Factbox 2: Item Tracking Details ─────────────────────────────
            part(ItemTrackingDetailsFB; "Item Tracking Details - Whse.")
            {
                ApplicationArea = Warehouse;
                Caption = 'Item Tracking Details - Warehouse';
                // Same Provider; same FIELD() resolution context.
                // Four-field composite key maps Reservation Entry to the Sales Line
                // identified by the currently selected Warehouse Shipment Line.
                Provider = WhseShptLines;
                SubPageLink = "Source Type" = CONST(37),
                              "Source Subtype" = CONST(1),
                              "Source ID" = FIELD("Source No."),
                              "Source Ref. No." = FIELD("Source Line No.");
            }
        }
    }
}
