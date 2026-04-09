/// <summary>
/// PageExtension RV_Sales Order Subform (ID 50618) extends "Sales Order Subform"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50618 "RV_Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Shipment Date")
        {

            field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
            {
                ApplicationArea = All;
            }
            field("RV_ECR Required"; Rec."RV_ECR Required")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("RV_ECR Date"; Rec."RV_ECR Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(SelectMultiItems)
        {
            action(ECRInfoRefresh)
            {
                ApplicationArea = All;
                Caption = 'ECR Info. Refresh';
                Image = Refresh;
                trigger OnAction()
                var
                    ECRCalculationMgt: Report "RV ECR Calculation Info";
                    SLfilter: Record "Sales Line";
                    SalesECRStatusInfo: page "RV Sales ECR Status Info.";
                begin
                    SLfilter.setrange("Document Type", Rec."Document Type");
                    SLfilter.SetRange("Document No.", Rec."Document No.");
                    SLfilter.SetRange("Line No.", Rec."Line No.");
                    ECRCalculationMgt.SetTableView(SLfilter);
                    ECRCalculationMgt.RunModal();
                    if ECRCalculationMgt.getIsRunedOnce() then
                        SalesECRStatusInfo.Run();
                end;
            }
        }
    }
}
