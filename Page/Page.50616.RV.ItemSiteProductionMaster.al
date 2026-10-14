page 50110 "RV Item Site Production Master"
{
    ApplicationArea = All;
    Caption = 'Item Site Production Master';
    PageType = List;
    SourceTable = "RV Item Site Production Master";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Site Code"; Rec."Site Code")
                {
                    ApplicationArea = All;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                }
                field("BOM No."; Rec."BOM No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}