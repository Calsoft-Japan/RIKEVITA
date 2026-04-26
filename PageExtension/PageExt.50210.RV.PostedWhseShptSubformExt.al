/// <summary>
/// PageExtension RV PostedWhseShipSubformExt (ID 50210) extends "Posted Whse. Shipment Subform"
/// FDD019 2026/04/24: New. (Bobby.ji)
/// </summary>
pageextension 50210 "RV PostedWhseShipSubformExt" extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addafter(Description)//FDD019
        {
            field("Symbol Display Packing List"; SymbolDisplayPackingList)
            {
                ApplicationArea = All;
                Caption = 'Symbol Display Packing List';
                Description = 'FDD019';
                Editable = false;
            }
        }
    }
    var
        SymbolDisplayPackingList: Boolean;

    trigger OnAfterGetRecord()
    begin
        if Rec.CalcFields("RV_Symbol Display Packing List") then begin
            SymbolDisplayPackingList := Rec."RV_Symbol Display Packing List";
        end;
    end;
}
