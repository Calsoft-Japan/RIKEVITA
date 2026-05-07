/// <summary>
/// PageExtension RV Posted Whse Shipment (ID 50209) extends "Posted Whse. Shipment"
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
pageextension 50209 "RV PostedWhseShipmentExt" extends "Posted Whse. Shipment"
{
    layout
    {
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
        }
        addafter("&Print_Promoted")
        {
            actionref("CreatePackingInfo_Promoted"; "PackingInfo")
            {
            }
        }
    }
}
