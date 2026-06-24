/// <summary>
/// Page Warehouse Packing Info (ID 50205).
/// FDD019 2026/04/24: New. (Bobby.ji)
/// </summary>
page 50205 "Warehouse Packing Info"
{
    ApplicationArea = All;
    Caption = 'Warehouse Packing Info';
    PageType = ListPlus;
    //UsageCategory = Lists;
    SourceTable = "RV Warehouse Packing Info.";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    Caption = 'Sales Order No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SO Line No."; Rec."SO Line No.")
                {
                    Caption = 'SO Line No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Case No."; Rec."Case No.")
                {
                    Caption = 'Case No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("No. of Packages"; Rec."No. of Packages")
                {
                    Caption = 'No. of Packages';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Contents Per Package"; Rec."Contents Per Package")
                {
                    Caption = 'Contents Per Package';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Contents UOM"; Rec."Contents UOM")
                {
                    Caption = 'Contents UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    Caption = 'Net Weight';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    Caption = 'Gross Weight';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Gross Weight UOM"; Rec."Gross Weight UOM")
                {
                    Caption = 'Gross Weight UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field(Measurement; Rec.Measurement)
                {
                    Caption = 'Measurement';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Measurement UOM"; Rec."Measurement UOM")
                {
                    Caption = 'Measurement UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
            }

        }

    }

    actions
    {
        area(Processing)
        {
            action(ResetPackingInfo)
            {
                Caption = 'Reset';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    WhseShpgHeader: Record "Warehouse Shipment Header";
                    WshpLine: Record "Warehouse Shipment Line";
                    PackingInfo: Record "RV Warehouse Packing Info.";
                    QtytoShip: Decimal;
                begin
                    TempSourceNo := '';
                    TempSourceLineNo := 0;
                    TempItemNo := '';
                    TempUOM := '';
                    TempQtyPerUOM := 0;
                    TempQtyToShip := 0;
                    if not WhseShpgHeader.Get(Rec."Warehouse Shipment No.") then
                        exit;
                    PackingInfo.Reset();
                    PackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                    PackingInfo.DeleteAll();

                    WshpLine.Reset();
                    WshpLine.SetRange("No.", WhseShpgHeader."No.");
                    WshpLine.SetCurrentKey("Source No.", "Source Line No.");
                    if WshpLine.FindSet() then begin
                        repeat
                            if (WshpLine."Source No." <> TempSourceNo) or (WshpLine."Source Line No." <> TempSourceLineNo) then begin

                                if TempSourceNo <> '' then begin
                                    InsertPackingInfo();
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
                        if TempSourceNo <> '' then
                            InsertPackingInfo();
                    end;
                end;
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

    procedure InsertPackingInfo()
    var
        PackingInfo: Record "RV Warehouse Packing Info.";
    begin
        PackingInfo.Init();
        PackingInfo."Warehouse Shipment No." := Rec."Warehouse Shipment No.";
        PackingInfo."Sales Order No." := TempSourceNo;
        PackingInfo."SO Line No." := TempSourceLineNo;
        PackingInfo."Item No." := TempItemNo;
        PackingInfo.Validate("No. of Packages", TempQtyToShip * TempQtyPerUOM);
        PackingInfo."Contents Per Package" := 1 / TempQtyPerUOM;
        PackingInfo."Contents UOM" := TempUOM;
        PackingInfo."Net Weight" := TempQtyToShip;
        PackingInfo."Gross Weight UOM" := TempUOM;
        PackingInfo.Insert();
    end;
}

