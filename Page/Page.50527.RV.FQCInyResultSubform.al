/// <summary>
/// PAge RV FQC Iny. Result Subform Subform (ID 50527)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50527 "RV FQC Iny. Result Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Iny. Result Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Inventory Type"; Rec."Inventory Type")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
                field("Classification"; Rec."Classification")
                {
                    ApplicationArea = All;
                }
                field("Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
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