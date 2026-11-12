/// <summary>
/// PageExtension RV Posted Purchase Receipts Ext (ID 50230) extends "Posted Purchase Receipts"
/// On-demand request: add RV_Department Code by Bobby 11/12/2026
/// </summary>
pageextension 50230 "RV PostedPurchaseReceipts Ext" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("RV_Department Code"; Rec."RV_Department Code")
            {
                Caption = 'Department Code';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        if RIKEVITASetup.Get() then begin
            Rec."RV_Department Dimension Code" := RIKEVITASetup."Department Dimension Code";
        end;
    end;
}
