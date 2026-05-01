/// <summary>
/// PageExtension RV_Customer Card (ID 50900) extends "Customer Card"
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
pageextension 50900 "RV Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addlast(Invoicing)
        {
            field("RV_Charge Type"; Rec."RV_Charge Type")
            {
                Caption = 'Charge Type';
                ApplicationArea = all;
            }
        }

        addlast(General)
        {
            field("RV_Customer Type"; Rec."RV_Customer Type")
            {
                ApplicationArea = All;
                Description = 'FDD024';
            }
        }
    }

    actions
    {
        modify("Report Statement")
        {
            Description = 'FDD024';

            trigger OnBeforeAction()
            var
                Cust: Record Customer;
                RVCustRpt: Report "RV Cust Statement";
                DesignTimeRptSelect: Codeunit "Design-time Report Selection";
            begin
                if Rec."RV_Customer Type" = "RV Customer Type"::"Overseas Customer" then
                    DesignTimeRptSelect.SetSelectedLayout('StandardStatementOversea.rdlc')
                else
                    DesignTimeRptSelect.SetSelectedLayout('StandardStatementLocal.rdlc');

                Cust.Reset();
                CurrPage.SetSelectionFilter(Cust);
                if Cust.FindSet() and (Cust.Count > 1) then Error('Need select only one customer.');
                RVCustRpt.SetTableView(Cust);
                RVCustRpt.RunModal();
                Error('');//Do not execute the BC Standard Aciton.
            end;

        }
    }
}
