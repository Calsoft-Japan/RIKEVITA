/// <summary>
/// PageExtension RV Countries/Regions (ID 50616) extends "Countries/Regions"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50616 "RV_Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        addafter("ISO Numeric Code")
        {
            field("RV_Holding Category"; Rec."RV_Sailing Category Code")
            {
                ApplicationArea = All;
            }
            field("RV_Holding Period"; Rec."RV_Sailing Period")
            {
                ApplicationArea = All;
            }
        }
    }
}
