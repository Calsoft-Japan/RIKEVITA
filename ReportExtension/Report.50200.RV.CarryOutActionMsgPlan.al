/// <summary>
/// ReportExtension RIKE Carry Out Action Msg Plan(ID 50200) extends "Carry Out Action Msg. - Plan.".
/// FDD002 2026/03/23: New. (Bobby.ji)
/// </summary>
reportextension 50200 "RV Carry Out Action Msg Plan" extends "Carry Out Action Msg. - Plan."
{

    dataset
    {
        modify("Requisition Line")
        {
            trigger OnBeforePreDataItem()
            var
                RecRequisitionLine: Record "Requisition Line";
                VendorSelection: Record "RV Vendor Selection";
                ReqLineReserve: Codeunit "Req. Line-Reserve";
                LineNo: Integer;
            begin
                RecRequisitionLine.Reset();
                RecRequisitionLine.SetAscending("Line No.", true);
                if RecRequisitionLine.FindLast() then begin
                    LineNo := RecRequisitionLine."Line No.";
                end;
                "Requisition Line".Reset();
                "Requisition Line".SetRange("Worksheet Template Name", CurrReqWkshTemp);
                "Requisition Line".SetRange("Journal Batch Name", CurrReqWkshName);
                "Requisition Line".SetRange("Accept Action Message", true);
                if "Requisition Line".FindFirst() then begin
                    repeat
                        if "Requisition Line"."RV AvailableInMultipleVendor" then begin

                            VendorSelection.Reset();
                            VendorSelection.SetRange("Item No.", "Requisition Line"."No.");
                            if VendorSelection.FindFirst() then begin
                                repeat
                                    LineNo := LineNo + 10000;
                                    RecRequisitionLine.Init();
                                    RecRequisitionLine.TransferFields("Requisition Line");
                                    RecRequisitionLine."Line No." := LineNo;
                                    RecRequisitionLine."RV AvailableInMultipleVendor" := false;
                                    RecRequisitionLine.Validate("Vendor No.", VendorSelection."Vendor No.");
                                    RecRequisitionLine.Validate(Quantity, VendorSelection."Quantity to Order");
                                    RecRequisitionLine.Validate("Accept Action Message", true);
                                    RecRequisitionLine."RV AvailableInMultipleVendor" := false;
                                    RecRequisitionLine.Insert();

                                    ReqLineReserve.TransferReqLineToReqLine("Requisition Line", RecRequisitionLine, VendorSelection."Quantity to Order", false);
                                until VendorSelection.Next() = 0;

                                VendorSelection.FindSet();
                                VendorSelection.DeleteAll();
                            end;
                            "Requisition Line".Delete(true);
                        end;
                    until "Requisition Line".Next() = 0;

                    RecRequisitionLine.CopyFilters("Requisition Line");
                    //"Requisition Line".SetRange("No.", RecRequisitionLine."No.");
                end;

            end;
        }
    }

}
