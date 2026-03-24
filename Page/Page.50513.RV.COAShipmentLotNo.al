/// <summary>
/// Page RV COA ShipmentLotNo (ID 50513)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50513 "RV COA ShipmentLotNo"
{

    AutoSplitKey = true;
    Caption = 'COA';
    DelayedInsert = true;
    //PageType = Worksheet;
    //PageType = Document;
    PageType = List;
    SaveValues = true;
    SourceTable = "RV QA Shipment Lot No.";
    DataCaptionFields = "COA No.";

    layout
    {
        area(content)
        {
            /* 
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                    //SetControlAppearanceFromBatch();
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }


            
            group(Control22)
            {
                ShowCaption = false;
                fixed(Control1900669001)
                {
                    ShowCaption = false;
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription; ItemDescription)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the item.';
                        }
                    }
                }
            }
            */

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
                    }
                    field("COA Lot Line No."; Rec."COA Lot Line No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Lot No."; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ApplicationArea = All;
                    }
                    field(UOM; Rec.UOM)
                    {
                        ApplicationArea = All;
                    }
                    field("Container No."; Rec."Container No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Manufacturing Date"; Rec."Manufacturing Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Expire Date"; Rec."Expire Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Sales Order No."; Rec."Sales Order No.")
                    {
                        ApplicationArea = All;
                    }
                    field("QA Status"; Rec."QA Status")
                    {
                        ApplicationArea = All;
                    }
                    field("Qty. (Base)"; Rec."Qty. (Base)")
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
            }


            part(SubInterQCResult; "RV COA InterQCResult Subform")
            {
                Caption = 'Interal Specification';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No."), "COA Lot Line No." = field("COA Lot Line No.");
                UpdatePropagation = Both;
            }
            part(SubExterQCResult; "RV COA ExterQCResult Subform")
            {
                Caption = 'External Specification';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No."), "COA Lot Line No." = field("COA Lot Line No.");
                UpdatePropagation = Both;
            }
            part(SubInyResult; "RV COA Iny. Result Subform")
            {
                Caption = 'Inventory processing';
                ApplicationArea = All;
                SubPageLink = "COA No." = field("COA No."), "COA Lot Line No." = field("COA Lot Line No.");
                UpdatePropagation = Both;
            }
        }

    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //ItemJnlMgt.GetItem(Rec."Item No.", ItemDescription);

    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnDeleteRecord(): Boolean
    var

    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnOpenPage()
    var

    begin


        //OpenJournal();
        CurrentCOANo := Rec."COA No.";

        //SetName(CurrentCOANo);
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




    procedure SetName(CurrentCOANo: Code[10]; var RVQAShipmentLotNo: Record "RV QA Shipment Lot No.")
    begin
        RVQAShipmentLotNo.FilterGroup := 2;
        RVQAShipmentLotNo.SetRange("COA No.", CurrentCOANo);
        RVQAShipmentLotNo.FilterGroup := 0;
        if RVQAShipmentLotNo.Find('-') then;
    end;


    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        //ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        //SetControlAppearanceFromBatch();
        CurrPage.Update(false);
    end;

    local procedure OpenJournal()
    var
        JnlSelected: Boolean;
    begin

        //QAMgt.OpenJnl(CurrentJnlBatchName, Rec);


    end;



}

