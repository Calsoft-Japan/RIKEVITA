/// <summary>
/// PageExtension RV Purchase Quotes (ID 50218) extends "Purchase Quote"
/// On-demand request: add RV_Supplier Quotation No. by Bobby 09/16/2026
/// On-demand request: add RV_Department Dimension Code by Bobby 11/12/2026
/// </summary>
pageextension 50218 "RV Purchase Quotes Ext" extends "Purchase Quotes"
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

        addafter(Status)
        {
            field("RV_Supplier Quotation No."; Rec."RV_Supplier Quotation No.")
            {
                Caption = 'Supplier Quotation No.';
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
