/// <summary>
/// PageExtension RV Firm Planned Prod. Order (ID 50610) extends "Firm Planned Prod. Order"
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>

pageextension 50610 "RV Firm Planned Prod. Order" extends "Firm Planned Prod. Order"
{
    layout
    {
        addlast(Schedule)
        {
            field("RV Planning Date"; Rec."RV Planning Date")
            {
                ApplicationArea = Planning;
                Description = 'FDD011';
            }

            field("RV Planning Status"; Rec."RV Planning Status")
            {
                ApplicationArea = Planning;
                Description = 'FDD011';
            }

            field("RV Planning Controller"; Rec."RV Planning Controller")
            {
                ApplicationArea = Planning;
                Description = 'FDD011';
            }

            field("RV Rescheduling Starting Date"; Rec."RV Rescheduling Starting Date")
            {
                ApplicationArea = Planning;
                Description = 'FDD011';
            }

            field("RV Rescheduling Ending Date"; Rec."RV Rescheduling Ending Date")
            {
                ApplicationArea = Planning;
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
                        ProdOrderLine: Record "Prod. Order Line";
                    begin
                        CurrPage.SetSelectionFilter(ProdOrder);
                        ProdOrder.SetRange("RV Planning Status", ProdOrder."RV Planning Status"::Planning);
                        if ProdOrder.FindSet() then
                            repeat
                                ProdOrder."RV Planning Status" := ProdOrder."RV Planning Status"::Fixed;
                                ProdOrder.Modify();

                                ProdOrderLine.Reset();
                                ProdOrderLine.SetRange(Status, ProdOrderLine.Status);
                                ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
                                if ProdOrderLine.FindSet() then
                                    repeat
                                        ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::None);
                                        ProdOrderLine.Modify();
                                    until ProdOrderLine.Next() = 0;
                            until ProdOrder.Next() = 0;
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
                        ProdOrderLine: Record "Prod. Order Line";
                    begin
                        CurrPage.SetSelectionFilter(ProdOrder);
                        ProdOrder.SetRange("RV Planning Status", ProdOrder."RV Planning Status"::Fixed);
                        if ProdOrder.FindSet() then
                            repeat
                                ProdOrder."RV Planning Status" := ProdOrder."RV Planning Status"::Planning;
                                ProdOrder.Modify();

                                ProdOrderLine.Reset();
                                ProdOrderLine.SetRange(Status, ProdOrderLine.Status);
                                ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
                                if ProdOrderLine.FindSet() then
                                    repeat
                                        ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::Unlimited);
                                        ProdOrderLine.Modify();
                                    until ProdOrderLine.Next() = 0;
                            until ProdOrder.Next() = 0;
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
