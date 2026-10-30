
/// <summary>
/// PageExtension RV_Lot No. Information Card (ID 50619) extends "Lot No. Information Card"
/// FDD006 2026/03/31: New. (Stephen)
/// FDD043 2026/07/29: New. (Stephen)
/// additional requirement 2026/10/30: Add the following field. (Bobby.ji)
/// </summary>
pageextension 50619 "RV_Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = false;
        }
        modify("Test Quality")
        {
            Visible = false;
        }
        modify("Certificate Number")
        {
            Visible = false;
        }
        addafter("Item No.")
        {
            field("Item Description"; Rec."RV_Item Description")
            {
                Caption = 'Item Description';
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
        addlast(General)
        {
            /**additional requirement
            field("RV_Sub Lot No."; rec."RV_Sub Lot No.")
            {
                ApplicationArea = All;
            }
            **/
            field("RV_Manufacture Date"; rec."RV_Manufacture Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
