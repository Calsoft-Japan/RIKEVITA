/// <summary>
/// PageExtension RV_Posted Whse. Shipment Subform (ID 50207) extends "Posted Whse. Shipment Subform"
/// FDD020 2026/04/09: New. (Bobby.ji)
/// </summary>
pageextension 50206 "RV Posted Sales Shipments Ext" extends "Posted Sales Shipments"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action("DeliveryOrderReport")
            {
                Caption = 'Delivery Order Report';
                Image = "Report";
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader.Reset;
                    SalesShipmentHeader.SetRange("No.", Rec."No.");
                    Report.Run(50200, TRUE, FALSE, SalesShipmentHeader);

                end;
            }
        }
        addafter("&Print_Promoted")
        {
            actionref("DeliveryOrderReport_Promoted"; "DeliveryOrderReport")
            {
            }
        }

    }
}
