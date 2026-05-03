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
                field("Blanket Sales Order No."; Rec."Blanket Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Blanket Sales Order No. field.', Comment = '%';
                    Editable = false;
                }
                field("Blanket Sales Order Line No."; Rec."Blanket Sales Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Blanket Sales Order Line No. field.', Comment = '%';
                    Editable = false;
                }
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
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ToolTip = 'Specifies the value of the Transfer Order No. field.', Comment = '%';
                }
                field("Transfer Order Line No."; Rec."Transfer Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Transfer Order Line No. field.', Comment = '%';
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

                field("Packing Line"; Rec."Packing Line")
                {
                    ToolTip = 'Specifies the value of the Packing Line No. field.', Comment = '%';
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

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    Editable = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
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
                ToolTip = 'Collect the latest Order Listing data.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    ShiptoAddress: Record "Ship-to Address";
                    WhseshipmentHeader: Record "Warehouse Shipment Header";
                    WhseshipmentLine: Record "Warehouse Shipment Line";
                    BlanketSalesLine: Record "Sales Line";
                    BlanketSalesHeader: Record "Sales Header";
                    ProdHeader: Record "Production Order";
                    ProdLine: Record "Prod. Order Line";
                    transferLine: Record "Transfer Line";
                    TransferHeader: Record "Transfer Header";
                    ReservationEntry: Record "Reservation Entry";
                    SalesCommentLine: Record "Sales Comment Line";
                    OrderListing: Record "RV Order Listing";
                    EntryNo: Integer;
                    Counts: Integer;
                begin
                    IF GuiAllowed Then
                        if NOT Confirm('This action will collect the latest data and overwrite existing data. Do you want to continue?') THEN
                            EXIT;

                    //Update Comment to Sales Comment Line
                    OrderListing.reset;
                    if OrderListing.FindSet() then begin
                        repeat
                            SalesCommentLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            SalesCommentLine.SetRange("No.", OrderListing."Sales Order No.");
                            SalesCommentLine.DeleteAll();
                            SalesCommentLine.Init();
                            SalesCommentLine."Document Type" := SalesLine."Document Type"::Order;
                            SalesCommentLine."No." := OrderListing."Sales Order No.";
                            SalesCommentLine.Comment := OrderListing.Comment;
                            SalesCommentLine.Insert();
                            OrderListing.Delete();
                        until OrderListing.Next() = 0;
                    end;
                    SalesLine.reset;
                    SalesLine.setrange("Document Type", SalesHeader."Document Type"::Order);
                    SalesLine.SetFilter("Outstanding Quantity", '>0');
                    if SalesLine.FindSet() then begin
                        repeat
                            EntryNo += 1;
                            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                            OrderListing.Init();
                            OrderListing."Entry No." := EntryNo;
                            OrderListing."Sales Order No." := SalesLine."Document No.";
                            OrderListing."Sales Order Line No." := SalesLine."Line No.";
                            OrderListing."Order Date" := SalesHeader."Order Date";
                            OrderListing."Order Age (Days)" := Today - SalesHeader."Order Date";
                            OrderListing."Item No." := SalesLine."No.";
                            OrderListing."Item Description" := SalesLine."Description";
                            OrderListing."Order Qty. (UOM)" := SalesLine."Quantity";
                            OrderListing."Order Unit of Measure" := SalesLine."Unit of Measure";
                            OrderListing."Order Qty. (Base)" := SalesLine."Quantity (Base)";
                            OrderListing."Requested Delivery Date" := SalesLine."Requested Delivery Date";
                            OrderListing."Customer No." := SalesHeader."Sell-to Customer No.";
                            OrderListing."Ship-to Customer Name" := SalesHeader."Ship-to Name";
                            OrderListing."Ship-to Country" := SalesHeader."Ship-to Country/Region Code";
                            OrderListing.ETA := SalesLine.RV_ETA;
                            OrderListing.ETD := SalesLine.RV_ETD;
                            //OrderListing."Order Lead Time (Days)" := SalesLine."Requested Delivery Date" - SalesHeader."Order Date";
                            OrderListing."Packing Date" := SalesLine."RV_Stuffing Date";
                            OrderListing."ECR Date" := SalesLine."RV_ECR Date";
                            //KG quantity calculation.
                            //OrderListing."Order Qty. (KG)" := SalesLine.Quantity;

                            //Logistics Information
                            IF ShiptoAddress.get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN BEGIN
                                //OrderListing."Holding Requirement" := ShiptoAddress."RV_Sailing Period";
                                OrderListing."Bypass Holding Requirement" := ShiptoAddress."RV_Bypass ECR";
                            END;

                            OrderListing."Packing Line" := ProdHeader."Shortcut Dimension 2 Code";
                            WhseshipmentLine.Reset();
                            WhseshipmentLine.setrange("Source No.", SalesLine."Document No.");
                            WhseshipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
                            if WhseshipmentLine.findlast then begin
                                //OrderListing."Closing Date & Time" := WhseshipmentLine."RV_Cosing Date";
                                OrderListing."SI Received Date" := WhseshipmentLine."RV_SI Received Date";
                            end;

                            //Reserved Quantity calculation.
                            //OrderListing."Reserved Qty. (UOM)"
                            //OrderListing."Reserved Qty. (KG)"

                            //related information
                            OrderListing."Blanket Sales Order No." := SalesLine."Blanket Order No.";
                            OrderListing."Blanket Sales Order Line No." := SalesLine."Blanket Order Line No.";
                            //OrderListing."Prod. Order No." := SalesLine."Prod. Order No.";
                            //OrderListing."Prod. Order Line No." := SalesLine."Prod. Order Line No.";
                            //OrderListing."Transfer Order No." := SalesLine."Transfer Order No.";
                            //OrderListing."Transfer Order Line No." := SalesLine."Transfer Order Line No.";

                            //Status Update
                            //OrderListing.Status := SalesLine.Status;
                            //KG quantity calculation.

                            SalesCommentLine.SetRange("Document Type", SalesLine."Document Type");
                            SalesCommentLine.SetRange("No.", SalesLine."Document No.");
                            if SalesCommentLine.FindFirst() then
                                Rec.Comment := SalesCommentLine.Comment;
                            OrderListing.Insert();
                            Counts += 1;
                        until SalesLine.Next() = 0;
                    end;
                    if GuiAllowed Then
                        Message('Data collection completed. %1 records have been updated.', Counts);
                    CurrPage.Update(TRUE);
                end;
            }
        }
    }
}
