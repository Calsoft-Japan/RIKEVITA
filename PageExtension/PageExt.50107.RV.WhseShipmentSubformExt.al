/// <summary>
/// pageextension Warehouse Shipment Subform Ext (ID 50107) extends "Warehouse Shipment Subform" page
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
pageextension 50107 "RV Whse. Shipment Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Description)//FDD020
        {
            field("Print RSPO No."; PrintRSPONo)
            {
                ApplicationArea = All;
                Caption = 'Print RSPO No.';
                Description = 'FDD020';
                Editable = false;

            }

        }
        addafter("Qty. per Unit of Measure")
        {
            field("RV_B/L Date"; Rec."RV_B/L Date")
            {
                ApplicationArea = All;
                Caption = 'B/L Date';
                Description = 'FDD008';
                Editable = AllowBLDate;
            }
            field("RV_Cosing Date"; Rec."RV_Cosing Date")
            {
                ApplicationArea = All;
                Caption = 'Cosing Date';
                Description = 'FDD008';
                Editable = AllowClosingDate;
            }
            field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
            {
                ApplicationArea = All;
                Caption = 'Stuffing Date';
                Description = 'FDD008';
                Editable = AllowStaffingDate;
            }
            field("RV_ETA"; Rec."RV_ETA")
            {
                ApplicationArea = All;
                Caption = 'ETA';
                Description = 'FDD008';
            }
            field("RV_ETD"; Rec."RV_ETD")
            {
                ApplicationArea = All;
                Caption = 'ETD';
                Description = 'FDD008';
            }
        }

    }
    var
        PrintRSPONo: Boolean;
        AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate : Boolean;

    trigger OnAfterGetRecord()
    var
        RecItem: Record Item;
    begin
        if Rec.CalcFields("RV_Print RSPO No.") then begin//FDD020
            PrintRSPONo := Rec."RV_Print RSPO No.";
        end;
    end;

    trigger OnOpenPage()
    var
        PermissionCheck: Codeunit "RV User Permission Check";
    begin
        PermissionCheck.GetCurUserPermission(AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate);
    end;

}
