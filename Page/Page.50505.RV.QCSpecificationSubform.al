/// <summary>
/// PAge RV QC Specification Subform (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50505 "RV QC Specification Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Specification Line";
    //AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    Visible = false;
                    Editable = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Target Value ib Base UM"; Rec."Target Value ib Base UM")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}