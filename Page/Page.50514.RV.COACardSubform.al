/// <summary>
/// Page RV COA Card Subform (ID 50514)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50514 "RV COA Card Subform"
{
    Caption = 'RV COA Card Subform';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QA Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if (Rec."COA No." = '') then begin
                            RIKEVITASetup.Get();
                            RIKEVITASetup.TestField("COA No. Nos.");
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."COA No. Nos.", Rec."COA No.") then begin
                                Rec."COA No." := NoSeries.GetNextNo(RIKEVITASetup."COA No. Nos.");
                            end;
                        end;
                    end;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type QA")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec."Order No." := '';
                        Rec."Item No." := '';

                        //ClearHeaderData
                        Rec.ClearHeaderData;

                        //clear ShipmentLotNo
                        Rec.ClearShipmentLotNo;
                        CurrPage.Update();
                    end;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PostedWhShipLine: Record "Posted Whse. Shipment Line";
                        WhShipline: Record "Warehouse Shipment line";
                        RefOrderTypeQA: Enum "RV Ref. Order Type QA";
                    begin

                        if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Posted Whse. Shipment" then begin
                            if Page.RunModal(Page::"Posted Whse. Shipment Lines", PostedWhShipLine) <> Action::LookupOK then
                                exit(false);
                            Text := PostedWhShipLine."No.";
                            Rec."Item No." := PostedWhShipLine."Item No.";
                            Rec."Line No." := PostedWhShipLine."Line No.";
                            //CurrPage.Update(true);
                            exit(true);


                        end else if Rec."Ref. Order Type QA" = RefOrderTypeQA::"Warehouse Shipment" then begin
                            if Page.RunModal(Page::"Whse. Shipment Lines", WhShipline) <> Action::LookupOK then
                                exit(false);
                            Text := WhShipline."No.";
                            Rec."Item No." := WhShipline."Item No.";
                            Rec."Line No." := WhShipline."Line No.";
                            CurrPage.Update(true);
                            exit(true);
                        end;

                    end;

                    trigger OnValidate()
                    begin
                        //ClearHeaderData
                        Rec.ClearHeaderData;

                        //clear ShipmentLotNo
                        Rec.ClearShipmentLotNo;

                        Rec.ValidateOrderNo();

                        CurrPage.Update();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin

                        //ClearHeaderData
                        //Rec.ClearHeaderData();

                        //clear ShipmentLotNo
                        //Rec.ClearShipmentLotNo();

                        //setData();

                        //ValidateItemNo
                        //Rec.ValidateItemNo();
                        //CurrPage.Update(true);
                    end;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Customer No."; Rec."Ship-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Mark"; Rec."Mark")
                {
                    ApplicationArea = All;
                }
                field("QA Status"; Rec."QA Status")
                {
                    ApplicationArea = All;
                }
                field("QA Checked By"; Rec."QA Checked By")
                {
                    ApplicationArea = All;
                }
                field("QA Checked Remark"; Rec."QA Checked Remark")
                {
                    ApplicationArea = All;
                }
                field("QA Approved By"; Rec."QA Approved By")
                {
                    ApplicationArea = All;
                }
                field("QA Approved Remark"; Rec."QA Approved Remark")
                {
                    ApplicationArea = All;
                }
                field("COA Date"; Rec."COA Date")
                {
                    ApplicationArea = All;
                }
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

                trigger OnAction()
                begin
                    Message('Update QA Line');
                end;
            }
            action("ExternalQCSpecCheck")
            {
                Caption = 'External QC Spec. Check';
                ApplicationArea = All;
                Image = UpdateShipment;

                trigger OnAction()
                begin
                    Message('External QC Spec. Check');
                end;
            }
            action(COAApprove)
            {
                Caption = 'COA Approve';
                ApplicationArea = All;
                Image = Approval;

                trigger OnAction()
                begin
                    Message('COA Approve');
                end;
            }
            action(COAReject)
            {
                Caption = 'COA Reject';
                ApplicationArea = All;
                Image = Approval;

                trigger OnAction()
                begin
                    Message('COA Reject');
                end;
            }
            action(COAPrint)
            {
                Caption = 'COA Print';
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    QAHeader: Record "RV QA Header";
                begin
                    CurrPage.SetSelectionFilter(QAHeader);
                    REPORT.RUN(Report::"RV_COA Report", true, false, QAHeader);
                end;
            }
        }

    }

    trigger OnOpenPage()
    var

    begin

    end;


    var
        PO: Page "Purchase Order";
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
}