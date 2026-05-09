/// <summary>
/// PageExtension RV_Sales Order Subform (ID 50618) extends "Sales Order Subform"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50618 "RV_Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("RV_ECR Required"; Rec."RV_ECR Required")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("RV_ECR Date"; Rec."RV_ECR Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }


        addafter("Line Discount %")
        {
            field("RV_B/L Date"; Rec."RV_B/L Date")
            {
                ApplicationArea = All;
                Description = 'FDD012';
                Editable = AllowBLDate;
            }
            field("RV_Cosing Date"; Rec."RV_Cosing Date")
            {
                ApplicationArea = All;
                Description = 'FDD012';
                Editable = AllowClosingDate;
            }
            field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
            {
                ApplicationArea = All;
                Description = 'FDD012';
                Editable = AllowStaffingDate;
            }
            field(RV_ETD; Rec."RV_ETD")
            {
                ApplicationArea = All;
                Description = 'FDD012';
            }
            field(RV_ETA; Rec."RV_ETA")
            {
                ApplicationArea = All;
                Description = 'FDD012';
            }

        }
    }
    actions
    {
        addafter(SelectMultiItems)
        {
            action(ECRInfoRefresh)
            {
                ApplicationArea = All;
                Caption = 'ECR Info. Refresh';
                Image = Refresh;
                trigger OnAction()
                var
                    ECRCalculationMgt: Report "RV ECR Calculation Info";
                    SLfilter: Record "Sales Line";
                    SalesECRStatusInfo: page "RV Sales ECR Status Info.";
                    ECRStatusInfoRec: Record "RV Sales ECR Status Info.";
                begin
                    SLfilter.setrange("Document Type", Rec."Document Type");
                    SLfilter.SetRange("Document No.", Rec."Document No.");
                    SLfilter.SetRange("Line No.", Rec."Line No.");
                    ECRCalculationMgt.SetTableView(SLfilter);
                    ECRCalculationMgt.UseRequestPage(false);//Zhao
                    ECRCalculationMgt.RunModal();
                    if ECRCalculationMgt.getIsRunedOnce() then begin
                        ECRStatusInfoRec.Reset();
                        ECRStatusInfoRec.SetRange("Sales Order No.", Rec."Document No.");
                        ECRStatusInfoRec.SetRange("SO Line No.", Rec."Line No.");
                        SalesECRStatusInfo.SetTableView(ECRStatusInfoRec);
                        SalesECRStatusInfo.Run()
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        PermissionCheck: Codeunit "RV User Permission Check";
    begin
        PermissionCheck.GetCurUserPermission(AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate);
    end;

    var
        AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate : Boolean;
}
