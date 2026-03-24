/// <summary>
/// Page RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// </summary>
page 50100 "RIKEVITA Setup"
{
    ApplicationArea = All;
    Caption = 'RIKEVITA Setup';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "RIKEVITA Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;
    layout
    {
        area(Content)
        {
            group(General)
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

                field("Stuffing Date Calculation"; Rec."Stuffing Date Calculation")
                {
                    Caption = 'Stuffing Date Calculation';
                    Description = 'FDD008';
                    ApplicationArea = All;
                }
                field("ACC Site Analysis Code"; Rec."ACC Site Analysis Code")
                {
                    Description = 'FDD034';
                }
            }

        }
    }
}

