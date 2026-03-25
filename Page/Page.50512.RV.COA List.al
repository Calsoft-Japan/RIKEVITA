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
    //ModifyAllowed = false;

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
                    //Editable = false;
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
                ApplicationArea = Basic, Suite;
                Caption = 'New COA';
                Image = OpenJournal;
                trigger OnAction()
                begin
                    NewQAShipmentLotNo(Rec);
                end;
            }
            action("Edit COA")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit COA';
                Image = OpenJournal;
                trigger OnAction()
                begin
                    EditQAShipmentLotNo(Rec);
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
            }
        }
    }

    trigger OnInit()
    begin
        //SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //SetupNewBatch();
    end;

    trigger OnOpenPage()
    var
    begin

        //ItemJnlMgt.OpenJnlBatch(Rec);
        //QAMgt.OpenJnlBatch(Rec);
    end;

    var


    procedure EditQAShipmentLotNo(var QAHeader: Record "RV QA Header")
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
    begin

        QAShipmentLotNo.FilterGroup := 2;
        QAShipmentLotNo.SetRange("COA No.", QAHeader."COA No.");
        QAShipmentLotNo.FilterGroup := 0;

        QAShipmentLotNo."COA No." := QAHeader."COA No.";
        PAGE.Run(Page::"RV COA ShipmentLotNo", QAShipmentLotNo);
    end;

    procedure NewQAShipmentLotNo(var QAHeader: Record "RV QA Header")
    var
        QAShipmentLotNo: Record "RV QA Shipment Lot No.";
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    //COANo: Code[20];
    begin
        RIKEVITASetup.Get();
        RIKEVITASetup.TestField("COA No. Nos.");
        QAHeader.Init();
        QAHeader."COA No." := NoSeriesMgt.GetNextNo(RIKEVITASetup."COA No. Nos.", WorkDate(), true);
        QAHeader.Insert();

        QAShipmentLotNo."COA No." := QAHeader."COA No.";

        QAShipmentLotNo.FilterGroup := 2;
        QAShipmentLotNo.SetRange("COA No.", QAHeader."COA No.");
        QAShipmentLotNo.FilterGroup := 0;

        PAGE.Run(Page::"RV COA ShipmentLotNo", QAShipmentLotNo);

    end;
}

