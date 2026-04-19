/// <summary>
/// report RV Export Payment Inv Excel (ID 50101) 
/// FDD017 2026/04/13: New. (Liuyang)
/// </summary>
report 50101 "RV Export Payment Inv Excel"
{
    Caption = 'RV Export Payment Inv Excel';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    //DefaultRenderingLayout = Domestic;

    dataset
    {
        dataitem(PaymentJournal; "Gen. Journal Line")
        {
            column(PaymentMode; PaymentMode)
            { }
            column(ValueDate; ValueDate)
            { }
            column(CustomerReferenceNumber; CustomerReferenceNumber)
            { }
            column(TransactionAmountRM; TransactionAmountRM)
            { }
            column(CreditAccountNumber; CreditAccountNumber)
            { }
            column(BeneficiaryName1; BeneficiaryName1)
            { }
            column(BeneficiaryName2; BeneficiaryName2)
            { }
            column(BeneficiaryName3; BeneficiaryName3)
            { }
            column(NewNIRC; NewNIRC)
            { }
            column(OldNIRC; OldNIRC)
            { }
            column(BusinessRegistrationNo; BusinessRegistrationNo)
            { }
            column(Police_Army_Passport_ID; Police_Army_Passport_ID)
            { }
            column(BeneficiaryBankCode; BeneficiaryBankCode)
            { }
            column(Email; Email)
            { }
            column(AdviceDetail; AdviceDetail)
            { }
            column(DebitDescription; DebitDescription)
            { }
            column(CreditDescription; CreditDescription)
            { }
            column(JointName; JointName)
            { }
            column(JointNewIDNo; JointNewIDNo)
            { }
            column(JointOldIDNo; JointOldIDNo)
            { }
            column(JointBusinessRegNo; JointBusinessRegNo)
            { }
            column(Joint_Police_Army_PassportID; Joint_Police_Army_PassportID)
            { }
            column(PurposeofTransfer; PurposeofTransfer)
            { }
            column(OtherPurposeofTransfer; OtherPurposeofTransfer)
            { }
            column(RentasInstructiontoBank; RentasInstructiontoBank)
            { }
            column(Email2; Email2)
            { }
            column(Email3; Email3)
            { }
            column(J_BillerCode; J_BillerCode)
            { }
            column(J_Reference1; J_Reference1)
            { }
            column(J_Reference2; J_Reference2)
            { }
            column(G_No; G_No)
            { }
            column(G_AccNo; G_AccNo)
            { }
            column(G_Name; G_Name)
            { }
            column(G_SegmentCode; G_SegmentCode)
            { }
            column(G_BeneBank; G_BeneBank)
            { }
            column(G_Bene_AccNo; G_Bene_AccNo)
            { }
            column(G_BeneName; G_BeneName)
            { }
            column(G_OtherPaymentDetails; G_OtherPaymentDetails)
            { }
            column(G_BeneID; G_BeneID)
            { }
            column(G_RecipientReference; G_RecipientReference)
            { }
            column(G_NewIC; G_NewIC)
            { }
            column(G_OldIC; G_OldIC)
            { }
            column(G_BusinessNo; G_BusinessNo)
            { }
            column(G_Police_ArmyID_Passport; G_Police_ArmyID_Passport)
            { }
            column(G_EPF_BatchDate; G_EPF_BatchDate)
            { }
            column(G_EPFNo; G_EPFNo)
            { }
            column(G_PayerID; G_PayerID)
            { }
            column(G_ApplicantEmail; G_ApplicantEmail)
            { }
            column(G_BeneficiaryEmail; G_BeneficiaryEmail)
            { }
            column(G_InvoiceRef; G_InvoiceRef)
            { }
            column(G_InvoiceDesc; G_InvoiceDesc)
            { }
            column(G_InvoiceDate; G_InvoiceDate)
            { }
            column(G_PaymentAmount; G_PaymentAmount)
            { }

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    /* rendering
    {
        layout(Domestic)
        {
            Type = Excel;
            LayoutFile = '.\ReportLayout\Domestic.xlsx';
        }
        layout(Jompay)
        {
            Type = Excel;
            LayoutFile = '.\ReportLayout\Jompay.xlsx';
        }
        layout(GIRO)
        {
            Type = Excel;
            LayoutFile = '.\ReportLayout\GIRO.xlsx';
        }
    } */

    trigger OnPreReport()
    begin
        if (JournalTemp = '') or (JournalBatch = '') then
            Error('Nothing to export.');

        PaymentJournal.SetRange("Journal Template Name", JournalTemp);
        PaymentJournal.SetRange("Journal Batch Name", JournalBatch);
    end;

    var
        ExpTye: Option Domestic,Jompay,GIRO;
        JournalTemp, JournalBatch : Text;
        PaymentMode, ValueDate, CustomerReferenceNumber, TransactionAmountRM, CreditAccountNumber, BeneficiaryName1, BeneficiaryName2, BeneficiaryName3 : Text;
        NewNIRC, OldNIRC, BusinessRegistrationNo, Police_Army_Passport_ID, BeneficiaryBankCode, Email, AdviceDetail, DebitDescription, CreditDescription : Text;
        JointName, JointNewIDNo, JointOldIDNo, JointBusinessRegNo, Joint_Police_Army_PassportID, PurposeofTransfer, OtherPurposeofTransfer : Text;
        RentasInstructiontoBank, Email2, Email3 : Text;
        J_BillerCode, J_Reference1, J_Reference2 : Text;
        G_No, G_AccNo, G_Name, G_SegmentCode, G_BeneBank, G_Bene_AccNo, G_BeneName, G_OtherPaymentDetails, G_BeneID, G_RecipientReference : Text;
        G_NewIC, G_OldIC, G_BusinessNo, G_Police_ArmyID_Passport, G_EPF_BatchDate, G_EPFNo : Text;
        G_PayerID, G_ApplicantEmail, G_BeneficiaryEmail, G_InvoiceRef, G_InvoiceDesc, G_InvoiceDate, G_PaymentAmount : Text;

    procedure SetPaymentTempBatch(NewJournalTemp: Text; NewJournalBatch: Text)
    begin
        JournalTemp := NewJournalTemp;
        JournalBatch := NewJournalBatch;
    end;
}
