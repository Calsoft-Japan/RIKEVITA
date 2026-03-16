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
    }
}
