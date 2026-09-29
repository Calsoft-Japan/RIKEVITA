/// <summary>
/// Page RV Salesforce Order Buffer (ID 50614).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
page 50614 "RV Salesforce Order Buffer"
{
    ApplicationArea = All;
    Caption = 'Salesforce Order Buffer';
    PageType = List;
    SourceTable = "RV Salesforce Order Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Interface Date and Time"; Rec."Interface Date and Time")
                {
                    ToolTip = 'Specifies the value of the Interface Date and Time field.', Comment = '%';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the value of the Action Type field.', Comment = '%';
                }
                field("PCN No."; Rec."PCN No.")
                {
                    ToolTip = 'Specifies the value of the PCN No. field.', Comment = '%';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
                }
                field("Bill Invoice to(Code)"; Rec."Bill Invoice to(Code)")
                {
                    ToolTip = 'Specifies the value of the Bill Invoice to(Code) field.', Comment = '%';
                }
                field("Bill Invoice to"; Rec."Bill Invoice to")
                {
                    ToolTip = 'Specifies the value of the Bill Invoice to field.', Comment = '%';
                }
                field("Sales Company"; Rec."Sales Company")
                {
                    ToolTip = 'Specifies the value of the Sales Company field.', Comment = '%';
                }
                field("End Customer / Ship to(Code)"; Rec."End Customer / Ship to(Code)")
                {
                    ToolTip = 'Specifies the value of the End Customer / Ship to(Code) field.', Comment = '%';
                }
                field("End Customer / Ship to"; Rec."End Customer / Ship to")
                {
                    ToolTip = 'Specifies the value of the End Customer / Ship to field.', Comment = '%';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                }
                field(Customer; Rec.Customer)
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field("ETA(Request)"; Rec."ETA(Request)")
                {
                    ToolTip = 'Specifies the value of the ETA(Request) field.', Comment = '%';
                }
                field("ETD(Request)"; Rec."ETD(Request)")
                {
                    ToolTip = 'Specifies the value of the ETD(Request) field.', Comment = '%';
                }
                field("Trade Term(Incoterms)"; Rec."Trade Term(Incoterms)")
                {
                    ToolTip = 'Specifies the value of the Trade Term(Incoterms) field.', Comment = '%';
                }
                field(Incoterms; Rec.Incoterms)
                {
                    ToolTip = 'Specifies the value of the Incoterms field.', Comment = '%';
                }
                field(Transportation; Rec.Transportation)
                {
                    ToolTip = 'Specifies the value of the Transportation field.', Comment = '%';
                }
                field("Product Code1"; Rec."Product Code1")
                {
                    ToolTip = 'Specifies the value of the Product Code1 field.', Comment = '%';
                }
                field("Product Name1"; Rec."Product Name1")
                {
                    ToolTip = 'Specifies the value of the Product Name1 field.', Comment = '%';
                }
                field("Qty1(kg)"; Rec."Qty1(kg)")
                {
                    ToolTip = 'Specifies the value of the Qty1(kg) field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.', Comment = '%';
                }
                field("Unit Price1(per kg)"; Rec."Unit Price1(per kg)")
                {
                    ToolTip = 'Specifies the value of the Unit Price1(per kg) field.', Comment = '%';
                }
                field(Remarks; txtRemarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        rec.SetRemarks(txtRemarks);
                    end;
                }
                field("Destination(Shipment to)"; Rec."Destination(Shipment to)")
                {
                    ToolTip = 'Specifies the value of the Destination(Shipment to) field.', Comment = '%';
                }
                field("Destination(Pick List)"; Rec."Destination(Pick List)")
                {
                    ToolTip = 'Specifies the value of the Destination(Pick List) field.', Comment = '%';
                }
                field("Payment Terms"; Rec."Payment Terms(Payment Condit.)")
                {
                    ToolTip = 'Specifies the value of the Payment Terms field.', Comment = '%';
                }
                field("Price Type"; Rec."Price Type")
                {
                    ToolTip = 'Specifies the value of the Price Type field.', Comment = '%';
                }
                field(Palletize; Rec.Palletize)
                {
                    ToolTip = 'Specifies the value of the Palletize field.', Comment = '%';
                }
                field(SST; Rec.SST)
                {
                    ToolTip = 'Specifies the value of the SST field.', Comment = '%';
                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ToolTip = 'Specifies the value of the Port of Loading field.', Comment = '%';
                }
                field("Shipment(Request)"; Rec."Shipment(Request)")
                {
                    ToolTip = 'Specifies the value of the Shipment(Request) field.', Comment = '%';
                }
                field("Consignee(Code)"; Rec."Consignee(Code)")
                {
                    ToolTip = 'Specifies the value of the Consignee(Code) field.', Comment = '%';
                }
                field(Consignee; Rec.Consignee)
                {
                    ToolTip = 'Specifies the value of the Consignee field.', Comment = '%';
                }
                field("EndUser(Code)"; Rec."EndUser(Code)")
                {
                    ToolTip = 'Specifies the value of the EndUser(Code) field.', Comment = '%';
                }
                field(EndUser; Rec.EndUser)
                {
                    ToolTip = 'Specifies the value of the EndUser field.', Comment = '%';
                }
                field("Request Documents"; Rec."Request Documents")
                {
                    ToolTip = 'Specifies the value of the Request Documents field.', Comment = '%';
                }
                field("Sales Contact Note"; txtSalesContactNote)
                {
                    ToolTip = 'Specifies the value of the Sales Contact Note field.', Comment = '%';
                    MultiLine = true;
                    trigger OnValidate()
                    begin
                        rec.SetRemarks(txtSalesContactNote);
                    end;
                }
                field(Destination; Rec.Destination)
                {
                    ToolTip = 'Specifies the value of the Destination field.', Comment = '%';
                }
                field("Sales Rep"; Rec."Sales Rep")
                {
                    ToolTip = 'Specifies the value of the Sales Rep field.', Comment = '%';
                }
                field("Sales Rep(TEXT)"; Rec."Sales Rep(TEXT)")
                {
                    ToolTip = 'Specifies the value of the Sales Rep(TEXT) field.', Comment = '%';
                }
                field("Order PIC"; Rec."Order PIC")
                {
                    ToolTip = 'Specifies the value of the Order PIC field.', Comment = '%';
                }
                field("Order PIC(TEXT)"; Rec."Order PIC(TEXT)")
                {
                    ToolTip = 'Specifies the value of the Order PIC(TEXT) field.', Comment = '%';
                }
                field("CR No."; Rec."CR No.")
                {
                    ToolTip = 'Specifies the value of the CR No. field.', Comment = '%';
                }
                field("After ETD(Request)"; Rec."After ETD(Request)")
                {
                    ToolTip = 'Specifies the value of the After ETD(Request) field.', Comment = '%';
                }
                field("After ETA(Request)"; Rec."After ETA(Request)")
                {
                    ToolTip = 'Specifies the value of the After ETA(Request) field.', Comment = '%';
                }
                field("After Customer(Code)"; Rec."After Customer(Code)")
                {
                    ToolTip = 'Specifies the value of the After Customer(Code) field.', Comment = '%';
                }
                field("After Customer"; Rec."After Customer")
                {
                    ToolTip = 'Specifies the value of the After Customer field.', Comment = '%';
                }
                field("After Consignee(Code)"; Rec."After Consignee(Code)")
                {
                    ToolTip = 'Specifies the value of the After Consignee(Code) field.', Comment = '%';
                }
                field("After Consignee"; Rec."After Consignee")
                {
                    ToolTip = 'Specifies the value of the After Consignee field.', Comment = '%';
                }
                field("After Enduser(Code)"; Rec."After Enduser(Code)")
                {
                    ToolTip = 'Specifies the value of the After Enduser(Code) field.', Comment = '%';
                }
                field("After Enduser"; Rec."After Enduser")
                {
                    ToolTip = 'Specifies the value of the After Enduser field.', Comment = '%';
                }
                field("After Product Name1(Code)"; Rec."After Product Name1(Code)")
                {
                    ToolTip = 'Specifies the value of the After Product Name1(Code) field.', Comment = '%';
                }
                field("After Product Name1"; Rec."After Product Name1")
                {
                    ToolTip = 'Specifies the value of the After Product Name1 field.', Comment = '%';
                }
                field("After Destination(Shipment to)"; Rec."After Destination(Shipment to)")
                {
                    ToolTip = 'Specifies the value of the After Destination(Shipment to) field.', Comment = '%';
                }
                field("After Destination"; Rec."After Destination")
                {
                    ToolTip = 'Specifies the value of the After Destination field.', Comment = '%';
                }
                field("After Port of Loading"; Rec."After Port of Loading")
                {
                    ToolTip = 'Specifies the value of the After Port of Loading field.', Comment = '%';
                }
                field("After Destination(Pick List)"; Rec."After Destination(Pick List)")
                {
                    ToolTip = 'Specifies the value of the After Destination(Pick List) field.', Comment = '%';
                }
                field("After Currency Code"; Rec."After Currency Code")
                {
                    ToolTip = 'Specifies the value of the After Currency Code field.', Comment = '%';
                }
                field("After Unit Price1"; Rec."After Unit Price1")
                {
                    ToolTip = 'Specifies the value of the After Unit Price1 field.', Comment = '%';
                }
                field("After Qty1(kg)"; Rec."After Qty1(kg)")
                {
                    ToolTip = 'Specifies the value of the After Qty1(kg) field.', Comment = '%';
                }
                field("After Transportation"; Rec."After Transportation")
                {
                    ToolTip = 'Specifies the value of the After Transportation field.', Comment = '%';
                }
                field("After Incoterms"; Rec."After Incoterms")
                {
                    ToolTip = 'Specifies the value of the After Incoterms field.', Comment = '%';
                }
                field("After Trade Term(Incoterms)"; Rec."After Trade Term(Incoterms)")
                {
                    ToolTip = 'Specifies the value of the After Trade Term(Incoterms) field.', Comment = '%';
                }
                field("After Request Documents"; Rec."After Request Documents")
                {
                    ToolTip = 'Specifies the value of the After Request Documents field.', Comment = '%';
                }
                field("After Remarks"; txtRemarks)
                {
                    ToolTip = 'Specifies the value of the After Remarks field.', Comment = '%';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        rec.SetRemarks(txtRemarks);
                    end;
                }
                field("After Shipment(Request)"; Rec."After Shipment(Request)")
                {
                    ToolTip = 'Specifies the value of the After Shipment(Request) field.', Comment = '%';
                }
                field("After Sales Rep"; Rec."After Sales Rep")
                {
                    ToolTip = 'Specifies the value of the After Sales Rep field.', Comment = '%';
                }
                field("After Sales Rep(TEXT)"; Rec."After Sales Rep(TEXT)")
                {
                    ToolTip = 'Specifies the value of the After Sales Rep(TEXT) field.', Comment = '%';
                }
                field("After Order PIC"; Rec."After Order PIC")
                {
                    ToolTip = 'Specifies the value of the After Order PIC field.', Comment = '%';
                }
                field("After Order PIC(TEXT)"; Rec."After Order PIC(TEXT)")
                {
                    ToolTip = 'Specifies the value of the After Order PIC(TEXT) field.', Comment = '%';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        InStr: InStream;
    begin
        txtRemarks := Rec.GetRemarks();
        txtAfterRemarks := Rec.GetAfterRemarks();
        txtSalesContactNote := Rec.GetSalesContactNote();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(txtRemarks);
        clear(txtAfterRemarks);
        clear(txtSalesContactNote);
    end;

    var
        txtRemarks: Text;
        txtAfterRemarks: Text;
        txtSalesContactNote: Text;
}
