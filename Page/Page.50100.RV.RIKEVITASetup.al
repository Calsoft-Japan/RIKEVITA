/// <summary>
/// Page RIKEVITA Setup (ID 50100).
/// COMMON 2026/02/23: New. (Stephen)
/// FDD008 2026/03/15: New field "Stuffing Date Calculation". (Liuyang)
/// FDD009 2026/04/29: Charge Allocation fields Added. (Shawn)
/// FDD021 2026/05/11: Bank Information fields Added. (Bobby)
/// FDD028 2026/05/17: Item Trace fields Added. (Shawn)
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

                field("Calc. Item No."; Rec."Calc. Item No.")
                {
                    Description = 'FDD100';
                    ApplicationArea = All;
                }
                field("ILE Last Entry No."; Rec."ILE Last Entry No.")
                {
                    Description = 'FDD100';
                    ApplicationArea = All;
                }
                field("VE Last Entry No."; Rec."VE Last Entry No.")
                {
                    Description = 'FDD100';
                    ApplicationArea = All;
                }
                field("Start Date (Item Trace)"; Rec."Start Date (Item Trace)")
                {
                    Description = 'FDD028';
                    ApplicationArea = All;
                }
                field("End Date (Item Trace)"; Rec."End Date (Item Trace)")
                {
                    Description = 'FDD028';
                    ApplicationArea = All;
                }
                field("Item No. (Item Trace)"; Rec."Item No. (Item Trace)")
                {
                    Description = 'FDD028';
                    ApplicationArea = All;
                }
            }
            group(BankInformation)
            {
                Caption = 'Bank Information';
                field("USD Bank Name"; Rec."USD Bank Name")
                {
                    Caption = 'USD Bank Name';
                    Description = 'FDD021';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("USD Bank Branch No."; Rec."USD Bank Branch No.")
                {
                    Caption = 'USD Bank Branch No.';
                    Description = 'FDD021';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("USD Bank Account No."; Rec."USD Bank Account No.")
                {
                    Caption = 'USD Bank Account No.';
                    Description = 'FDD021';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    Caption = 'ID No.';
                    Description = 'FDD021';
                    ApplicationArea = All;
                }
                field("MYR Bank Name"; Rec."MYR Bank Name")
                {
                    Caption = 'MYR Bank Name';
                    Description = 'FDD021';
                    ApplicationArea = All;
                }
                field("MYR Bank Branch No."; Rec."MYR Bank Branch No.")
                {
                    Caption = 'MYR Bank Branch No.';
                    Description = 'FDD021';
                    ApplicationArea = All;
                }
                field("MYR Bank Account No."; Rec."MYR Bank Account No.")
                {
                    Caption = 'MYR Bank Account No.';
                    Description = 'FDD021';
                    ApplicationArea = All;
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

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MUFG PIC 1");
                        end;
                    }
                    field("MUFG PIC 2"; Rec."MUFG PIC 2")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MUFG PIC 2");
                        end;
                    }
                    field("MUFG PIC 3"; Rec."MUFG PIC 3")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MUFG PIC 3");
                        end;
                    }
                }

                group(MayBank)
                {
                    ShowCaption = false;
                    field("MayBank PIC 1"; Rec."MayBank PIC 1")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MayBank PIC 1");
                        end;
                    }
                    field("MayBank PIC 2"; Rec."MayBank PIC 2")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MayBank PIC 2");
                        end;
                    }
                    field("MayBank PIC 3"; Rec."MayBank PIC 3")
                    {
                        Description = 'FDD017';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateEmailAddress(Rec."MayBank PIC 3");
                        end;
                    }
                }
            }

            group(ChargeCalculation)
            {
                Caption = 'Charge Calculation';
                field("No. Series for Chg. Calc."; Rec."No. Series for Chg. Calc.")
                {
                    Caption = 'No. Series for Chg. Calc.';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("Chg. Calc. UOM (KG)"; Rec."Chg. Calc. UOM (KG)")
                {
                    Caption = 'Chg. Calc. UOM (KG)';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("01-COO"; Rec."01-COO")
                {
                    Caption = '01-COO';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("02-FORWARDING"; Rec."02-FORWARDING")
                {
                    Caption = '02-FORWARDING';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("03-FUMIGATION"; Rec."03-FUMIGATION")
                {
                    Caption = '03-FUMIGATION';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("04-HEALTH"; Rec."04-HEALTH")
                {
                    Caption = '04-HEALTH';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("05-PALLETIZING"; Rec."05-PALLETIZING")
                {
                    Caption = '05-PALLETIZING';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("06-PHYTO"; Rec."06-PHYTO")
                {
                    Caption = '06-PHYTO';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("07-STUFFING"; Rec."07-STUFFING")
                {
                    Caption = '07-STUFFING';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("08-TRANSPORT"; Rec."08-TRANSPORT")
                {
                    Caption = '08-TRANSPORT';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("09-REACH"; Rec."09-REACH")
                {
                    Caption = '09-REACH';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("10-Label"; Rec."10-Label")
                {
                    Caption = '10-Label';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("11-OF"; Rec."11-OF")
                {
                    Caption = '11-OF';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("99-OTHERS"; Rec."99-OTHERS")
                {
                    Caption = '99-OTHERS';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("FREIGHT"; Rec."Freight Charge Item No")
                {
                    Caption = 'FREIGHT';
                    Description = 'FDD009';
                    ApplicationArea = All;
                }
                field("HTP Adjustment"; Rec."HTP Adjustment")
                {
                    Caption = 'HTP Adjustment';
                    Description = 'FDD009';
                    ApplicationArea = All;
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

    procedure ValidateEmailAddress(EmailToValidate: Text)
    var
        MailManagement: Codeunit "Mail Management";
    begin
        if EmailToValidate = '' then
            exit; // Or throw an error, depending on if the field is mandatory

        // This will automatically throw an error if the format is invalid
        MailManagement.CheckValidEmailAddresses(EmailToValidate);
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
