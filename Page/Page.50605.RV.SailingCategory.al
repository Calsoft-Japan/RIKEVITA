/// <summary>
/// Page RV MPS Holding Category (ID 50605)
/// FDD006 2026/02/23: New. (stephen)
/// </summary>
page 50605 "RV Holding Category"
{
    ApplicationArea = All;
    Caption = 'Holding Category';
    PageType = List;
    SourceTable = "RV Holding Category";
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
                field("Holding Period Calculation"; Rec."Holding Period Calculation")
                {
                    ToolTip = 'Specifies the value of the Holding Period Calculation field.', Comment = '%';
                }
            }
        }
    }
}
