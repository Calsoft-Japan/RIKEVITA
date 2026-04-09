/// <summary>
/// Codeunit RV Prod. Results Management (ID 50601)
/// FDD011 2026/02/23: New. (Stephen)
/// </summary>
codeunit 50605 "RV MPS Reschedul Update Batch"
{
    TableNo = 50604;
    trigger OnRun()
    begin
        MPSReschedulingLine := Rec;
        UpdateMOData();
    end;

    procedure UpdateMOData()
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RountCount: Integer;
        DiffDays: BigInteger;
    begin
        MfgSetup.get();
        ProdOrder.get(ProdOrder.Status::"Firm Planned", MPSReschedulingLine."Production No.");
        ProdOrderLine.get(ProdOrderLine.Status::"Firm Planned", MPSReschedulingLine."Production No.", MPSReschedulingLine."Prod. Line No.");

        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange("Status", ProdOrderRoutingLine.Status::"Firm Planned");
        ProdOrderRoutingLine.SetRange("Prod. Order No.", MPSReschedulingLine."Production No.");
        ProdOrderRoutingLine.SetRange("Routing No.", MPSReschedulingLine."Routing No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", MPSReschedulingLine."Prod. Line No.");
        if ProdOrderRoutingLine.FindSet() then
            repeat
                RountCount += 1;
                case RountCount of
                    1:
                        begin
                            if MPSReschedulingLine."new Work Center No. 1" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 1" then
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 1");
                        end;
                    2:
                        begin
                            if MPSReschedulingLine."new Work Center No. 2" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 2" then
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 2");
                        end;
                    3:
                        begin
                            if MPSReschedulingLine."new Work Center No. 3" <> '' then
                                if ProdOrderRoutingLine."No." <> MPSReschedulingLine."new Work Center No. 3" then
                                    ProdOrderRoutingLine.Validate("No.", MPSReschedulingLine."new Work Center No. 3");
                        end;

                end;
                ProdOrderRoutingLine.Modify();
            until ProdOrderRoutingLine.Next() = 0;

        if MPSReschedulingLine."New Ending Date" <> 0DT then
            if ProdOrder."Ending Date" <> DT2Date(MPSReschedulingLine."New Ending Date") then begin
                ProdOrder.Validate("Ending Date-Time", CreateDateTime(DT2Date(MPSReschedulingLine."New Ending Date"), MfgSetup."Normal Ending Time"));
                ProdOrder.Validate("RV_Rescheduling Ending Date", MPSReschedulingLine."New Ending Date");
                ProdOrder.Modify();
            end;

        if MPSReschedulingLine."New Starting Date" <> 0DT then
            if ProdOrder."Starting Date" <> DT2Date(MPSReschedulingLine."New Starting Date") then begin
                ProdOrder.Validate("RV_Rescheduling Starting Date", MPSReschedulingLine."New Starting Date");

                //Calculate the difference days = “MPS Rescheduling Line”.“New Starting Date”- “Production Header”. “Starting Date-Time”
                DiffDays := CreateDateTime(DT2Date(MPSReschedulingLine."New Starting Date"), ProdOrder."Starting Time") - ProdOrder."Starting Date-Time";
                ProdOrder.Validate("Ending Date-Time", ProdOrder."Ending Date-Time" + DiffDays);
                ProdOrder.Modify();
            end;

        if ProdOrder."RV_Planning Status" <> MPSReschedulingLine."Planning Status" then begin
            ProdOrder.Validate("RV_Planning Status", MPSReschedulingLine."Planning Status");
            ProdOrder."RV_Planning Controller" := UserId();
            ProdOrder."RV_Planning Date" := Today();
            ProdOrder.Modify();

            if ProdOrder."RV_Planning Status" = ProdOrder."RV_Planning Status"::Planning then
                if ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::Unlimited then begin
                    ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::Unlimited);
                    ProdOrderLine.Modify();
                end;
            if ProdOrder."RV_Planning Status" = ProdOrder."RV_Planning Status"::Fixed then
                if ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::None then begin
                    ProdOrderLine.Validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::None);
                    ProdOrderLine.Modify();
                end;
        end;
        MPSReschedulingLine.Delete();

    end;

    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        MfgSetup: Record "Manufacturing Setup";
}
