/// <summary>
/// Page RV Salesforce Order Buffer API(ID 50615).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
page 50615 "RV Salesforce Order Buffer API"
{
    PageType = API;
    SourceTable = "RV Salesforce Order Buffer";
    APIPublisher = 'calsoft';
    APIGroup = 'rikevita';
    APIVersion = 'v1.0';
    EntityName = 'salesforceOrderBuffer';
    EntitySetName = 'salesforceOrderBuffers';
    ODataKeyFields = SystemId;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
            }
            field(entryNo; Rec."Entry No.")
            {
            }
            field(interfaceDateAndTime; Rec."Interface Date and Time")
            {
            }
            field(actionType; Rec."Action Type")
            {
            }
            field(pcnNo; Rec."PCN No.")
            {
            }
            field(orderDate; Rec."Order Date")
            {
            }
            field(billInvoiceToCode; Rec."Bill Invoice to(Code)")
            {
            }
            field(billInvoiceTo; Rec."Bill Invoice to")
            {
            }
            field(salesCompany; Rec."Sales Company")
            {
            }
            field(endCustomerShipToCode; Rec."End Customer / Ship to(Code)")
            {
            }
            field(endCustomerShipTo; Rec."End Customer / Ship to")
            {
            }
            field(customerCode; Rec."Customer Code")
            {
            }
            field(customer; Rec.Customer)
            {
            }
            field(currencyCode; Rec."Currency Code")
            {
            }
            field(etaRequest; Rec."ETA(Request)")
            {
            }
            field(etdRequest; Rec."ETD(Request)")
            {
            }
            field(tradeTermIncoterms; Rec."Trade Term(Incoterms)")
            {
            }
            field(incoterms; Rec.Incoterms)
            {
            }
            field(transportation; Rec.Transportation)
            {
            }
            field(productCode1; Rec."Product Code1")
            {
            }
            field(productName1; Rec."Product Name1")
            {
            }
            field(qty1Kg; Rec."Qty1(kg)")
            {
            }
            field(unitOfMeasureCode; Rec."Unit of Measure Code")
            {
            }
            field(unitPrice1PerKg; Rec."Unit Price1(per kg)")
            {
            }
            field(remarks; txtRemarks)
            {
                trigger OnValidate()
                begin
                    Rec.SetRemarks(txtRemarks);
                end;
            }
            field(destinationShipmentTo; Rec."Destination(Shipment to)")
            {
            }
            field(destinationPickList; Rec."Destination(Pick List)")
            {
            }
            field(paymentTerms; Rec."Payment Terms(Payment Condit.)")
            {
            }
            field(priceType; Rec."Price Type")
            {
            }
            field(palletize; Rec.Palletize)
            {
            }
            field(sst; Rec.SST)
            {
            }
            field(portOfLoading; Rec."Port of Loading")
            {
            }
            field(shipmentRequest; Rec."Shipment(Request)")
            {
            }
            field(consigneeCode; Rec."Consignee(Code)")
            {
            }
            field(consignee; Rec.Consignee)
            {
            }
            field(endUserCode; Rec."EndUser(Code)")
            {
            }
            field(endUser; Rec.EndUser)
            {
            }
            field(requestDocuments; Rec."Request Documents")
            {
            }
            field(salesContactNote; txtSalesContactNote)
            {
                trigger OnValidate()
                begin
                    Rec.SetSalesContactNote(txtSalesContactNote);
                end;
            }
            field(destination; Rec.Destination)
            {
            }
            field(salesRep; Rec."Sales Rep")
            {
            }
            field(salesRepText; Rec."Sales Rep(TEXT)")
            {
            }
            field(orderPic; Rec."Order PIC")
            {
            }
            field(orderPicText; Rec."Order PIC(TEXT)")
            {
            }
            field(crNo; Rec."CR No.")
            {
            }
            field(afterEtdRequest; Rec."After ETD(Request)")
            {
            }
            field(afterEtaRequest; Rec."After ETA(Request)")
            {
            }
            field(afterCustomerCode; Rec."After Customer(Code)")
            {
            }
            field(afterCustomer; Rec."After Customer")
            {
            }
            field(afterConsigneeCode; Rec."After Consignee(Code)")
            {
            }
            field(afterConsignee; Rec."After Consignee")
            {
            }
            field(afterEndUserCode; Rec."After Enduser(Code)")
            {
            }
            field(afterEndUser; Rec."After Enduser")
            {
            }
            field(afterProductName1Code; Rec."After Product Name1(Code)")
            {
            }
            field(afterProductName1; Rec."After Product Name1")
            {
            }
            field(afterDestinationShipmentTo; Rec."After Destination(Shipment to)")
            {
            }
            field(afterDestination; Rec."After Destination")
            {
            }
            field(afterPortOfLoading; Rec."After Port of Loading")
            {
            }
            field(afterDestinationPickList; Rec."After Destination(Pick List)")
            {
            }
            field(afterCurrencyCode; Rec."After Currency Code")
            {
            }
            field(afterUnitPrice1; Rec."After Unit Price1")
            {
            }
            field(afterQty1Kg; Rec."After Qty1(kg)")
            {
            }
            field(afterTransportation; Rec."After Transportation")
            {
            }
            field(afterIncoterms; Rec."After Incoterms")
            {
            }
            field(afterTradeTermIncoterms; Rec."After Trade Term(Incoterms)")
            {
            }
            field(afterRequestDocuments; Rec."After Request Documents")
            {
            }
            field(afterRemarks; txtafterRemarks)
            {
                trigger OnValidate()
                begin
                    Rec.setAfterRemarks(txtafterRemarks);
                end;
            }
            field(afterShipmentRequest; Rec."After Shipment(Request)")
            {
            }
            field(afterSalesRep; Rec."After Sales Rep")
            {
            }
            field(afterSalesRepText; Rec."After Sales Rep(TEXT)")
            {
            }
            field(afterOrderPic; Rec."After Order PIC")
            {
            }
            field(afterOrderPicText; Rec."After Order PIC(TEXT)")
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        txtRemarks := Rec.GetRemarks();
        txtafterRemarks := Rec.GetAfterRemarks();
        txtSalesContactNote := Rec.GetSalesContactNote();
    end;

    var
        txtRemarks: Text;
        txtafterRemarks: Text;
        txtSalesContactNote: Text;
}
