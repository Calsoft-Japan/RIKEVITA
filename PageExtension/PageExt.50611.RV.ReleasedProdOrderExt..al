/// <summary>
/// PageExtension RV Released Prod. Order (ID 50611) extends "Released Production Order"
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>

pageextension 50611 "RV Released Prod. Order" extends "Released Production Order"
{
    layout
    {
        addlast(Schedule)
        {
            field("RV_Planning Date"; Rec."RV_Planning Date")
            {
                ApplicationArea = Planning;
                Editable = false;
                Description = 'FDD011';
            }

            field("RV_Planning Status"; Rec."RV_Planning Status")
            {
                ApplicationArea = Planning;
                Editable = false;
                Description = 'FDD011';
            }

            field("RV_Planning Controller"; Rec."RV_Planning Controller")
            {
                ApplicationArea = Planning;
                Editable = false;
                Description = 'FDD011';
            }

            field("RV_Rescheduling Starting Date"; Rec."RV_Rescheduling Starting Date")
            {
                ApplicationArea = Planning;
                Editable = false;
                Description = 'FDD011';
            }

            field("RV_Rescheduling Ending Date"; Rec."RV_Rescheduling Ending Date")
            {
                ApplicationArea = Planning;
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
                    Description = 'FD011';

                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        ProdOrder.SetRange(Status, Rec.Status);
                        ProdOrder.SetRange("No.", Rec."No.");
                        MPSReschedulingMgt.ChangeMORVPlanningStatus(ProdOrder, 0);
                    end;
                }
                //add change to planned action here
                action("RV Flexible Plan")
                {
                    ApplicationArea = All;
                    Caption = 'Flexible Plan';
                    Image = Status;
                    Description = 'FD011';
                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        ProdOrder.SetRange(Status, Rec.Status);
                        ProdOrder.SetRange("No.", Rec."No.");
                        MPSReschedulingMgt.ChangeMORVPlanningStatus(ProdOrder, 1);
                    end;
                }
            }
        }
        addlast(Category_Process)
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
