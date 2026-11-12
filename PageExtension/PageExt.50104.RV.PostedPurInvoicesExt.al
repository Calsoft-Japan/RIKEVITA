/// <summary>
/// PageExtension RIKE Posted Pur Invoices Ext"(ID 50104) extends "Posted Purchase Invoices" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// On-demand request: add RV_Department Code by Bobby 11/12/2026
/// </summary>
pageextension 50104 "RV Posted Pur Invoices Ext" extends "Posted Purchase Invoices"
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
