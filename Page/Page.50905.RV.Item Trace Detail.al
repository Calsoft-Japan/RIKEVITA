/// <summary>
/// Page RV Item Trace Detail (ID 50905)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
page 50905 "RV Item Trace Detail"
{
    ApplicationArea = All;
    Caption = 'Item Trace Details';
    PageType = List;
    SourceTable = "RV Item Trace Detail";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("History Entry No."; Rec."History Entry No.")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Gen. Bus. Posting Group "; Rec."Gen. Bus. Posting Group ")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("Base Unit of Measure Code"; Rec."Base Unit of Measure Code")
                {
                }
                field("Quantity (BUOM)"; Rec."Quantity (BUOM)")
                {
                }
                field("Quantity (KG)"; Rec."Quantity (KG)")
                {
                }
                field("Cost Amount (RM)"; Rec."Cost Amount (RM)")
                {
                }
                field("Item No. (FP)"; Rec."Item No. (FP)")
                {
                }
                field("VAT. Prod. Posting Group"; Rec."VAT. Prod. Posting Group")
                {
                }

            }
        }
    }
}
