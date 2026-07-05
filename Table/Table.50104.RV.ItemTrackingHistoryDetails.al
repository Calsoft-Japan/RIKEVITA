/// <summary>
/// Table RV Item Tracking History Dtl (ID 50104).
/// FDD005 2026/04/19: New. (Liuyang)
/// </summary>
table 50104 "RV Item Tracking History Dtl."
{
    Caption = 'Item Tracking History Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(2; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
        }
        field(3; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(4; "Container No."; Code[50])
        {
            Caption = 'Container No.';
        }
        field(5; Qty; Decimal)
        {
            Caption = 'Qty';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(7; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(8; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
    }
    keys
    {
        key(PK; "External Document No.", "Sell-to Customer No.", "Item No.", "Lot No.", "Container No.")
        {
            Clustered = true;
        }
        key(PKey1; "Sales Order No.", "Sales Order Line No.", "Lot No.", "Container No.")
        {
        }
    }
}
