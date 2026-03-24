/// <summary>
/// Page RV QC Specification Card (ID 50504)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50504 "RV QC Specification Card"
{
    Caption = 'QC Specification';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "RV QC Specification";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                }
                field("QC Specification Description"; Rec."QC Specification Description")
                {
                    ApplicationArea = All;
                }
            }

            part(SubBom; "RV QC Specification Subform")
            {
                Caption = 'Line';
                ApplicationArea = All;
                SubPageLink = "QC Specification Name" = field("QC Specification Name");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    trigger OnOpenPage()
    var

    begin

    end;


    var

}