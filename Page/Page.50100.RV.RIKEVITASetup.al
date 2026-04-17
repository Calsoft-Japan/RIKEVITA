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

    actions
    {
        area(Processing)
        {
            group(ExportExcel)
            {
                Description = 'FDD017';
                Caption = 'Upload Payment Template';
                Image = Template;
                Visible = false;
                action(UploadDomesticTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Upload Domestic Template';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ExpType: Option Domestic,Jompay,GIRO;
                    begin
                        UploadBankTemplateToSetup(ExpType::Domestic);
                        CurrPage.Update(false); // Refresh the page to update the "Template Exists" boolean
                    end;
                }

                action(UploadJompayTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Upload Jompay Template';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ExpType: Option Domestic,Jompay,GIRO;
                    begin
                        UploadBankTemplateToSetup(ExpType::Jompay);
                        CurrPage.Update(false); // Refresh the page to update the "Template Exists" boolean
                    end;
                }

                action(UploadGIROTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Upload GIRO Template';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ExpType: Option Domestic,Jompay,GIRO;
                    begin
                        UploadBankTemplateToSetup(ExpType::GIRO);
                        CurrPage.Update(false); // Refresh the page to update the "Template Exists" boolean
                    end;
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

    procedure UploadBankTemplateToSetup(ExpType: Option Domestic,Jompay,GIRO)
    var
        FileInStream: InStream;
        BlobOutStream: OutStream;
        FileName: Text;
        UploadMsg: Label 'Please select the Bank Excel Template to upload';
        FilterTxt: Label 'Excel Files (*.xlsx)|*.xlsx';
    begin
        if UploadIntoStream(UploadMsg, '', FilterTxt, FileName, FileInStream) then begin

            case ExpType of
                ExpType::Domestic:
                    begin
                        Clear(Rec."Demostic Excel Template");
                        Rec."Demostic Excel Template".CreateOutStream(BlobOutStream);
                    end;
                ExpType::Jompay:
                    begin
                        Clear(Rec."Jompay Excel Template");
                        Rec."Jompay Excel Template".CreateOutStream(BlobOutStream);
                    end;
                ExpType::GIRO:
                    begin
                        Clear(Rec."GIRO Excel Template");
                        Rec."GIRO Excel Template".CreateOutStream(BlobOutStream);
                    end;
            end;

            CopyStream(BlobOutStream, FileInStream);
            Rec.Modify(true);

            Message('Template %1 was successfully uploaded and saved.', FileName);
        end else
            Message('The upload was cancelled.');
    end;
}
