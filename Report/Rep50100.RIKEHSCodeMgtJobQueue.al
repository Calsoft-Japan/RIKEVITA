/// <summary>
/// Report RIKE HS Code Mgt JobQueue (ID 50100).
/// FDD030 2026/03/09: New. (Liuyang)
/// </summary>
report 50100 "RIKE HS Code Mgt JobQueue"
{
    ApplicationArea = All;
    Caption = 'RIKE HS Code Mgt JobQueue';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(RV_HSCodeManagement; "RV_HS Code Management")
        {
            trigger OnAfterGetRecord()
            begin
                if NotificationCalculation <> '' then begin
                    if "Expired Date" <= CalcDate(NotificationCalculation, Today()) then begin
                        RV_HSCodeExpir := true;
                    end;
                end else
                    RV_HSCodeExpir := true;
            end;

            trigger OnPostDataItem()
            begin
                if RV_HSCodeExpir and (NotifyEmailAddress <> '') then begin
                    SentMails(NotifyEmailAddress);
                end;
            end;
        }
    }

    trigger OnPreReport()
    begin
        RVSteup.Reset();
        if RVSteup.FindFirst() then begin
            NotifyEmailAddress := RVSteup."Notify-to Email Address";
            NotificationCalculation := RVSteup."Notification Calculation";
        end;
    end;

    [TryFunction]
    local procedure SentMails(EMailAddr: Text)
    var
        MailingList: List of [Text];
        CU_Email: Codeunit Email;
        CU_EmailMessage: Codeunit "Email Message";
        CuEmailAccount: Codeunit "Email Account";
        TempCuEmailAccount: Record "Email Account" temporary;
        SubjectLbl: Label 'HS Code Expiry Notification';
        BodyLblDeptHod: Label 'Some HS Codes are nearing expiration. Please check them on the HS Code Management page.<br>Environment: %1<br>Company: %2<br> <br> <br><a href="%3">HS Code Management</a>';
        PRDLink, AppLink : Text;
        EnvInfo: CodeUnit "Environment Information";
    begin
        Clear(AppLink);

        MailingList.Add(EMailAddr);

        if MailingList.Count = 0 then exit;

        PRDLink := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"RV_HS Code Management");//, RV_HSCode, true);
        //AppLink := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Job Queue Log Entries", JobQueueLog, true);

        if MailingList.Count <> 0 then begin
            Clear(CU_EmailMessage);
            CU_EmailMessage.Create(MailingList,
                                    SubjectLbl,
                                    StrSubstNo(BodyLblDeptHod, EnvInfo.GetEnvironmentName(), CompanyName, PRDLink), true);


            CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
            TempCuEmailAccount.Reset;
            TempCuEmailAccount.SetRange(Name, 'Current User');
            if TempCuEmailAccount.FindFirst() then
                CU_Email.Send(CU_EmailMessage, TempCuEmailAccount)
            else
                CU_Email.Send(CU_EmailMessage);
        end;
    end;

    var
        RV_HSCodeExpir: Boolean;
        NotifyEmailAddress: Text;
        NotificationCalculation: Text;
        RVSteup: Record "RIKEVITA Setup";
}
