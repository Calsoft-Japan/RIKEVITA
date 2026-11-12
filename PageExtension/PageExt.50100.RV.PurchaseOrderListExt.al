/// <summary>
/// PageExtension RIKE Purchase Order List Ext"(ID 50100) extends "Purchase Order List" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// On-demand request: add RV_Supplier Quotation No. by Bobby 09/16/2026
/// On-demand request: add RV_Department Code by Bobby 11/12/2026
/// </summary>
pageextension 50100 "RV Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        addbefore("Purchaser Code")
        {
            field("RV_Department Code"; Rec."RV_Department Code")
            {
                Caption = 'Department Code';
                ApplicationArea = All;
            }
        }

        addafter("Document Date")
        {
            field(RV_ETA; Rec."RV_ETA")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
            field(RV_ETD; Rec."RV_ETD")
            {
                ApplicationArea = All;
                Description = 'FDD003';
            }
            field("RV_Supplier Quotation No."; Rec."RV_Supplier Quotation No.")// On-demand request
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
