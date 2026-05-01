/// <summary>
/// PageExtension RV_Customer Card (ID 50901) extends "Customer List"
/// FDD009 2026/04/29: New. (Shawn)
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
        modify("Statement")
        {
            Description = 'FDD024';

            trigger OnBeforeAction()
            var
                RVCustRpt: Report "RV Cust Statement";
                DesignTimeRptSelect: Codeunit "Design-time Report Selection";
            begin
                if Rec."RV_Customer Type" = "RV Customer Type"::"Overseas Customer" then
                    DesignTimeRptSelect.SetSelectedLayout('StandardStatementOversea.rdlc')
                else
                    DesignTimeRptSelect.SetSelectedLayout('StandardStatementLocal.rdlc');

                RVCustRpt.SetTableView(Rec);
                RVCustRpt.RunModal();
                Error('');//Do not execute the BC Standard Aciton.
            end;

        }
    }
}
