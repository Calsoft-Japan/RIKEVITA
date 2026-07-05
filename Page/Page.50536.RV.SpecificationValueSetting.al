/// <summary>
/// Page RV Specification Value Setting (ID 50536).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50536 "RV Specification Value Setting"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Specification Value Setting';
    SourceTable = "RV Specification Value Setting";
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    Editable = false;
                    Visible = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    Editable = false;
                    Visible = false;
                }
                field("Table Value Name"; Rec."Value Table Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("List Value"; Rec."List Value")
                {
                    ApplicationArea = All;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}