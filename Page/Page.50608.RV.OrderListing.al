/// <summary>
/// COMMON 2026/05/02: New. (Stephen)
/// </summary>
page 50608 "RV Order Listing"
{
    ApplicationArea = All;
    Caption = 'Order Listing';
    PageType = List;
    SourceTable = "RV Order Listing";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                    Editable = false;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                    Editable = false;
                }

                field("Order Qty. (UOM)"; Rec."Order Qty. (UOM)")
                {
                    ToolTip = 'Specifies the value of the Order Qty. (UOM) field.', Comment = '%';
                    Editable = false;
                }

                field("Order Unit of Measure"; Rec."Order Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Order Unit of Measure field.', Comment = '%';
                    Editable = false;
                }
                field("Order Qty. (Base)"; Rec."Order Qty. (Base)")
                {
                    ToolTip = 'Specifies the value of the Order Qty. (Base) field.', Comment = '%';
                    Editable = false;
                }
                field("Order Qty. (KG)"; Rec."Order Qty. (KG)")
                {
                    ToolTip = 'Specifies the value of the Order Qty. (KG) field.', Comment = '%';
                    Editable = false;
                }
                field("Reserved Qty. (UOM)"; Rec."Reserved Qty. (UOM)")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. (UOM) field.', Comment = '%';
                    Editable = false;
                }
                field("Reserved Qty. (KG)"; Rec."Reserved Qty. (KG)")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. (KG) field.', Comment = '%';
                    Editable = false;
                }
                field("Firm Prod. Order No."; Rec."Firm Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Firm Prod. Order No. field.', Comment = '%';
                    Editable = false;
                }
                field("Firm Prod. Order Line No."; Rec."Firm Prod. Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Firm Prod. Order Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                    Editable = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Line No. field.', Comment = '%';
                    Editable = false;
                }

                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ToolTip = 'Specifies the value of the Requested Delivery Date field.', Comment = '%';
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    Editable = false;
                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Ship-to Customer Name field.', Comment = '%';
                    Editable = false;
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                    ToolTip = 'Specifies the value of the Ship-to Country field.', Comment = '%';
                    Editable = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
                    Editable = false;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer Name field.', Comment = '%';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = false;
                }
                field(ETD; Rec.ETD)
                {
                    ToolTip = 'Specifies the value of the ETD field.', Comment = '%';
                    Editable = false;
                }

                field(ETA; Rec.ETA)
                {
                    ToolTip = 'Specifies the value of the ETA field.', Comment = '%';
                    Editable = false;
                }

                field("Order Lead Time (Days)"; Rec."Order Lead Time (Days)")
                {
                    ToolTip = 'Specifies the value of the Order Lead Time (Days) field.', Comment = '%';
                    Editable = false;
                }
                field("Packing Date"; Rec."Packing Date")
                {
                    ToolTip = 'Specifies the value of the Packing Date field.', Comment = '%';
                    Editable = false;
                }
                field("ECR Date"; Rec."ECR Date")
                {
                    ToolTip = 'Specifies the value of the ECR Date field.', Comment = '%';
                    Editable = false;
                }

                field("Holding Requirement"; Rec."Holding Requirement")
                {
                    ToolTip = 'Specifies the value of the Holding Requirement field.', Comment = '%';
                    Editable = false;
                }

                field("Bypass Holding Requirement"; Rec."Bypass Holding Requirement")
                {
                    ToolTip = 'Specifies the value of the Bypass Holding Requirement field.', Comment = '%';
                    Editable = false;
                }

                field("Closing Date & Time"; Rec."Closing Date & Time")
                {
                    ToolTip = 'Specifies the value of the Closing Date & Time field.', Comment = '%';
                    Editable = false;
                }
                field("Order Age (Days)"; Rec."Order Age (Days)")
                {
                    ToolTip = 'Specifies the value of the Order Age (Days) field.', Comment = '%';
                    Editable = false;
                }
                field("SI Received Date"; Rec."SI Received Date")
                {
                    ToolTip = 'Specifies the value of the SI Received Date field.', Comment = '%';
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                    Editable = true;
                }
                field("Sales Force Remark"; Rec."Sales Force Remark")
                {
                    ToolTip = 'Specifies the value of the Sales Force Remark field.', Comment = '%';
                    Editable = true;
                }
                field("RVM PIC"; Rec."RVM PIC")
                {
                    ToolTip = 'Specifies the value of the RVM PIC field.', Comment = '%';
                    Editable = false;
                }
                field("Sales Office Sales Rep."; Rec."Sales Office Sales Rep.")
                {
                    ToolTip = 'Specifies the value of the "Sales Office Sales Rep." field.', Comment = '%';
                    Editable = false;
                }


                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Editable = false;
                }


            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Collect Data")
            {
                ApplicationArea = All;
                Caption = 'Collect Data';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = false;
                ToolTip = 'Collect the latest Order Listing data.';
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    OrderListingUpdate: Report "RV Order Listing Update";
                begin
                    OrderListingUpdate.Run();
                    CurrPage.Update(false);
                end;

            }
        }
    }

}
