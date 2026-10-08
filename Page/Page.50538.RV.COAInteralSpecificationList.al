/// <summary>
/// Page COA Internal Specification List (ID 50538)
/// FDD039 2026/10/05: New. (Mike)
/// </summary>
page 50538 "COA Internal Spec. List"
{
    Caption = 'COA Internal Specification List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = lists;
    SourceTable = "RV QA Internal QC Results";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("COA Lot No."; Rec."COA Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC Internal Spec. Line No."; Rec."QC Internal Spec. Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Value"; Rec."QC Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alpha. Min"; Rec."Alpha. Min")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alpha. Max"; Rec."Alpha. Max")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked Remark"; Rec."QC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    var

}