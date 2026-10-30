
/// <summary>
/// PageExtension RV Lot No Information List (ID 50221) extends "Lot No Information List"
/// additional requirement 2026/10/30: Add the following field. (Bobby.ji)
/// </summary>
pageextension 50221 "RV Lot No Information List Ext" extends "Lot No. Information List"
{
    layout
    {
        modify("Item No.")
        {
            Visible = true;
        }
        addafter("Item No.")
        {
            field("Item Description"; Rec."RV_Item Description")
            {
                Caption = 'Item Description';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Manufacture Date"; Rec."RV_Manufacture Date")
            {
                Caption = 'Manufacture Date';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Base Unit of Measure"; Rec."RV_Base Unit of Measure")
            {
                Caption = 'Base Unit of Measure';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Item Category Code"; Rec."RV_Item Category Code")
            {
                Caption = 'Item Category Code';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
        }

    }

}
