/// <summary>
/// Table RV QA Header (ID 50508)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50508 "RV QA Header"
{
    Caption = 'QA Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
        }
        field(2; "Ref. Order Type QA"; Enum "RV Ref. Order Type QA")
        {
            Caption = 'Ref. Order Type';
            trigger OnValidate()
            var
                QAShipmentLotNo: Record "RV QA Shipment Lot No.";
            begin
                //clear data
                /*
                if (xRec."Ref. Order Type QA" <> "Ref. Order Type QA") then begin
                    QAShipmentLotNo.SetRange("COA No.", "COA No.");
                    if QAShipmentLotNo.Count = 0 then begin
                        "Order No." := '';
                        "Item No." := '';
                    end else begin
                        if not Confirm(StrSubstNo(ConfirmChangeQst, 'Ref. Order Type'), false) then
                            exit;
                        //clear data
                        QAShipmentLotNo.DeleteAll();
                        "Order No." := '';
                        "Item No." := '';
                    end;

                    
                    

                end;
                

                "Order No." := '';
                "Item No." := '';

                //ClearHeaderData
                ClearHeaderData();

                //clear ShipmentLotNo
                QAShipmentLotNo.SetRange("COA No.", "COA No.");
                QAShipmentLotNo.DeleteAll();
                */

            end;
        }
        field(3; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            //ValidateTableRelation = false;
            /*
            TableRelation =
            if ("Ref. Order Type QA" = const("Posted Whse. Shipment")) "Posted Whse. Shipment Line"
            else
            if ("Ref. Order Type QA" = const("Warehouse Shipment")) "Warehouse Shipment Line";
            */
            trigger OnValidate()
            var
                PostedWhShipHeader: Record "Posted Whse. Shipment Header";
                PostedWhShipLine: Record "Posted Whse. Shipment Line";
                WhShipHeader: Record "Warehouse Shipment Header";
                WhShipline: Record "Warehouse Shipment line";
                RefOrderTypeQA: Enum "RV Ref. Order Type QA";
                QAShipmentLotNo: Record "RV QA Shipment Lot No.";
            begin

                //if (xRec."Order No." <> '') and (xRec."Order No." <> "Order No.") then begin
                //   if not Confirm(StrSubstNo(ConfirmChangeQst, 'Order No.'), false) then
                //       exit;
                //clear data
                //QAShipmentLotNo.SetRange("COA No.", "COA No.");
                //QAShipmentLotNo.DeleteAll();
                //"Item No." := '';
                //end;

                //"Item No." := '';
                //ClearHeaderData
                //ClearHeaderData();

                //clear ShipmentLotNo
                //ClearShipmentLotNo();

            end;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            //TableRelation =
            //if ("Ref. Order Type" = const(" ")) "Standard Text"
            //else
            //if ("Ref. Order Type QA" = const("Posted Whse. Shipment")) "Posted Whse. Shipment line"."Item No." where("No." = field("Order No."))
            //else
            //if ("Ref. Order Type QA" = const("Warehouse Shipment")) "Warehouse Shipment Line"."Item No." where("No." = field("Order No."));
            //ValidateTableRelation = false;




            trigger OnValidate()
            var
                QAShipmentLotNo: Record "RV QA Shipment Lot No.";
            begin
                //if (xRec."Item No." <> '') and (xRec."Item No." <> "Item No.") then begin
                //if not Confirm(StrSubstNo(ConfirmChangeQst, 'Item No.'), false) then
                //    exit;

                //end;

                //ClearHeaderData
                //ClearHeaderData();

                //clear ShipmentLotNo
                //ClearShipmentLotNo();

                //ValidateItemNo
                //ValidateItemNo();


            end;
        }
        field(5; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(6; "Ship-to Customer No."; Code[20])
        {
            Caption = 'Ship-to Customer No.';
            TableRelation = Customer;
        }
        field(7; "Ship-to Customer Name"; Text[100])
        {
            Caption = 'Ship-to Customer Name';
        }
        field(8; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Ship-to Customer No."));
        }
        field(9; Mark; Code[10])
        {
            Caption = 'Mark';
        }
        field(10; "QA Status"; Enum "RV QA Status")
        {
            Caption = 'QA Status';
        }
        field(11; "QA Checked By"; Text[50])
        {
            Caption = 'QA Checked By';
        }
        field(12; "QA Approved By"; Text[50])
        {
            Caption = 'QA Approved By';
        }
        field(13; "QA Checked Remark"; Text[150])
        {
            Caption = 'QA Checked Remark';
        }
        field(14; "QA Approved Remark"; Text[150])
        {
            Caption = 'QA Approved Remark';
        }
        field(16; "COA Date"; Date)
        {
            Caption = 'COA Date';
        }
        field(100; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }
    keys
    {
        key(PK; "COA No.")
        {
            Clustered = true;
        }
    }

    /*
    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RIKEVITA Setup";
    begin

        if "COA No." = '' then begin
            RIKEVITASetup.Get();
            RIKEVITASetup.TestField("COA No. Nos.");
            "COA No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."COA No. Nos.");
        end;
    end;
    */


    trigger OnDelete()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        QAInternalQCResults: Record "RV QA Internal QC Results";
        QAExternalQCResults: Record "RV QA External QC Results";
        QAInyResultLine: Record "RV QA Iny. Result Line";
    begin

        QAShipmentLotNo.Reset();
        QAShipmentLotNo.LockTable();
        QAShipmentLotNo.SetRange("COA No.", Rec."COA No.");
        QAShipmentLotNo.DeleteAll(true);

        QAInternalQCResults.Reset();
        QAInternalQCResults.LockTable();
        QAInternalQCResults.SetRange("COA No.", Rec."COA No.");
        QAInternalQCResults.DeleteAll(true);

        QAExternalQCResults.Reset();
        QAExternalQCResults.LockTable();
        QAExternalQCResults.SetRange("COA No.", Rec."COA No.");
        QAExternalQCResults.DeleteAll(true);

        QAInyResultLine.Reset();
        QAInyResultLine.LockTable();
        QAInyResultLine.SetRange("COA No.", Rec."COA No.");
        QAInyResultLine.DeleteAll(true);

    end;

    var

        ConfirmChangeQst: Label 'Do you want to change %1?';
        RefOrderTypeQA: Enum "RV Ref. Order Type QA";


    procedure ClearHeaderData()
    begin
        "Item No." := '';
        "Item Description" := '';
        "Ship-to Customer No." := '';
        "Ship-to Customer Name" := '';
        "Ship-to Code" := '';
        Mark := '';
        "QA Status" := "QA Status"::Analyzing;
        "QA Checked By" := '';
        "QA Approved By" := '';
        "QA Checked Remark" := '';
        "QA Approved Remark" := '';
        "COA Date" := 0D;
    end;

    procedure ClearShipmentLotNo()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin
        //clear ShipmentLotNo
        QAShipmentLotNo.SetRange("COA No.", "COA No.");
        QAShipmentLotNo.DeleteAll();
    end;

    procedure ValidateOrderNo()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        PostedWhShipLine: Record "Posted Whse. Shipment Line";

        SalesHeader: Record "Sales Header";
        WhShipline: Record "Warehouse Shipment line";
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        COALotLineNo: Integer;
        ItemLedgEntry: Record "Item Ledger Entry";
        RefOrderTypeQA: Enum "RV Ref. Order Type QA";

        salesLine: Record "Sales line";
        ReservMgt: Codeunit "Reservation Management";
    begin
        if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Posted Whse. Shipment" then begin

            PostedWhShipLine.SetRange("No.", Rec."Order No.");
            PostedWhShipLine.SetRange("Line No.", Rec."Line No.");

            if PostedWhShipLine.FindFirst() then begin
                Rec."Item Description" := PostedWhShipLine.Description;

                SalesShipmentHeader.SetRange("order No.", PostedWhShipLine."Source No.");
                if SalesShipmentHeader.FindFirst() then begin
                    Rec."Ship-to Customer No." := SalesShipmentHeader."Sell-to Customer No.";
                    Rec."Ship-to Customer name" := SalesShipmentHeader."Sell-to Customer name";
                    Rec."Ship-to Code" := SalesShipmentHeader."Ship-to Code";
                end;

                SalesShipmentLine.Reset();
                SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                SalesShipmentLine.SetRange("Line No.", PostedWhShipLine."Source Line No.");
                SalesShipmentLine.FindFirst();


                // Filter Item Ledger Entry by Document No. and Line No.
                ItemLedgEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
                ItemLedgEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                Clear(COALotLineNo);
                //Message('ItemLedgEntry %1', ItemLedgEntry.count);
                if ItemLedgEntry.FindSet() then
                    repeat
                        COALotLineNo += 10000;
                        QAShipmentLotNo.Init();
                        QAShipmentLotNo."COA No." := Rec."COA No.";
                        QAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                        QAShipmentLotNo."Lot No." := ItemLedgEntry."Lot No.";
                        if SalesShipmentLine."Qty. per Unit of Measure" <> 0 then
                            QAShipmentLotNo.Quantity := Abs(ItemLedgEntry.Quantity) / SalesShipmentLine."Qty. per Unit of Measure";
                        QAShipmentLotNo."Sales Order No." := SalesShipmentHeader."Order No.";
                        QAShipmentLotNo."Qty. (Base)" := Abs(ItemLedgEntry.Quantity);

                        QAShipmentLotNo."Expire Date" := ItemLedgEntry."Expiration Date";

                        QAShipmentLotNo."Manufacturing Date" := ItemLedgEntry."Expiration Date";
                        QAShipmentLotNo.Insert();
                    until ItemLedgEntry.Next() = 0;

            end;

        end else if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Warehouse Shipment" then begin

            WhShipline.SetRange("No.", Rec."Order No.");
            WhShipline.SetRange("Line No.", Rec."Line No.");

            if WhShipline.FindFirst() then begin
                Rec."Item Description" := WhShipline.Description;

                SalesHeader.SetRange("No.", WhShipline."Source No.");
                if SalesHeader.FindFirst() then begin
                    Rec."Ship-to Customer No." := SalesHeader."Sell-to Customer No.";
                    Rec."Ship-to Customer name" := SalesHeader."Sell-to Customer name";
                    Rec."Ship-to Code" := SalesHeader."Ship-to Code";
                end;

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", WhShipline."Source No.");
                SalesLine.SetRange("Line No.", WhShipline."Source Line No.");
                SalesLine.SetRange("No.", WhShipline."Item No.");
                SalesLine.FindFirst();




                Clear(COALotLineNo);
                //  filtering Reservation Entries for a Whse. Shipment Line
                ReservEntry.SetCurrentKey("Source ID", "Source Type", "Source Subtype");
                ReservEntry.SetRange("Source Type", WhShipline."Source Type");
                ReservEntry.SetRange("Source Subtype", WhShipline."Source Subtype");
                ReservEntry.SetRange("Source ID", WhShipline."Source No.");
                ReservEntry.SetRange("Source Ref. No.", WhShipline."Source Line No.");


                if ReservEntry.FindSet() then
                    repeat
                        ReservEntry2.Reset();
                        ReservEntry2.SetRange("Entry No.", ReservEntry."Entry No.");
                        ReservEntry2.SetRange(Positive, true);
                        if ReservEntry2.FindFirst() then begin
                            COALotLineNo += 10000;
                            QAShipmentLotNo.Init();
                            QAShipmentLotNo."COA No." := Rec."COA No.";
                            QAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                            QAShipmentLotNo."Lot No." := ReservEntry2."Lot No.";
                            QAShipmentLotNo.Quantity := ReservEntry2.Quantity;
                            QAShipmentLotNo."Sales Order No." := WhShipline."Source No.";
                            QAShipmentLotNo."Qty. (Base)" := ReservEntry2."Quantity (Base)";

                            QAShipmentLotNo."Expire Date" := ReservEntry2."Expiration Date";

                            QAShipmentLotNo."Manufacturing Date" := ReservEntry2."Expiration Date";
                            QAShipmentLotNo.Insert();
                            //QAShipmentLotNo."Container No." := ;

                            //QAShipmentLotNo."QA Status" := ;
                        end;
                    until ReservEntry.Next() = 0;

            end;


        end;
    end;




}