/// <summary>
/// Page RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// </summary>
page 50100 "RIKEVITA Setup"/// 
{
    ApplicationArea = All;
    Caption = 'RIKEVITA Setup';
    PageType = Card;
<<<<<<< HEAD:Page/Page.50100.RV.RIKEVITASetup.al
    SourceTable = "RIKEVITA Setup";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
=======
    UsageCategory = Administration;
    SourceTable = "RIKEVITA Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;
>>>>>>> f36c2aa0e364d2b308f2c125395705ef0b82b4b6:Page/Page.50100.RIKE.RIKEVITASetup.al
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("QC No. Nos."; Rec."QC No. Nos.")
                {
                    ApplicationArea = All;
                }
                field("COA No. Nos."; Rec."COA No. Nos.")
                {
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
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
