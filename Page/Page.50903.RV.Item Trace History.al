/// <summary>
/// Page RV Item Trace History (ID 50903)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
page 50903 "RV Item Trace History"
{
    ApplicationArea = All;
    Caption = 'Item Trace History';
    PageType = List;
    SourceTable = "RV Item Trace History";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {

                }
                field("Start Date"; Rec."Start Date")
                {

                }
                field("End Date"; Rec."End Date")
                {

                }
                field("Collected On"; Rec."Collected On")
                {

                }

            }
        }
    }
}
