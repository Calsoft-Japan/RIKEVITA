/// <summary>
/// pageextension RV Blanket Sales Order Ext (ID 50114) extends "Blanket Sales Order" page
/// FDD012 2026/04/19 New. (Liuyang)
/// </summary>
pageextension 50114 "RV Blanket Sales Order Ext" extends "Blanket Sales Order"
{
    layout
    {
        addlast(Control21)//FDD012
        {
            group(FDD012)
            {
                ShowCaption = false;

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
