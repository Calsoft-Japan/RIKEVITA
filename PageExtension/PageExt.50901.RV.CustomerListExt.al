/// <summary>
/// PageExtension RV_Customer Card (ID 50901) extends "Customer List"
/// FDD009 2026/04/29: New. (Shawn)
/// FDD024 2026/04/29: Liuyang
/// </summary>
pageextension 50901 "RV Customer List Ext" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("RV_Charge Type"; Rec."RV_Charge Type")
            {
                Caption = 'Charge Type';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Statement")
        {
            action(RVStatement)
            {
                Description = 'FDD024';
                ApplicationArea = All;
                Caption = 'Statement';
                Image = "Report";
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';

                trigger OnAction()
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
                end;
            }
        }
        modify("Statement")
        {
            Description = 'FDD024';
            Visible = false;
        }

        addlast(Category_Report)
        {
            actionref(RVStatement_Promoted; RVStatement)
            {
            }
        }
    }
}
