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
                field("QC No. Nos."; Rec."IQC No. Nos.")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
                }
                field("PQC No. Nos."; Rec."PQC No. Nos.")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
                }
                field("FQC No. Nos."; Rec."FQC No. Nos.")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
                }
                field("COA No. Nos."; Rec."COA No. Nos.")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
                }
                field("FP Inventory Posting Group"; Rec."FP Inventory Posting Group")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
                }
                field("WIP Inventory Posting Group"; Rec."WIP Inventory Posting Group")
                {
                    ApplicationArea = All;
                    Description = 'FDD039';
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
