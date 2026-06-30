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
                begin
                    PackingInfo.Reset();
                    PackingInfo.SetRange("Warehouse Shipment No.", Rec."No.");
                    if not PackingInfo.FindFirst() then begin
                        if Confirm('Do you want to create or updating the packing information for the warehouse order?', false) then begin
                            CreatePackingInfo();
                            PAGE.Run(PAGE::"Warehouse Packing Info", PackingInfo);
                        end;
                    end else begin
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
    var
        TempSourceNo: Code[20];
        TempSourceLineNo: Integer;
        TempItemNo: Code[20];
        TempQtyToShip: Decimal;
        TempQtyPerUOM: Decimal;
        TempUOM: Code[10];
        PackingInfo: Record "RV Warehouse Packing Info.";

    local procedure CreatePackingInfo()
    var
        //PackingInfo: Record "RV Warehouse Packing Info.";
        WhseShpgHeader: Record "Warehouse Shipment Header";
        WshpLine: Record "Warehouse Shipment Line";
        WarehousePackingInfo: Page "Warehouse Packing Info";

        PackingInfo: Record "RV Warehouse Packing Info.";
    begin
        TempSourceNo := '';
        TempSourceLineNo := 0;
        TempItemNo := '';
        TempUOM := '';
        TempQtyPerUOM := 0;
        TempQtyToShip := 0;
        if not WhseShpgHeader.Get(Rec."No.") then
            exit;

        WshpLine.Reset();
        WshpLine.SetRange("No.", WhseShpgHeader."No.");
        WshpLine.SetCurrentKey("Source No.", "Source Line No.");
        if WshpLine.FindSet() then begin
            repeat
                if (WshpLine."Source No." <> TempSourceNo) or (WshpLine."Source Line No." <> TempSourceLineNo) then begin

                    if TempSourceNo <> '' then begin
                        InsertPackingInfo(Rec, WshpLine);
                    end;
                    TempSourceNo := WshpLine."Source No.";
                    TempSourceLineNo := WshpLine."Source Line No.";
                    TempItemNo := WshpLine."Item No.";
                    TempUOM := WshpLine."Unit of Measure Code";
                    TempQtyPerUOM := WshpLine."Qty. per Unit of Measure";
                    TempQtyToShip := 0;
                end;

                TempQtyToShip += WshpLine."Qty. to Ship";

            until WshpLine.Next() = 0;
            if TempSourceNo <> '' then begin
                InsertPackingInfo(Rec, WshpLine);
            end;

        end;
    end;

    local procedure InsertPackingInfo(WhseShpgHeader: Record "Warehouse Shipment Header"; WshpLine: Record "Warehouse Shipment Line")
    var
        PackingInfo: Record "RV Warehouse Packing Info.";
        ReservationEntry: Record "Reservation Entry";
        LineNo: Integer;
    begin
        LineNo := 10000;
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source ID", TempSourceNo);
        ReservationEntry.SetRange("Source Ref. No.", TempSourceLineNo);
        ReservationEntry.SetRange("Item No.", TempItemNo);
        //ReservationEntry.SetRange("Location Code", WhseShpgHeader."Location Code");
        if ReservationEntry.FindSet() then begin
            repeat
                PackingInfo.Init();
                PackingInfo."Warehouse Shipment No." := WhseShpgHeader."No.";
                PackingInfo."Sales Order No." := TempSourceNo;
                PackingInfo."SO Line No." := TempSourceLineNo;
                PackingInfo."Item No." := TempItemNo;
                PackingInfo."Lot No." := ReservationEntry."Lot No.";
                PackingInfo."Container No" := ReservationEntry."RV_Container No.";
                PackingInfo.Quantity := Abs(ReservationEntry."Quantity (Base)");
                PackingInfo."Lot Quantity" := Abs(ReservationEntry."Quantity (Base)");
                PackingInfo.Validate("No. of Packages", TempQtyToShip * TempQtyPerUOM);
                PackingInfo."Contents Per Package" := 1 / TempQtyPerUOM;
                PackingInfo."Contents UOM" := TempUOM;
                PackingInfo."Net Weight" := TempQtyToShip;
                PackingInfo."Gross Weight UOM" := TempUOM;
                PackingInfo."Line No." := LineNo;
                PackingInfo.Insert();
                LineNo += 10000;
            until ReservationEntry.Next() = 0;
        end;
    end;
}


