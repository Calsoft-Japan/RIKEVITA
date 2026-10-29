/// <summary>
/// PageExtension RV Get Get Receipt Lines (ID 50220) extends "Get Shipment Lines"
/// additional requirement 2026/10/29: Add the following field. (Bobby.ji)
/// </summary>
pageextension 50220 "RV Get Receipt Lines Ext" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Customer Name"; CustomerName)
            {
                Caption = 'Customer Name';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Posting Date"; Rec."Posting Date")
            {
                Caption = 'Posting Date';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Order No."; Rec."Order No.")
            {
                Caption = 'Order No.';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                Caption = 'Order Line No.';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
        }

    }
    var
        CustomerName: Text[100];

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Buy-from Vendor No.") then begin
            CustomerName := Vendor.Name;
        end;
    end;

}
