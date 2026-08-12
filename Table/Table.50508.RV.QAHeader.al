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
            trigger OnValidate()
            begin
                ValidateQACheckedRemark();
            end;
        }
        field(14; "QA Approved Remark"; Text[150])
        {
            Caption = 'QA Approved Remark';
            trigger OnValidate()
            begin
                ValidateQAApprovedRemark();
            end;
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

    procedure IsQACheckAllowed()
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

    procedure ValidateQACheckedRemark()
    var
        UserSetup: Record "User Setup";
        TextCheckErr: Label 'You don''t have permission to Edit!';
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

    procedure ValidateQAApprovedRemark()
    var
        UserSetup: Record "User Setup";
        TextApproveErr: Label 'You don''t have permission to Edit!';
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."RV_Allow QA Approve" then
                Error(TextApproveErr);
        end else
            Error(TextApproveErr);
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
                        var QAApproveEnable: Boolean; var QARejectEnable: Boolean; var SubCOACardEditable: Boolean)
    begin
        CASE Rec."QA Status" OF
            (Rec."QA Status"::Analyzing):
                begin
                    UpdateQALineEnable := true;
                    QACheckEnable := true;
                    QAApproveEnable := false;
                    QARejectEnable := false;

                    SubCOACardEditable := true;
                end;
            (Rec."QA Status"::Checked):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := true;
                    QARejectEnable := false;

                    SubCOACardEditable := true;
                end;
            (Rec."QA Status"::Approved):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := true;

                    SubCOACardEditable := false;
                end;
            (Rec."QA Status"::Rejected):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;

                    SubCOACardEditable := false;
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
        //ReservEntry: Record "Reservation Entry";
        //TrackingSpec: Record "Tracking Specification";
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        //TempQAShipmentLotNo: Record "RV QA Shipment Lot No." temporary;
        COALotLineNo: Integer;
        ItemLedgEntry: Record "Item Ledger Entry";
        RefOrderTypeQA: Enum "RV Ref. Order Type QA";
        salesLine: Record "Sales line";
        //ReservMgt: Codeunit "Reservation Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        WarehousePackingInfo: Record "RV Warehouse Packing Info.";

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

                //WarehousePackingInfo
                Clear(COALotLineNo);
                WarehousePackingInfo.Reset();
                WarehousePackingInfo.SetRange("Sales Order No.", PostedWhShipLine."Source No.");//Sales Header No.
                WarehousePackingInfo.SetRange("SO Line No.", PostedWhShipLine."Source Line No."); //Sales Line No
                WarehousePackingInfo.SetRange("Posted Whse. Shipment No.", PostedWhShipLine."No.");
                if WarehousePackingInfo.FindSet() then
                    repeat
                        COALotLineNo += 10000;
                        QAShipmentLotNo.Init();
                        QAShipmentLotNo."COA No." := Rec."COA No.";
                        QAShipmentLotNo."COA Lot Line No." := COALotLineNo;
                        QAShipmentLotNo."Lot No." := WarehousePackingInfo."Lot No.";
                        QAShipmentLotNo."Sales Order No." := PostedWhShipLine."Source No.";

                        QAShipmentLotNo.Quantity := WarehousePackingInfo.Quantity * WarehousePackingInfo."Contents Per Package";
                        QAShipmentLotNo."Qty. (Base)" := WarehousePackingInfo."Quantity";
                        QAShipmentLotNo."Qty. per UOM" := WarehousePackingInfo."Contents Per Package";
                        QAShipmentLotNo."Container No." := WarehousePackingInfo."Container No";
                        QAShipmentLotNo.UOM := WarehousePackingInfo."Contents UOM";
                        QAShipmentLotNo.Comment := WarehousePackingInfo.Comment;

                        //QAShipmentLotNo."Qty. (Base)" := Abs(ItemLedgEntry.Quantity);
                        ItemLedgEntry.Reset();
                        ItemLedgEntry.SetCurrentKey("Item No.", "Posting Date");
                        ItemLedgEntry.SetRange("Item No.", WarehousePackingInfo."Item No.");
                        ItemLedgEntry.SetRange("lot No.", WarehousePackingInfo."Lot No.");
                        ItemLedgEntry.SetFilter(Quantity, '>%1', 0);
                        if ItemLedgEntry.FindLast() then begin
                            QAShipmentLotNo."Expire Date" := ItemLedgEntry."Expiration Date";
                            QAShipmentLotNo."Manufacturing Date" := ItemLedgEntry."Posting Date";
                        end;

                        QAShipmentLotNo.Insert();
                    until WarehousePackingInfo.Next() = 0;
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

                WarehousePackingInfo.Reset();
                WarehousePackingInfo.SetRange("Sales Order No.", WhShipline."Source No.");//Sales Header No.
                WarehousePackingInfo.SetRange("SO Line No.", WhShipline."Source Line No."); //Sales Line No
                WarehousePackingInfo.SetRange("Warehouse Shipment No.", WhShipline."No.");
                if WarehousePackingInfo.FindSet() then
                    repeat
                        COALotLineNo += 10000;
                        QAShipmentLotNo.Init();
                        QAShipmentLotNo."COA No." := Rec."COA No.";
                        QAShipmentLotNo."COA Lot Line No." := COALotLineNo;

                        QAShipmentLotNo."Lot No." := WarehousePackingInfo."Lot No.";
                        QAShipmentLotNo."Sales Order No." := WhShipline."Source No.";

                        QAShipmentLotNo.Quantity := WarehousePackingInfo.Quantity * WarehousePackingInfo."Contents Per Package";
                        QAShipmentLotNo."Qty. (Base)" := WarehousePackingInfo."Quantity";
                        QAShipmentLotNo."Qty. per UOM" := WarehousePackingInfo."Contents Per Package";
                        QAShipmentLotNo."Container No." := WarehousePackingInfo."Container No";
                        QAShipmentLotNo.UOM := WarehousePackingInfo."Contents UOM";
                        QAShipmentLotNo.Comment := WarehousePackingInfo.Comment;

                        //QAShipmentLotNo."Qty. (Base)" := -ReservEntry."Quantity (Base)";
                        ItemLedgEntry.Reset();
                        ItemLedgEntry.SetRange("Item No.", WarehousePackingInfo."Item No.");
                        ItemLedgEntry.SetRange("lot No.", WarehousePackingInfo."Lot No.");
                        ItemLedgEntry.SetFilter(Quantity, '>%1', 0);
                        if ItemLedgEntry.FindFirst() then begin
                            QAShipmentLotNo."Expire Date" := ItemLedgEntry."Expiration Date";
                            QAShipmentLotNo."Manufacturing Date" := ItemLedgEntry."Posting Date";
                        end;

                        QAShipmentLotNo.Insert();
                    until WarehousePackingInfo.Next() = 0;
            end;
        end;
    end;
}