/// <summary>
/// Page RV NC List (ID 50540)
/// FDD039 2026/10/09: New. (Mike)
/// </summary>
page 50540 "RV NC List"
{
    Caption = 'NC List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RV NC Header";
    CardPageId = "RV NC Card";
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC No."; Rec."QC No.")
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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("location Code"; Rec."Stock Transfer to Bin")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Inspect Bin Code"; Rec."Inspect Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Storage Bin Code"; Rec."Stock Transfer to Bin")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC location Code"; Rec."NC location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Analyzed by"; Rec."QC Analyzed by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Comment"; Rec."QC Comment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked By"; Rec."QC Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked Remark"; Rec."QC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Rejected by"; Rec."QC Rejected by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Rejected Remark"; Rec."QC Rejected Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Analyzed by"; Rec."NC Analyzed by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Remark"; Rec."NC Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Checked By"; Rec."NC Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Checked Remark"; Rec."NC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Checked date"; Rec."NC Checked date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NC Approved By"; Rec."NC Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Approved Remark"; Rec."NC Approved Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Approved date"; Rec."NC Approved date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Status"; Rec."NC Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("New NC")
            {
                ApplicationArea = All;
                Caption = 'New NC';
                Image = OpenJournal;
                runObject = Report "RV Create NC Header from QC";
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("New NC_Promoted"; "New NC")
                {
                }
            }
        }
    }
}