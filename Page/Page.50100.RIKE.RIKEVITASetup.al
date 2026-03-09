/// <summary>
/// Page RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// </summary>
page 50100 "RIKEVITA Setup"
{
    ApplicationArea = All;
    Caption = 'RIKEVITA Setup';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "RIKEVITA Setup";
    DeleteAllowed = true;
    InsertAllowed = true;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ToolTip = 'Specifies the value of the Primary Key field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Notification Calculation"; Rec."Notification Calculation")
                {
                    Caption = 'Notification Calculation';
                    ApplicationArea = All;
                }
                field("Notify-to Email Address"; Rec."Notify-to Email Address")
                {
                    Caption = 'Notify-to Email Address';
                    ApplicationArea = All;
                }
            }

        }
    }
}

