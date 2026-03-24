/// <summary>
/// PAge RV COA Iny. Result Subform (ID 50517)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50517 "RV COA Iny. Result Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QA Iny. Result Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("COA No."; Rec."COA No.")
                {
                    ApplicationArea = All;
                }
                field("COA Lot Line No."; Rec."COA Lot Line No.")
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