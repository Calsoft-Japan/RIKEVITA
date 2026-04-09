
/// <summary>
/// PageExtension RV Purchase Order (ID 50612) extends "Purchase Order"
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
pageextension 50612 "RV Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(General)
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
        addafter(Post)
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
                        PurchOrder: Record "Purchase Header";
                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        PurchOrder.SetRange("Document Type", Rec."Document Type");
                        PurchOrder.SetRange("No.", Rec."No.");
                        MPSReschedulingMgt.ChangePORVPlanningStatus(PurchOrder, 0);
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
                        PurchOrder: Record "Purchase Header";

                        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
                    begin
                        PurchOrder.SetRange("Document Type", Rec."Document Type");
                        PurchOrder.SetRange("No.", Rec."No.");
                        MPSReschedulingMgt.ChangePORVPlanningStatus(PurchOrder, 1);
                    end;
                }
            }
        }
        addafter(Category_Category6)
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
