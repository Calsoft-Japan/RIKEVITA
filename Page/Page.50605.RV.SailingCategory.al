/// <summary>
/// Page RV MPS Sailing Category(ID 50605)
/// FDD006 2026/02/23: New. (stephen)
/// </summary>
page 50605 "RV Sailing Category"
{
    ApplicationArea = All;
    Caption = 'Sailing Category';
    PageType = List;
    SourceTable = "RV Sailing Category";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Sailing Period Calculation"; Rec."Sailing Period Calculation")
                {
                    ToolTip = 'Specifies the value of the Sailing Period Calculation field.', Comment = '%';
                }
            }
        }
    }
}
