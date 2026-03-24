/// <summary>
/// Page RV COA Shipment Lot No. List (ID 50518)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50518 "RV COA Shipment Lot No. List"
{
    Caption = 'RV COA Shipment Lot No.';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RV QA Shipment Lot No.";
    //CardPageId = "RV COA Card";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("COA No. H"; Rec."COA No.")
                {
                    ApplicationArea = All;
                }
            }
            /*
            field("Ref. Order Type"; Rec."Ref. Order Type QA")
            {
                ApplicationArea = All;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
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
            */
            repeater(List)
            {
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

    var
}