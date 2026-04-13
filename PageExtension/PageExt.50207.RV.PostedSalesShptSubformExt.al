/// <summary>
/// PageExtension RV_Posted Sales Shpt. Subform (ID 50207) extends "Posted Sales Shpt. Subform"
/// FDD020 2026/04/09: New. (Bobby.ji)
/// </summary>
pageextension 50207 "RV PostedSalesShptSubformExt" extends "Posted Sales Shpt. Subform"
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
    }
    var
        PrintRSPONo: Boolean;

    trigger OnAfterGetRecord()
    var
        RecItem: Record Item;
    begin
        if Rec.CalcFields("RV_Print RSPO No.") then begin//FDD020
            PrintRSPONo := Rec."RV_Print RSPO No.";
        end;
    end;
}
