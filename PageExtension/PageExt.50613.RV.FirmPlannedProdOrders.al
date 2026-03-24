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
            field("RV Planning Date"; Rec."RV Planning Date")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'FDD011';
            }
            field("RV Planning Status"; Rec."RV Planning Status")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'FDD011';
            }
            field("RV Planning Controller"; Rec."RV Planning Controller")
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
                        ProdOrderLine: Record "Prod. Order Line";
                    begin
                        CurrPage.SetSelectionFilter(ProdOrder);
                        ProdOrder.SetRange("RV Planning Status", ProdOrder."RV Planning Status"::Planning);
                        if ProdOrder.FindSet() then
                            repeat
                                ProdOrder."RV Planning Status" := ProdOrder."RV Planning Status"::Fixed;
                                ProdOrder.Modify();

                                ProdOrderLine.Reset();
                                ProdOrderLine.SetRange(Status, ProdOrder.Status);
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
                    Description = 'FDD011';
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
                                ProdOrderLine.SetRange(Status, ProdOrder.Status);
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
