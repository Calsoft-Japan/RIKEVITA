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

        addafter(Quantity)
        {
            field("RV_B/L Date"; Rec."RV_B/L Date")
            {
                ApplicationArea = All;
                Caption = 'B/L Date';
                Description = 'FDD008';
            }
            field("RV_Cosing Date"; Rec."RV_Closing Date")
            {
                ApplicationArea = All;
                Caption = 'Cosing Date';
                Description = 'FDD008';
            }
            field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
            {
                ApplicationArea = All;
                Caption = 'Stuffing Date';
                Description = 'FDD008';
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
            field("RV_SI Received Date"; Rec."RV_SI Received Date")
            {
                ApplicationArea = All;
                Caption = 'SI Received Date';
                Description = 'FDD008';
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
