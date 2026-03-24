/// <summary>
/// PageExtension RV Purchase Order List (ID 50615) extends "Purchase Order List"
/// FDD011 2026/03/15: New. (Stephen)
/// </summary>
pageextension 50615 "RV Purchase Order List" extends "Purchase Order List"
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
                        PurchOrderLine: Record "Purchase Line";
                    begin
                        CurrPage.SetSelectionFilter(PurchOrder);
                        PurchOrder.SetRange("RV Planning Status", PurchOrder."RV Planning Status"::Planning);
                        if PurchOrder.FindSet() then
                            repeat
                                PurchOrder."RV Planning Status" := PurchOrder."RV Planning Status"::Fixed;
                                PurchOrder.Modify();

                                PurchOrderLine.Reset();
                                PurchOrderLine.SetRange("Document Type", PurchOrder."Document Type");
                                PurchOrderLine.SetRange("Document No.", PurchOrder."No.");
                                if PurchOrderLine.FindSet() then
                                    repeat
                                        PurchOrderLine.Validate("Planning Flexibility", PurchOrderLine."Planning Flexibility"::None);
                                        PurchOrderLine.Modify();
                                    until PurchOrderLine.Next() = 0;
                            until PurchOrder.Next() = 0;
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
                        PurchOrderLine: Record "Purchase Line";
                    begin
                        CurrPage.SetSelectionFilter(PurchOrder);
                        PurchOrder.SetRange("RV Planning Status", PurchOrder."RV Planning Status"::Fixed);
                        if PurchOrder.FindSet() then
                            repeat
                                PurchOrder."RV Planning Status" := PurchOrder."RV Planning Status"::Planning;
                                PurchOrder.Modify();

                                PurchOrderLine.Reset();
                                PurchOrderLine.SetRange("Document Type", PurchOrder."Document Type");
                                PurchOrderLine.SetRange("Document No.", PurchOrder."No.");
                                if PurchOrderLine.FindSet() then
                                    repeat
                                        PurchOrderLine.Validate("Planning Flexibility", PurchOrderLine."Planning Flexibility"::Unlimited);
                                        PurchOrderLine.Modify();
                                    until PurchOrderLine.Next() = 0;
                            until PurchOrder.Next() = 0;
                    end;
                }
            }
        }
        addafter(Post_Promoted)
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
