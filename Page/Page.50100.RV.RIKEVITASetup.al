/// <summary>
/// Page RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// FDD017 2026/04/14: New group EPayment. (Liuyang)
/// </summary>
page 50100 "RIKEVITA Setup"/// 
{
    ApplicationArea = All;
    Caption = 'RIKEVITA Setup';
    PageType = Card;

    UsageCategory = Administration;
    SourceTable = "RV RIKEVITA Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;

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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code used for Site validation.';
                }

            }

            group(EPayment)
            {
                Caption = 'Electronic Payment PIC Setup';
                field("Recipient Ref. Code"; Rec."Recipient Ref. Code")
                {
                    Description = 'FDD017';
                    ApplicationArea = All;
                }
                group(MUFG)
                {
                    ShowCaption = false;
                    field("MUFG PIC 1"; Rec."MUFG PIC 1")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
                    field("MUFG PIC 2"; Rec."MUFG PIC 2")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
                    field("MUFG PIC 3"; Rec."MUFG PIC 3")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
                }

                group(MayBank)
                {
                    ShowCaption = false;
                    field("MayBank PIC 1"; Rec."MayBank PIC 1")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
                    field("MayBank PIC 2"; Rec."MayBank PIC 2")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
                    field("MayBank PIC 3"; Rec."MayBank PIC 3")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;
                    }
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
