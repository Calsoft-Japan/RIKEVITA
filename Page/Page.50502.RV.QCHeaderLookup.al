/// <summary>
/// Report RV QC Header Lookup (ID 50502)
/// FDD039 2026/10/19: New. (Mike)
/// </summary>
page 50502 "RV QC Header Lookup"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Header Lookup';
    PageType = List;
    SourceTable = "RV QC Header";
    SourceTableView = sorting("QC No.", "QC Type") where("QC Status" = const(Rejected));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type")
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
                field("QC Status"; Rec."QC Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
