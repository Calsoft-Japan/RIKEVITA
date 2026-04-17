/// <summary>
/// Page RV PQC List (ID 50520)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50520 "RV PQC List"
{
    Caption = 'PQC List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RV QC Header";
    SourceTableView = WHERE("QC Type" = FILTER(PQC));
    CardPageId = "RV PQC Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Standard Type"; Rec."QC Standard Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Status"; Rec."QC Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked By"; Rec."QC Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Approved By"; Rec."QC Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tan No."; Rec."Tan No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
}