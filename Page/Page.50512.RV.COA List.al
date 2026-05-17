/// <summary>
/// Page RV COA List (ID 50512)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50512 "RV COA List"
{
    Caption = 'COA List';
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "RV QA Header";
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        EditQAShipmentLotNo(Rec);
                        CurrPage.Update(false);
                    end;
                }
                field("COA Date"; Rec."COA Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ship-to Customer No."; Rec."Ship-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("QA Status"; Rec."QA Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA Checked By"; Rec."QA Checked By")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("QA Checked Remark"; Rec."QA Checked Remark")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("QA Approved By"; Rec."QA Approved By")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("QA Approved Remark"; Rec."QA Approved Remark")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Mark"; Rec."Mark")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type QA")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New COA")
            {
                ApplicationArea = All;
                Caption = 'New COA';
                Image = OpenJournal;
                trigger OnAction()
                begin
                    NewQAShipmentLotNo(Rec);
                end;
            }
            action("Edit COA")
            {
                ApplicationArea = All;
                Caption = 'Edit COA';
                Image = EditJournal;
                trigger OnAction()
                begin
                    EditQAShipmentLotNo(Rec);
                end;
            }
            action("Delete COA")
            {
                ApplicationArea = All;
                Caption = 'Delete COA';
                Image = Delete;
                trigger OnAction()
                begin
                    DeleteCOA();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("New COA_Promoted"; "New COA")
                {
                }
                actionref("Edit COA_Promoted"; "Edit COA")
                {
                }
                actionref("Delete COA_Promoted"; "Delete COA")
                {
                }
            }
        }
    }

    trigger OnInit()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnOpenPage()
    var
    begin

    end;

    var


    procedure EditQAShipmentLotNo(var QAHeader: Record "RV QA Header")
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        ShipmentLotNoPage: Page "RV COA ShipmentLotNo";
    begin
        QAShipmentLotNo.FilterGroup := 2;
        QAShipmentLotNo.SetRange("COA No.", QAHeader."COA No.");
        QAShipmentLotNo.FilterGroup := 0;
        if not QAShipmentLotNo.FindFirst() then begin
            QAShipmentLotNo.Init();
            QAShipmentLotNo."COA No." := QAHeader."COA No.";
        end;
        ShipmentLotNoPage.SetRecord(QAShipmentLotNo);
        ShipmentLotNoPage.SetTableView(QAShipmentLotNo);
        ShipmentLotNoPage.Run();
    end;

    procedure NewQAShipmentLotNo(var QAHeader: Record "RV QA Header")
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        ShipmentLotNoPage: Page "RV COA ShipmentLotNo";
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        RIKEVITASetup.Get();
        RIKEVITASetup.TestField("COA No. Nos.");
        QAHeader.Init();
        QAHeader."COA No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."COA No. Nos.", WorkDate(), true);
        QAHeader."Ref. Order Type QA" := QAHeader."Ref. Order Type QA"::"Posted Whse. Shipment";
        QAHeader.Insert();

        QAShipmentLotNo.FilterGroup := 2;
        QAShipmentLotNo.SetRange("COA No.", QAHeader."COA No.");
        QAShipmentLotNo.FilterGroup := 0;

        QAShipmentLotNo.Init();
        QAShipmentLotNo."COA No." := QAHeader."COA No.";
        QAShipmentLotNo."COA Lot Line No." := 10000;
        QAShipmentLotNo.Insert();

        ShipmentLotNoPage.SetRecord(QAShipmentLotNo);
        ShipmentLotNoPage.SetTableView(QAShipmentLotNo);
        ShipmentLotNoPage.Run();
    end;

    procedure DeleteCOA()
    var
        TextDeleteQst: Label 'Do you want to delete COA ?';
    begin

        if not Confirm(TextDeleteQst) then
            exit;
        Rec.Delete(true);
    end;
}

