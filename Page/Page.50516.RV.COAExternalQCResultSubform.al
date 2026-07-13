/// <summary>
/// PAge RV RV COA ExterQCResult Subform (ID 50516)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50516 "RV COA ExterQCResult Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QA External QC Results";
    AutoSplitKey = true;
    InsertAllowed = false;
    DeleteAllowed = false;
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
                    Visible = false;
                }
                field("COA Lot No."; Rec."COA Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC External Spec. Line No."; Rec."QC External Spec. Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
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
                field("COA Value"; Rec."COA Value")
                {
                    ApplicationArea = All;
                }
                field("Differ From QC Vaule"; Rec."Differ From QC Vaule")
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
            }
        }
    }
}