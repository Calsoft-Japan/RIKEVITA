/// <summary>
/// PageExtension RV Posted Whse Shipment (ID 50209) extends "Posted Whse. Shipment"
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
pageextension 50209 "RV PostedWhseShipmentExt" extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("RV_Shipping Type Code"; Rec."RV_Shipping Type Code")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
        }

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
                field("RV_Cosing Date"; Rec."RV_Closing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Country of Origin"; Rec."RV_Country of Origin")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_Ship-to Name"; Rec."RV_Ship-to Name")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field("RV_SAILING ON OR ABOUT"; Rec."RV_SAILING ON OR ABOUT")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field(RV_VIA; Rec."RV_VIA")
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
                field(RV_ETD; Rec."RV_ETD")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }
                field(RV_ETA; Rec."RV_ETA")
                {
                    ApplicationArea = All;
                    Description = 'FDD008';
                }

            }
        }
        addafter(Shipping)//FDD019
        {
            group(Consignee)
            {
                Caption = 'Consignee';
                field("Consignee Name"; Rec."RV_Consignee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Name';
                    Description = 'FDD019';
                    Editable = false;
                }
                field("Consignee Address"; Rec."RV_Consignee Address")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Address';
                    Description = 'FDD019';
                    Editable = false;
                }
                field("Consignee Address 2"; Rec."RV_Consignee Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Address';
                    Description = 'FDD019';
                    Editable = false;
                }
                field("Consignee City"; Rec."RV_Consignee City")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee City';
                    Description = 'FDD019';
                    Editable = false;
                }
                field("Consignee Post Code"; Rec."RV_Consignee Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Post Code';
                    Description = 'FDD019';
                    Editable = false;
                }
                field("Consignee Country/Region"; Rec."RV_Consignee Country/Region")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Country/Region';
                    Description = 'FDD019';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        addbefore("&Print")
        {
            action("PackingInfo")
            {
                Caption = 'Packing Info';
                Image = ViewPage;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PackingInfo: Record "RV Warehouse Packing Info.";
                begin
                    PackingInfo.SetRange("Posted Whse. Shipment No.", Rec."No.");
                    PAGE.Run(PAGE::"Warehouse Packing Info", PackingInfo);
                end;
            }
            action("PackingList")
            {
                Caption = 'Packing List';
                Image = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ReportRec: Record "Posted Whse. Shipment Header";
                begin
                    ReportRec.Reset();
                    ReportRec.SetRange("No.", Rec."No.");
                    Report.Run(50202, TRUE, FALSE, ReportRec);
                end;
            }
        }
        addafter("&Print_Promoted")
        {
            actionref("CreatePackingInfo_Promoted"; "PackingInfo")
            {
            }
            actionref("PackingList_Promoted"; "PackingList")
            {
            }
        }
    }
}
