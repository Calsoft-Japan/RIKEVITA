/// <summary>
/// Report RV Collect MPS Data (ID 50601)
/// FDD011 2026/02/23: New. (Stephen)
/// </summary>
report 50601 "RV Collect MPS Data"
{
    ApplicationArea = All;
    Caption = 'Collect MPS Data';
    ProcessingOnly = true;
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.") where(Status = const("Firm Planned"));
            RequestFilterFields = "RV Planning Controller",
                                "RV Rescheduling Starting Date",
                                "RV Rescheduling Ending Date",
                                "RV Planning Status";
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = status = field(status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting("Line No.");

                trigger OnAfterGetRecord()
                var
                    RountCounter: Integer;
                begin
                    ProdOrderRoutingLine.Reset();
                    ProdOrderRoutingLine.SetRange(Status, "Prod. Order Line"."Status");
                    ProdOrderRoutingLine.SetRange("Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                    ProdOrderRoutingLine.SetRange("Routing Reference No.", "Prod. Order Line"."Line No.");
                    if ProdOrderRoutingLine.FindSet() then begin
                        LastLineNo += 10000;
                        MPSReschedulingLine.Init();
                        MPSReschedulingLine."Batch Name" := GBatch;
                        MPSReschedulingLine."batch Line No." := LastLineNo;
                        MPSReschedulingLine."Production No." := "Production Order"."No.";
                        MPSReschedulingLine."Item No." := "Prod. Order Line"."Item No.";
                        MPSReschedulingLine.Quantity := "Prod. Order Line".Quantity;
                        MPSReschedulingLine."Starting Date" := DT2DATE("Prod. Order Line"."Starting Date-Time");
                        MPSReschedulingLine."Ending Date" := DT2DATE("Prod. Order Line"."Ending Date-Time");
                        MPSReschedulingLine."Due Date" := "Prod. Order Line"."Due Date";
                        MPSReschedulingLine."Routing No." := ProdOrderRoutingLine."Routing No.";
                        repeat
                            RountCounter += 1;
                            case RountCounter of
                                1:
                                    MPSReschedulingLine."Work Center No. 1" := ProdOrderRoutingLine."No.";
                                2:
                                    MPSReschedulingLine."Work Center No. 2" := ProdOrderRoutingLine."No.";
                                3:
                                    MPSReschedulingLine."Work Center No. 3" := ProdOrderRoutingLine."No.";
                                else
                                    ProdOrderRoutingLine.FindLast();
                            end;
                        until ProdOrderRoutingLine.Next() = 0;
                        MPSReschedulingLine."Planning Status" := "Production Order"."RV Planning Status";
                        MPSReschedulingLine."Prod. Line No." := "Prod. Order Line"."Line No.";
                        MPSReschedulingLine.Insert();
                    end;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        MPSReschedulingLine.Reset();
        MPSReschedulingLine.DeleteAll();
    end;

    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        GBatch: Code[10];
        LastLineNo: Integer;

    procedure SetBatchName(BatchName: Code[10])
    begin
        GBatch := BatchName;
    end;

}
