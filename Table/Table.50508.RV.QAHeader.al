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
        }
        field(3; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
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
        field(9; Mark; Text[250])
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
        field(16; "COA Created Date"; Date)
        {
            Caption = 'COA Created Date';
        }
        field(17; "QA Checked Date"; Date)
        {
            Caption = 'QA Checked Date';
        }
        field(18; "QA Approved Date"; Date)
        {
            Caption = 'QA Approved Date';
        }
        field(19; "QA Comment"; Text[150])
        {
            Caption = 'QA Comment';
        }
        field(20; "Final Destination"; Text[50])
        {
            Caption = 'Final Destination';
        }
        field(21; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(22; "Bill-to Customer Name"; Text[100])
        {
            Caption = 'Bill-to Customer Name';
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
        "Bill-to Customer No." := '';
        "Bill-to Customer Name" := '';
        "Final Destination" := '';
        "Ship-to Code" := '';
        Mark := '';
        "QA Status" := "QA Status"::Analyzing;
        "QA Checked By" := '';
        "QA Approved By" := '';
        "QA Checked Remark" := '';
        "QA Approved Remark" := '';
    end;

    procedure ClearShipmentLotNo()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin
        //clear ShipmentLotNo
        QAShipmentLotNo.SetRange("COA No.", "COA No.");
        QAShipmentLotNo.DeleteAll();
    end;

    procedure InitShipmentLotNo()
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin

        QAShipmentLotNo.SetRange("COA No.", "COA No.");
        if QAShipmentLotNo.IsEmpty then begin
            //Init ShipmentLotNo
            QAShipmentLotNo.Init();
            QAShipmentLotNo."COA No." := "COA No.";
            QAShipmentLotNo."COA Lot Line No." := 0;
            if QAShipmentLotNo.Insert() then;
        end;

    end;

    procedure IsQACheckAllowed(): Boolean
    var
        UserSetup: Record "User Setup";
        TextCheckErr: Label 'You don''t have permission to Check!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QA Check" then
                Error(TextCheckErr);
        end else
            Error(TextCheckErr);
    end;

    procedure IsQAApproveAllowed()
    var
        UserSetup: Record "User Setup";
        TextApproveErr: Label 'You don''t have permission to Approve!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QA Approve" then
                Error(TextApproveErr);
        end else
            Error(TextApproveErr);

        if "QA Checked By" = '' then
            Error('You need to Check before Approve.');
    end;

    procedure IsQARejectAllowed()
    var
        UserSetup: Record "User Setup";
        TextRejectErr: Label 'You don''t have permission to Reject!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QA Reject" then
                Error(TextRejectErr);
        end else
            Error(TextRejectErr);

        if "QA Checked By" = '' then
            Error('You need to Check before Reject.');
    end;

    procedure IsQAReverseAllowed()
    var
        UserSetup: Record "User Setup";
        TextReverseErr: Label 'You don''t have permission to Reverse!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QA Reverse" then
                Error(TextReverseErr);
        end else
            Error(TextReverseErr);

        if "QA Status" in ["QA Status"::Analyzing, "QA Status"::Checked] then
            Error('You can not Reverse, because you need approval or Reject.');
    end;

    procedure CheckRemark_Input()
    var
        UserSetup: Record "User Setup";
        RVQCRemarkInput: Page "RV QC Remark Input";
        RemarkText: array[2] of Text;
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        QAInternalQCResults: Record "RV QA Internal QC Results";
    begin
        //Page
        Clear(RVQCRemarkInput);
        Clear(RemarkText);
        RemarkText[1] := Rec."QA Checked Remark";// Remark
        RemarkText[2] := 'QA Check Remark'; //Caption       

        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            "QA Status" := Rec."QA Status"::Checked;
            "QA Checked Remark" := RemarkText[1];// set Remark
            "QA Checked By" := UserId;
            rec."QA Checked Date" := Today;
            Modify();

            QAShipmentLotNo.Reset();
            QAShipmentLotNo.SetRange("COA No.", "COA No.");
            QAShipmentLotNo.ModifyAll("QA Status", "QA Status"::Checked);

            QAInternalQCResults.Reset();
            QAInternalQCResults.SetRange("COA No.", "COA No.");
            QAInternalQCResults.ModifyAll("QC Checked Remark", "QA Checked Remark");
        end;
    end;

    procedure ApprovedRemark_Input()
    var
        UserSetup: Record "User Setup";
        RVQCRemarkInput: Page "RV QC Remark Input";
        RemarkText: array[2] of Text;
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        QAInternalQCResults: Record "RV QA Internal QC Results";
    begin
        //Page
        Clear(RVQCRemarkInput);
        Clear(RemarkText);
        RemarkText[1] := Rec."QA Approved Remark";// MarkText
        RemarkText[2] := 'QA Approved Remark'; //Caption       

        RVQCRemarkInput.SetParameter(RemarkText);

        IF RVQCRemarkInput.RUNMODAL = ACTION::OK then begin

            CopyArray(RemarkText, RVQCRemarkInput.GetParameter(), 1, 2);
            Rec."QA Status" := Rec."QA Status"::Approved;
            Rec."QA Approved Remark" := RemarkText[1];// set Remark
            rec."QA Approved By" := UserId;
            rec."QA Approved Date" := Today;
            Modify();

            QAShipmentLotNo.Reset();
            QAShipmentLotNo.SetRange("COA No.", "COA No.");
            QAShipmentLotNo.ModifyAll("QA Status", "QA Status"::Approved);

            QAInternalQCResults.Reset();
            QAInternalQCResults.SetRange("COA No.", "COA No.");
            QAInternalQCResults.ModifyAll("QC Approved Remark", "QA Approved Remark");
        end;
    end;

    procedure SetQAEnable(var UpdateQALineEnable: Boolean; var QACheckEnable: Boolean;
                        var QAApproveEnable: Boolean; var QARejectEnable: Boolean)
    begin

        CASE Rec."QA Status" OF
            (Rec."QA Status"::Analyzing):
                begin
                    UpdateQALineEnable := true;
                    QACheckEnable := true;
                    QAApproveEnable := false;
                    QARejectEnable := false;
                end;
            (Rec."QA Status"::Checked):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := true;
                    QARejectEnable := false;
                end;
            (Rec."QA Status"::Approved):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := true;
                end;
            (Rec."QA Status"::Rejected):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;
                end;
        END;

    end;

    procedure ValidateOrderNo()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        PostedWhShipLine: Record "Posted Whse. Shipment Line";
        PostedWhShipHeader: Record "Posted Whse. Shipment Header";

        SalesHeader: Record "Sales Header";
        WhShipline: Record "Warehouse Shipment line";
        WhShipHeader: Record "Warehouse Shipment Header";
        ReservEntry: Record "Reservation Entry";
        //TrackingSpec: Record "Tracking Specification";
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        TempQAShipmentLotNo: Record "RV QA Shipment Lot No." temporary;
        COALotLineNo: Integer;
        ItemLedgEntry: Record "Item Ledger Entry";
        RefOrderTypeQA: Enum "RV Ref. Order Type QA";
        salesLine: Record "Sales line";
        ReservMgt: Codeunit "Reservation Management";
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Posted Whse. Shipment" then begin

            PostedWhShipLine.SetRange("No.", Rec."Order No.");
            PostedWhShipLine.SetRange("Line No.", Rec."Line No.");

            if PostedWhShipLine.FindFirst() then begin
                Rec."Item No." := PostedWhShipLine."Item No.";
                Rec."Item Description" := PostedWhShipLine.Description;

                SalesShipmentHeader.SetRange("order No.", PostedWhShipLine."Source No.");
                if SalesShipmentHeader.FindFirst() then begin
                    Rec."Ship-to Customer No." := SalesShipmentHeader."Sell-to Customer No.";
                    Rec."Ship-to Customer name" := SalesShipmentHeader."Sell-to Customer name";
                    Rec."Ship-to Code" := SalesShipmentHeader."Ship-to Code";
                    Rec."Bill-to Customer No." := SalesShipmentHeader."Bill-to Customer No.";
                    Rec."Bill-to Customer name" := SalesShipmentHeader."Bill-to name";
                end;

                if PostedWhShipHeader.Get(Rec."Order No.") then
                    Rec."Final Destination" := PostedWhShipHeader."RV_Final Destination";

                SalesShipmentLine.Reset();
                SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                SalesShipmentLine.SetRange("Line No.", PostedWhShipLine."Source Line No.");
                SalesShipmentLine.FindFirst();

                // Filter Item Ledger Entry by Document No. and Line No.
                ItemLedgEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
                ItemLedgEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                Clear(COALotLineNo);

                if ItemLedgEntry.FindSet() then
                    repeat
                        COALotLineNo += 10000;
                        QAShipmentLotNo.Init();
                        QAShipmentLotNo."COA No." := Rec."COA No.";
                        QAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                        QAShipmentLotNo."Lot No." := ItemLedgEntry."Lot No.";

                        QAShipmentLotNo.Quantity :=
                        Abs(UOMMgt.CalcQtyFromBase(ItemLedgEntry.Quantity, ItemLedgEntry."Qty. per Unit of Measure"));

                        QAShipmentLotNo."Sales Order No." := SalesShipmentHeader."Order No.";
                        QAShipmentLotNo."Qty. (Base)" := Abs(ItemLedgEntry.Quantity);

                        QAShipmentLotNo.UOM := ItemLedgEntry."Unit of Measure Code";
                        QAShipmentLotNo."Qty. per UOM" := ItemLedgEntry."Qty. per Unit of Measure";

                        QAShipmentLotNo."Expire Date" := ItemLedgEntry."Expiration Date";
                        QAShipmentLotNo."Container No." := ItemLedgEntry."RV_Container No.";

                        QAShipmentLotNo."Manufacturing Date" := ItemLedgEntry."Expiration Date";
                        QAShipmentLotNo.Insert();
                    until ItemLedgEntry.Next() = 0;
            end;

        end else if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Warehouse Shipment" then begin

            WhShipline.Reset();
            WhShipline.SetRange("No.", Rec."Order No.");
            WhShipline.SetRange("Line No.", Rec."Line No.");

            if WhShipline.FindFirst() then begin
                Rec."Item No." := WhShipline."Item No.";
                Rec."Item Description" := WhShipline.Description;

                if SalesHeader.get(SalesHeader."Document Type"::Order, WhShipline."Source No.") then begin
                    Rec."Ship-to Customer No." := SalesHeader."Sell-to Customer No.";
                    Rec."Ship-to Customer name" := SalesHeader."Sell-to Customer name";
                    Rec."Ship-to Code" := SalesHeader."Ship-to Code";
                    Rec."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
                    Rec."Bill-to Customer name" := SalesHeader."Bill-to name";
                end;

                if WhShipHeader.Get(Rec."Order No.") then
                    Rec."Final Destination" := WhShipHeader."RV_Final Destination";

                Clear(COALotLineNo);
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", WhShipline."Source No.");
                SalesLine.SetRange("Line No.", WhShipline."Source Line No.");
                SalesLine.SetRange("No.", WhShipline."Item No.");
                if SalesLine.FindFirst() then;

                //  filtering Reservation Entries for a Whse. Shipment Line
                /*
                Table: ”Reservation Entry”(337)
                Data Filter:
                “Reservation Status” = “Reservation Status”:”Tracking”
                “Source ID” = “Sales Order No.”
                “Source Type” = 37
                ？“RefSource Type” = （Sales Line No
                */

                //clear TempQAShipmentLotNo
                TempQAShipmentLotNo.Reset();
                TempQAShipmentLotNo.DeleteAll();
                /*
                                TrackingSpec.Reset();
                                TrackingSpec.SetRange("Source Type", WhShipline."Source Type");//37
                                TrackingSpec.SetRange("Source Subtype", WhShipline."Source Subtype");
                                TrackingSpec.SetRange("Source ID", WhShipline."Source No.");//Sales Header No.
                                TrackingSpec.SetRange("Source Ref. No.", WhShipline."Source Line No."); //Sales Line No
                                if TrackingSpec.FindSet() then
                                    repeat

                                        TempQAShipmentLotNo.SetRange("Lot No.", TrackingSpec."Lot No.");
                                        if not TempQAShipmentLotNo.FindFirst() then begin

                                            COALotLineNo += 10000;
                                            TempQAShipmentLotNo.Init();
                                            TempQAShipmentLotNo."COA No." := Rec."COA No.";
                                            TempQAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                                            TempQAShipmentLotNo."Lot No." := TrackingSpec."Lot No.";
                                            TempQAShipmentLotNo."Sales Order No." := WhShipline."Source No.";
                                            TempQAShipmentLotNo."Qty. (Base)" := -TrackingSpec."Quantity (Base)";
                                            TempQAShipmentLotNo."Qty. per UOM" := TrackingSpec."Qty. per Unit of Measure";
                                            TempQAShipmentLotNo.UOM := SalesLine."Unit of Measure Code";
                                            TempQAShipmentLotNo.Quantity := -TrackingSpec."Quantity (Base)" / TrackingSpec."Qty. per Unit of Measure";

                                            TempQAShipmentLotNo."Expire Date" := TrackingSpec."Expiration Date";
                                            TempQAShipmentLotNo."Manufacturing Date" := TrackingSpec."RV_Manufacture Date";
                                            TempQAShipmentLotNo."Container No." := TrackingSpec."RV_Container No.";

                                            TempQAShipmentLotNo.Insert();
                                        end else begin
                                            TempQAShipmentLotNo.Quantity += Abs(TrackingSpec."Quantity (Base)") / TrackingSpec."Qty. per Unit of Measure";
                                            TempQAShipmentLotNo."Qty. (Base)" += Abs(TrackingSpec."Quantity (Base)");
                                            TempQAShipmentLotNo.Modify();
                                        end;

                                    until TrackingSpec.Next() = 0;*/


                ReservEntry.Reset();
                ReservEntry.SetRange("Source Type", WhShipline."Source Type");//37
                ReservEntry.SetRange("Source Subtype", WhShipline."Source Subtype");
                ReservEntry.SetRange("Source ID", WhShipline."Source No.");//Sales Header No.
                ReservEntry.SetRange("Source Ref. No.", WhShipline."Source Line No."); //Sales Line No
                ReservEntry.SetRange("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
                ReservEntry.SetFilter("Lot No.", '<>%1', ''); // only consider lot tracked items
                if ReservEntry.FindSet() then
                    repeat

                        TempQAShipmentLotNo.SetRange("Lot No.", ReservEntry."Lot No.");
                        if not TempQAShipmentLotNo.FindFirst() then begin

                            COALotLineNo += 10000;
                            TempQAShipmentLotNo.Init();
                            TempQAShipmentLotNo."COA No." := Rec."COA No.";
                            TempQAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                            TempQAShipmentLotNo."Lot No." := ReservEntry."Lot No.";
                            TempQAShipmentLotNo."Sales Order No." := WhShipline."Source No.";
                            TempQAShipmentLotNo."Qty. (Base)" := -ReservEntry."Quantity (Base)";
                            TempQAShipmentLotNo."Qty. per UOM" := ReservEntry."Qty. per Unit of Measure";
                            TempQAShipmentLotNo.UOM := SalesLine."Unit of Measure Code";
                            TempQAShipmentLotNo.Quantity := ROUND(-ReservEntry."Quantity (Base)" / ReservEntry."Qty. per Unit of Measure", 0.00001);
                            ItemLedgEntry.reset;
                            ItemLedgEntry.SetRange("Lot No.", ReservEntry."Lot No.");
                            ItemLedgEntry.SetRange(Positive, true);
                            ItemLedgEntry.SetRange("Item No.", Rec."Item No.");
                            if ItemLedgEntry.FindLast() then begin
                                TempQAShipmentLotNo."Expire Date" := ItemLedgEntry."Expiration Date";
                                TempQAShipmentLotNo."Manufacturing Date" := ItemLedgEntry."Expiration Date";
                            end;
                            //TempQAShipmentLotNo."Expire Date" := ReservEntry."Expiration Date";
                            //TempQAShipmentLotNo."Manufacturing Date" := ReservEntry."RV_Manufacture Date";
                            TempQAShipmentLotNo."Container No." := ReservEntry."RV_Container No.";

                            TempQAShipmentLotNo.Insert();
                        end else begin
                            TempQAShipmentLotNo.Quantity += Round(Abs(ReservEntry."Quantity (Base)") / ReservEntry."Qty. per Unit of Measure", 0.00001);
                            TempQAShipmentLotNo."Qty. (Base)" += Abs(ReservEntry."Quantity (Base)");
                            TempQAShipmentLotNo.Modify();
                        end;

                    until ReservEntry.Next() = 0;
                TempQAShipmentLotNo.Reset();
                if TempQAShipmentLotNo.FindSet() then
                    repeat
                        QAShipmentLotNo.Init();
                        QAShipmentLotNo.TransferFields(TempQAShipmentLotNo);
                        if QAShipmentLotNo.Insert() then;
                    until TempQAShipmentLotNo.Next() = 0;
            end;
        end;
    end;
}