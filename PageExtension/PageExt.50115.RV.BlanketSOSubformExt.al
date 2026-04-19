pageextension 50115 "RV Blanket SO Subform Ext" extends "Blanket Sales Order Subform"
{
    layout
    {
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

    trigger OnOpenPage()
    var
        PermissionCheck: Codeunit "RV User Permission Check";
    begin
        PermissionCheck.GetCurUserPermission(AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate);
    end;

    var
        AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate : Boolean;
}
