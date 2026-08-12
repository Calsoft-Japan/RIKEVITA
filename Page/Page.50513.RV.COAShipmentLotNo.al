/// <summary>
/// Page RV COA ShipmentLotNo (ID 50513)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50513 "RV COA ShipmentLotNo"
{
    AutoSplitKey = true;
    //DelayedInsert = true;
    Caption = 'COA';
    PageType = List;
    SaveValues = true;
    SourceTable = "RV QA Shipment Lot No.";
    DataCaptionFields = "COA No.";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            part(SubCOACard; "RV COA Card Subform")
            {
                Caption = ' ';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No.");
                UpdatePropagation = Both;
            }
            group(Control22)
            {
                Caption = 'Shipment Lot No. List';
                repeater("<Shipment Lot No. List>")
                {
                    //ShowCaption = false;
                    field("COA No."; Rec."COA No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("COA Lot Line No."; Rec."COA Lot Line No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Lot No."; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(UOM; Rec.UOM)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Container No."; Rec."Container No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Manufacturing Date"; Rec."Manufacturing Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Expire Date"; Rec."Expire Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Sales Order No."; Rec."Sales Order No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("QA Status"; Rec."QA Status")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Qty. (Base)"; Rec."Qty. (Base)")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = false;
                    }
                    field(Comment; Rec.Comment)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }

            part(SubInterQCResult; "RV COA InterQCResult Subform")
            {
                Caption = 'Interal Specification';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No."), "COA Lot No." = field("Lot No.");
                UpdatePropagation = Both;
                Editable = false;
            }
            part(SubExterQCResult; "RV COA ExterQCResult Subform")
            {
                Caption = 'External Specification';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No."), "COA Lot No." = field("Lot No.");
                UpdatePropagation = Both;
                Editable = SubExterQCResultEditable;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("UpdateQALine")
            {
                Caption = 'Update QA Line';
                ApplicationArea = All;
                Image = UpdateShipment;
                Enabled = UpdateQALineEnable;

                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.UpdateQALine_Action();
                    CurrPage.Update();
                end;
            }
            action(QACheck)
            {
                Caption = 'QA Check';
                ApplicationArea = All;
                Image = Check;
                Enabled = QACheckEnable;
                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.QACheck_Action();
                end;
            }
            action(COAApprove)
            {
                Caption = 'COA Approve';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QAApproveEnable;
                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.COAApprove_Action();
                end;
            }
            action(COAReject)
            {
                Caption = 'COA Reject';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QARejectEnable;
                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.COAReject_Action();
                end;
            }
            action(COAReverse)
            {
                Caption = 'COA Reverse';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QAReverseEnable;
                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.COAReverse_Action();
                end;
            }
            action(COAPrint)
            {
                Caption = 'COA Print';
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                begin
                    CurrPage.SubCOACard.Page.COAPrint_Action();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("UpdateQALine_Promoted"; "UpdateQALine")
                {
                }
                actionref("ExternalSpecCheck_Promoted"; "QACheck")
                {
                }
                actionref("COAApprove_Promoted"; "COAApprove")
                {
                }
                actionref("COAReject_Promoted"; "COAReject")
                {
                }
                actionref("COAReverse_Promoted"; "COAReverse")
                {
                }
                actionref("COAPrint_Promoted"; "COAPrint")
                {
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //SetQAEnable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, QAReverseEnable,
            SubCOACardEditable, SubExterQCResultEditable, SubInyResultEditable);
    end;

    trigger OnAfterGetRecord()
    begin
        //SetQAEnable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, QAReverseEnable,
            SubCOACardEditable, SubExterQCResultEditable, SubInyResultEditable);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        QAHeader: Record "RV QA Header";
    begin
        if QAHeader.Get(Rec."COA No.") then begin
            if QAHeader."QA Status" <> QAHeader."QA Status"::Analyzing then begin
                Error('You cannot delete when the status is checked or Approved or Rejected.');
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        QAHeader: Record "RV QA Header";
    begin
        if QAHeader.Get(Rec."COA No.") then begin
            if QAHeader."QA Status" <> QAHeader."QA Status"::Analyzing then begin
                Error('You cannot insert when the status is checked or Approved or Rejected.');
            end;
        end;

        //SetQAEnable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, QAReverseEnable,
            SubCOACardEditable, SubExterQCResultEditable, SubInyResultEditable);
    end;

    trigger OnOpenPage()
    begin
        CurrentCOANo := Rec."COA No.";
        //SetQAEnable
        Rec.SetQAEnable(UpdateQALineEnable, QACheckEnable, QAApproveEnable, QARejectEnable, QAReverseEnable,
            SubCOACardEditable, SubExterQCResultEditable, SubInyResultEditable);
    end;

    var
        CalcWhseAdjmt: Report "Calculate Whse. Adjustment";
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ClientTypeManagement: Codeunit "Client Type Management";
        ItemJournalErrorsMgt: Codeunit "Item Journal Errors Mgt.";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[100];

        CurrentCOANo: Code[10];


        UpdateQALineEnable: Boolean;
        QACheckEnable: Boolean;
        QAApproveEnable: Boolean;
        QARejectEnable: Boolean;
        QAReverseEnable: Boolean;


        //ShipmentLotNoEditable: Boolean;
        SubCOACardEditable: Boolean;
        //SubInterQCResultEditable: Boolean;
        SubExterQCResultEditable: Boolean;
        SubInyResultEditable: Boolean;




    procedure SetName(CurrentCOANo: Code[10]; var RVQAShipmentLotNo: Record "RV QA Shipment Lot No.")
    begin
        RVQAShipmentLotNo.FilterGroup := 2;
        RVQAShipmentLotNo.SetRange("COA No.", CurrentCOANo);
        RVQAShipmentLotNo.FilterGroup := 0;
        if RVQAShipmentLotNo.Find('-') then;
    end;


}

