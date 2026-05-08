/// <summary>
/// PageExtension RV Warehouse Shipment (ID 50208) extends "Warehouse Shipment"
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
pageextension 50208 "RV WarehouseShipmentExt" extends "Warehouse Shipment"
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
                }
                field("Consignee Address"; Rec."RV_Consignee Address")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Address';
                    Description = 'FDD019';
                }
                field("Consignee Address 2"; Rec."RV_Consignee Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Address 2';
                    Description = 'FDD019';
                }
                field("Consignee City"; Rec."RV_Consignee City")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee City';
                    Description = 'FDD019';
                }
                field("Consignee Post Code"; Rec."RV_Consignee Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Post Code';
                    Description = 'FDD019';
                }
                field("Consignee Country/Region"; Rec."RV_Consignee Country/Region")
                {
                    ApplicationArea = All;
                    Caption = 'Consignee Country/Region';
                    Description = 'FDD019';
                }
            }
        }
    }
    actions
    {
        addbefore("Delete Qty. to Ship")
        {
            action("CreatePackingInfo")
            {
                Caption = 'Create Packing Info';
                Image = ViewPage;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PackingInfo: Record "RV Warehouse Packing Info.";
                begin
                    if Confirm('Do you want to create or updating the packing information for the warehouse order?', false) then begin
                        PackingInfo.SetRange("Warehouse Shipment No.", Rec."No.");
                        PAGE.Run(PAGE::"Warehouse Packing Info", PackingInfo);
                    end;
                end;
            }
            action("PrePackingList")
            {
                Caption = 'Pre Packing List';
                Image = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ReportRec: Record "Warehouse Shipment Header";
                begin
                    ReportRec.Reset();
                    ReportRec.SetRange("No.", Rec."No.");
                    Report.Run(50201, TRUE, FALSE, ReportRec);
                end;
            }
        }
        addafter("Category_Qty. to Ship")
        {
            actionref("CreatePackingInfo_Promoted"; "CreatePackingInfo")
            {
            }
            actionref("PrePackingList_Promoted"; "PrePackingList")
            {
            }
        }
    }

}
