/// <summary>
/// Page RV Prod. Results Journal Batch (ID 50600)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
page 50600 "RV Prod. Results Journal Bat"
{
    Caption = 'RV Prod. Results Journal Batch';
    PageType = List;
    SourceTable = "RV Prod. Results Journal Bat";

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
        RVProdResultsMgt.OpenJnlBatch(Rec);
    end;

    var
        RVProdResultsMgt: Codeunit "RV Prod. Results Management";
}
