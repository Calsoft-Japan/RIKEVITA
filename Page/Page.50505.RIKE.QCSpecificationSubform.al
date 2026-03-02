/// <summary>
/// PAge RIKE QC Specification Subform (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50505 "RIKE QC Specification Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RIKE QC Specification Line";
    //AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    Caption = 'QC Parameter Name';
                    NotBlank = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Caption = 'Value Table Type';
                }
                field("Target Value ib Base UM"; Rec."Target Value ib Base UM")
                {
                    ApplicationArea = All;
                    Caption = 'Target Value ib Base UM';
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