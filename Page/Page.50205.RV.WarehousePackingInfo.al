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
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Description = 'FDD005';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Container No"; Rec."Container No")
                {
                    Caption = 'Container No';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Quantity (KG)"; Rec."Quantity (KG)")
                {
                    Caption = 'Quantity (KG)';
                    Description = 'FDD005';
                    ApplicationArea = All;
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
                field("Lot Quantity"; Rec."Lot Quantity")
                {
                    Caption = 'Lot Quantity';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    Caption = 'Comment';
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
                    WarehouseShipment: Page "Warehouse Shipment";
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
                                    InsertPackingInfo(WhseShpgHeader, WshpLine);
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
                            InsertPackingInfo(WhseShpgHeader, WshpLine);
                    end;
                end;
            }
            action(SplitLineInfo)
            {
                Caption = 'Split Line';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PackingInfo: Record "RV Warehouse Packing Info.";
                    TempPackingInfo: Record "RV Warehouse Packing Info.";
                    InsertPackingInfo: Record "RV Warehouse Packing Info.";
                    TempCalPackingInfo: Record "RV Warehouse Packing Info." temporary;
                    AItemUnitofMeasure: Record "Item Unit of Measure";
                    BItemUnitofMeasure: Record "Item Unit of Measure";
                    CItemUnitofMeasure: Record "Item Unit of Measure";
                    RecItem: Record Item;
                    SumQuantity: Decimal;
                    MaxLineNo: Integer;
                begin
                    TempSourceNo := '';
                    TempSourceLineNo := 0;
                    TempItemNo := '';

                    PackingInfo.Reset();
                    PackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                    PackingInfo.SetCurrentKey("Line No.");
                    PackingInfo.SetAscending("Line No.", false);
                    if PackingInfo.FindSet() then begin
                        MaxLineNo := PackingInfo."Line No.";
                        repeat
                            SumQuantity := 0;

                            TempCalPackingInfo.Reset();
                            TempCalPackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                            TempCalPackingInfo.SetRange("Sales Order No.", PackingInfo."Sales Order No.");
                            TempCalPackingInfo.SetRange("SO Line No.", PackingInfo."SO Line No.");
                            TempCalPackingInfo.SetRange("Item No.", PackingInfo."Item No.");
                            TempCalPackingInfo.SetRange("Lot No.", PackingInfo."Lot No.");
                            if not TempCalPackingInfo.FindFirst() then begin
                                if PackingInfo.Quantity <> PackingInfo."Lot Quantity" then begin

                                    TempPackingInfo.Reset();
                                    TempPackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                                    TempPackingInfo.SetRange("Sales Order No.", PackingInfo."Sales Order No.");
                                    TempPackingInfo.SetRange("SO Line No.", PackingInfo."SO Line No.");
                                    TempPackingInfo.SetRange("Item No.", PackingInfo."Item No.");
                                    TempPackingInfo.SetRange("Lot No.", PackingInfo."Lot No.");
                                    if TempPackingInfo.FindSet() then;

                                    if TempPackingInfo.CalcSums(Quantity) then begin
                                        SumQuantity := TempPackingInfo.Quantity;
                                    end;


                                    if SumQuantity <> PackingInfo."Lot Quantity" then begin
                                        if PackingInfo."Lot Quantity" - SumQuantity > 0 then begin
                                            MaxLineNo += 10000;

                                            RecItem.Get(PackingInfo."Item No.");
                                            AItemUnitofMeasure.Get(PackingInfo."Item No.", PackingInfo."Contents UOM");
                                            if RecItem."RV_Supp. Unit of Measure Code" <> '' then begin
                                                BItemUnitofMeasure.Get(PackingInfo."Item No.", RecItem."RV_Supp. Unit of Measure Code");
                                            end else begin
                                                Error(StrSubstNo('The Supp. Unit of Measure Code in Item(%1) cannot be empty.'), PackingInfo."Item No.");
                                            end;
                                            CItemUnitofMeasure.Get(PackingInfo."Item No.", RikevitaSetup."KG Unit Code");

                                            InsertPackingInfo.Init();
                                            InsertPackingInfo."Warehouse Shipment No." := PackingInfo."Warehouse Shipment No.";
                                            InsertPackingInfo."Sales Order No." := PackingInfo."Sales Order No.";
                                            InsertPackingInfo."SO Line No." := PackingInfo."SO Line No.";
                                            InsertPackingInfo."Item No." := PackingInfo."Item No.";
                                            InsertPackingInfo."Lot No." := PackingInfo."Lot No.";
                                            InsertPackingInfo.Quantity := TempPackingInfo."Lot Quantity" - SumQuantity;
                                            InsertPackingInfo."Lot Quantity" := PackingInfo."Lot Quantity";
                                            InsertPackingInfo."Contents Per Package" := BItemUnitofMeasure."Qty. per Unit of Measure" / AItemUnitofMeasure."Qty. per Unit of Measure";
                                            InsertPackingInfo."Line No." := MaxLineNo;

                                            InsertPackingInfo."External Document No." := PackingInfo."External Document No.";//FDD005
                                            InsertPackingInfo."Sell-to Customer No." := PackingInfo."Sell-to Customer No.";//FDD005
                                            InsertPackingInfo."Qty. per Unit of Measure" := PackingInfo."Qty. per Unit of Measure";//FDD005
                                            InsertPackingInfo."Quantity (KG)" := Abs(InsertPackingInfo."Quantity" / PackingInfo."Qty. per Unit of Measure");//FDD005

                                            InsertPackingInfo.Validate("No. of Packages", InsertPackingInfo."Quantity (KG)" / InsertPackingInfo."Contents Per Package");
                                            InsertPackingInfo."Contents UOM" := PackingInfo."Contents UOM";
                                            InsertPackingInfo."Net Weight" := InsertPackingInfo."Quantity (KG)" * AItemUnitofMeasure."Qty. per Unit of Measure" / CItemUnitofMeasure."Qty. per Unit of Measure";//PackingInfo."Net Weight";
                                            InsertPackingInfo."Gross Weight UOM" := PackingInfo."Gross Weight UOM";
                                            InsertPackingInfo.Insert();

                                            TempCalPackingInfo.Init();
                                            TempCalPackingInfo."Warehouse Shipment No." := PackingInfo."Warehouse Shipment No.";
                                            TempCalPackingInfo."Sales Order No." := PackingInfo."Sales Order No.";
                                            TempCalPackingInfo."SO Line No." := PackingInfo."SO Line No.";
                                            TempCalPackingInfo."Item No." := PackingInfo."Item No.";
                                            TempCalPackingInfo."Lot No." := PackingInfo."Lot No.";
                                            TempCalPackingInfo.Insert();
                                        end else if PackingInfo."Lot Quantity" - SumQuantity < 0 then begin
                                            Error('There is no remaining quantity for this Lot No. to split line.');
                                        end;
                                    end;
                                end;

                            end;
                        until PackingInfo.Next() = 0;
                    end;
                end;
            }
        }
    }
    var
        TempSourceNo: Code[20];
        TempSourceLineNo: Integer;
        TempItemNo: Code[20];
        TempLotNo: Code[50];
        TempQtyToShip: Decimal;
        TempQtyPerUOM: Decimal;
        TempUOM: Code[10];
        RikevitaSetup: Record "RV RIKEVITA Setup";

    procedure InsertPackingInfo(WhseShpgHeader: Record "Warehouse Shipment Header"; WshpLine: Record "Warehouse Shipment Line")
    var
        SOHeader: Record "Sales Header";//FDD005
        PackingInfo: Record "RV Warehouse Packing Info.";
        ReservationEntry: Record "Reservation Entry";
        AItemUnitofMeasure: Record "Item Unit of Measure";
        BItemUnitofMeasure: Record "Item Unit of Measure";
        CItemUnitofMeasure: Record "Item Unit of Measure";
        RecItem: Record Item;
        LineNo: Integer;
        TempLotNo: Code[50];
        TempQuantity: Decimal;
        TempLotQuantity: Decimal;
    begin
        LineNo := 10000;
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source ID", TempSourceNo);
        ReservationEntry.SetRange("Source Ref. No.", TempSourceLineNo);
        ReservationEntry.SetRange("Item No.", TempItemNo);
        //ReservationEntry.SetRange("Location Code", WhseShpgHeader."Location Code");
        ReservationEntry.SetCurrentKey("Lot No.");

        if ReservationEntry.FindSet() then begin
            TempLotNo := '';
            TempQuantity := 0;
            TempLotQuantity := 0;

            RecItem.Get(TempItemNo);
            AItemUnitofMeasure.Get(TempItemNo, TempUOM);
            if RecItem."RV_Supp. Unit of Measure Code" <> '' then begin
                BItemUnitofMeasure.Get(TempItemNo, RecItem."RV_Supp. Unit of Measure Code");
            end else begin
                Error(StrSubstNo('The Supp. Unit of Measure Code in Item(%1) cannot be empty.'), TempItemNo);
            end;
            CItemUnitofMeasure.Get(TempItemNo, RikevitaSetup."KG Unit Code");

            //FDD005
            SOHeader.Reset();
            SOHeader.SetRange("Document Type", "Sales Document Type"::Order);
            SOHeader.SetRange("No.", TempSourceNo);
            if SOHeader.FindSet() then;
            //FDD005
            repeat
                if (ReservationEntry."Lot No." <> TempLotNo) and (TempLotNo <> '') then begin


                    PackingInfo.Init();
                    PackingInfo."Warehouse Shipment No." := WhseShpgHeader."No.";
                    PackingInfo."Sales Order No." := TempSourceNo;
                    PackingInfo."SO Line No." := TempSourceLineNo;
                    PackingInfo."Item No." := TempItemNo;
                    PackingInfo."Lot No." := TempLotNo;
                    //PackingInfo."Container No" := ReservationEntry."RV_Container No.";
                    PackingInfo.Quantity := TempQuantity;//Abs(ReservationEntry."Quantity (Base)");
                    PackingInfo."Lot Quantity" := TempLotQuantity;//Abs(ReservationEntry."Quantity (Base)");
                                                                  //PackingInfo.Validate("No. of Packages", TempQtyToShip * TempQtyPerUOM);

                    PackingInfo."External Document No." := SOHeader."External Document No.";//FDD005
                    PackingInfo."Sell-to Customer No." := SOHeader."Sell-to Customer No.";//FDD005
                    PackingInfo."Qty. per Unit of Measure" := ReservationEntry."Qty. per Unit of Measure";//FDD005
                    PackingInfo."Quantity (KG)" := Abs(PackingInfo.Quantity / PackingInfo."Qty. per Unit of Measure");//FDD005

                    PackingInfo."Contents Per Package" := BItemUnitofMeasure."Qty. per Unit of Measure" / AItemUnitofMeasure."Qty. per Unit of Measure";
                    PackingInfo.Validate("No. of Packages", PackingInfo."Quantity (KG)" / PackingInfo."Contents Per Package");
                    PackingInfo."Contents UOM" := RikevitaSetup."KG Unit Code";
                    PackingInfo."Net Weight" := PackingInfo."Quantity (KG)" * AItemUnitofMeasure."Qty. per Unit of Measure" / CItemUnitofMeasure."Qty. per Unit of Measure";//TempQtyToShip;
                    PackingInfo."Gross Weight UOM" := RikevitaSetup."KG Unit Code";
                    PackingInfo."Line No." := LineNo;

                    PackingInfo.Insert();
                    LineNo += 10000;

                    TempQuantity := 0;
                    TempLotQuantity := 0;
                end;
                TempLotNo := ReservationEntry."Lot No.";
                TempQuantity += Abs(ReservationEntry."Quantity (Base)");
                TempLotQuantity += Abs(ReservationEntry."Quantity (Base)");
            until ReservationEntry.Next() = 0;

            if TempLotNo <> '' then begin
                PackingInfo.Init();
                PackingInfo."Warehouse Shipment No." := WhseShpgHeader."No.";
                PackingInfo."Sales Order No." := TempSourceNo;
                PackingInfo."SO Line No." := TempSourceLineNo;
                PackingInfo."Item No." := TempItemNo;
                PackingInfo."Lot No." := TempLotNo;
                PackingInfo.Quantity := TempQuantity;
                PackingInfo."Lot Quantity" := TempLotQuantity;
                //PackingInfo.Validate("No. of Packages", TempQtyToShip * TempQtyPerUOM);

                PackingInfo."External Document No." := SOHeader."External Document No.";//FDD005
                PackingInfo."Sell-to Customer No." := SOHeader."Sell-to Customer No.";//FDD005
                PackingInfo."Qty. per Unit of Measure" := ReservationEntry."Qty. per Unit of Measure";//FDD005
                PackingInfo."Quantity (KG)" := Abs(PackingInfo.Quantity / PackingInfo."Qty. per Unit of Measure");//FDD005

                PackingInfo."Contents Per Package" := BItemUnitofMeasure."Qty. per Unit of Measure" / AItemUnitofMeasure."Qty. per Unit of Measure";
                PackingInfo.Validate("No. of Packages", PackingInfo."Quantity (KG)" / PackingInfo."Contents Per Package");
                PackingInfo."Contents UOM" := RikevitaSetup."KG Unit Code";
                PackingInfo."Net Weight" := PackingInfo."Quantity (KG)" * AItemUnitofMeasure."Qty. per Unit of Measure" / CItemUnitofMeasure."Qty. per Unit of Measure";//TempQtyToShip;
                PackingInfo."Gross Weight UOM" := RikevitaSetup."KG Unit Code";
                PackingInfo."Line No." := LineNo;
                PackingInfo.Insert();
                LineNo += 10000;

            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        RikevitaSetup.Get();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean //OnClosePage()
    var
        PackingInfo: Record "RV Warehouse Packing Info.";
        TempPackingInfo: Record "RV Warehouse Packing Info.";
        SumQuantity: Decimal;
        IfError: Boolean;
    begin
        IfError := false;
        PackingInfo.Reset();
        PackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
        if PackingInfo.FindSet() then begin
            repeat
                SumQuantity := 0;
                if PackingInfo.Quantity <> PackingInfo."Lot Quantity" then begin
                    TempPackingInfo.Reset();
                    TempPackingInfo.SetRange("Warehouse Shipment No.", Rec."Warehouse Shipment No.");
                    TempPackingInfo.SetRange("Sales Order No.", PackingInfo."Sales Order No.");
                    TempPackingInfo.SetRange("SO Line No.", PackingInfo."SO Line No.");
                    TempPackingInfo.SetRange("Item No.", PackingInfo."Item No.");
                    TempPackingInfo.SetRange("Lot No.", PackingInfo."Lot No.");
                    if TempPackingInfo.FindSet() then;

                    if TempPackingInfo.CalcSums(Quantity) then begin
                        SumQuantity := TempPackingInfo.Quantity;
                    end;

                    if SumQuantity <> PackingInfo."Lot Quantity" then begin
                        IfError := true;
                        break;
                    end;
                end;
            until PackingInfo.Next() = 0;
        end;
        if IfError then begin
            if not Confirm('Some Lots have not been fully assigned to container No.. Do you want to exit the settings?', true) then
                exit(false);
        end;
        //exit(true);
    end;
}

