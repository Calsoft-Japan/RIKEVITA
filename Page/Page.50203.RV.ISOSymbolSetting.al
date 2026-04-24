/// <summary>
/// Page ISO Symbol Setting (ID 50203).
/// FDD019 2026/04/20: New. (Bobby.ji)
/// </summary>
page 50203 "ISO Symbol Setting"
{
    ApplicationArea = All;
    Caption = 'ISO Symbol Setting';
    PageType = ListPlus;
    UsageCategory = Lists;
    SourceTable = "RV Item Symbol Setting";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item Code"; Rec."Item Code")
                {
                    Caption = 'Item Code';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Symbol Display Packing List"; Rec."Symbol Display Packing List")
                {
                    Caption = 'Symbol Display Packing List';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
            }

        }
        area(FactBoxes)
        {
            part(ImagePart; "ISO Symbol Image FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Item Code" = FIELD("Item Code");
            }
        }
    }

}

