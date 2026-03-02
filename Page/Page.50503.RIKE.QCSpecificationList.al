/// <summary>
/// Page RIKE QC Specification List (ID 50503)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50503 "RIKE QC Specification List"
{
    Caption = 'QC Specification List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RIKE QC Specification";
    CardPageId = "RIKE QC Specification Card";

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                }
                field("QC Specification Description"; Rec."QC Specification Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
}