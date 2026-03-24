/// <summary>
/// ReportExtension RIKE Carry Out Action Msg Plan(ID 50200) extends "Carry Out Action Msg. - Plan.".
/// FDD002 2026/03/23: New. (Bobby.ji)
/// </summary>
reportextension 50200 "RIKE Carry Out Action Msg Plan" extends "Carry Out Action Msg. - Plan."
{

    dataset
    {
        modify("Requisition Line")
        {
            trigger OnBeforePreDataItem()
            var
                RecRequisitionLine: Record "Requisition Line";
                VendorSelection: Record "RIKE Vendor Selection";
                LineNo: Integer;
            begin
                if "Requisition Line".FindLast() then begin
                    LineNo := "Requisition Line"."Line No.";
                end;

                if "Requisition Line".FindFirst() then begin
                    repeat
                        if "Requisition Line".RV_AvailableInMultipleVendor then begin

                            VendorSelection.Reset();
                            VendorSelection.SetRange("Item No.", "Requisition Line"."No.");
                            if VendorSelection.FindFirst() then begin
                                repeat
                                    LineNo := LineNo + 10000;
                                    RecRequisitionLine.Init();
                                    RecRequisitionLine.TransferFields("Requisition Line");
                                    RecRequisitionLine."Line No." := LineNo;
                                    RecRequisitionLine.RV_AvailableInMultipleVendor := false;
                                    RecRequisitionLine.Validate("Vendor No.", VendorSelection."Vendor No.");
                                    RecRequisitionLine.Validate(Quantity, VendorSelection."Quantity to Order");
                                    RecRequisitionLine.Insert();

                                until VendorSelection.Next() = 0;
                            end;

                            "Requisition Line".Delete();
                        end;
                    until "Requisition Line".Next() = 0;
                end;

            end;
        }
    }

}
