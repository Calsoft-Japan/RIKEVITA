/// <summary>
/// Page RV MPS Rescheduling Batch (ID 50603)
/// FDD011 2026/02/23: New. (stephen)
/// </summary>
page 50603 "RV MPS Rescheduling Batch"
{
    Caption = 'RV MPS Rescheduling Batch';
    PageType = List;
    SourceTable = "RV MPS Rescheduling Batch";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        MPSReschedulingMgt.OpenJnlBatch(Rec);
    end;

    var
        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
}
