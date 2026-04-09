/// <summary>
/// Page RV Standard Remark(ID 50606)
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
page 50606 "RV Standard Remark"
{
    ApplicationArea = All;
    Caption = 'Standard Remark';
    PageType = List;
    SourceTable = "RV Standard Remark";
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
                field("Remark Type"; Rec."Remark Type")
                {
                    ToolTip = 'Specifies the value of the Remark Type field.', Comment = '%';
                }
                field(Remark; Rec.Remark)
                {
                    ToolTip = 'Specifies the value of the Remark field.', Comment = '%';
                }
            }
        }
    }
}
