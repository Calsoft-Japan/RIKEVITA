/// <summary>
/// PageExtension RV Firm Planned Prod. Orders (ID 50613) extends "Firm Planned Prod. Orders"
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
pageextension 50613 "RV Firm Planned Prod. Orders" extends "Firm Planned Prod. Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("RV_Planning Date"; Rec."RV_Planning Date")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'FDD011';
            }
            field("RV_Planning Status"; Rec."RV_Planning Status")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'FDD011';
            }
            field("RV_Planning Controller"; Rec."RV_Planning Controller")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'FDD011';
            }
        }
    }
    actions
    {
        addafter("Change &Status")
        {
            group(RVChangePlanningStatus)
            {
                Caption = 'Change Planning Status';

                action("RV Fixed Plan")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Plan';
                    Image = Status;
                    Description = 'FDD011';
                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        CurrPage.SetSelectionFilter(ProdOrder);
                        MPSReschedulingMgt.ChangeMORVPlanningStatus(ProdOrder, 0);
                    end;
                }
                //add change to planned action here
                action("RV Flexible Plan")
                {
                    ApplicationArea = All;
                    Caption = 'Flexible Plan';
                    Image = Status;
                    Description = 'FDD011';
                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        CurrPage.SetSelectionFilter(ProdOrder);
                        MPSReschedulingMgt.ChangeMORVPlanningStatus(ProdOrder, 1);
                    end;
                }
            }
        }
        addlast(Promoted)
        {
            group(RVChangePlanningStatus_Promoted)
            {
                Caption = 'Change Planning Status';
                actionref(RVFixedPlan_Promoted; "RV Fixed Plan") { }
                actionref(RVFlexiblePlan_Promoted; "RV Flexible Plan") { }
            }
        }
    }
}
