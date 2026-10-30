
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
            field("Item Description"; ItemDescription)
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
            field("Base Unit of Measure"; BaseUnitofMeasure)
            {
                Caption = 'Base Unit of Measure';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
            field("Item Category Code"; ItemCategoryCode)
            {
                Caption = 'Item Category Code';
                ApplicationArea = All;
                Description = 'additional requirement';
            }
        }

    }
    var
        ItemDescription: Text[100];
        BaseUnitofMeasure: Code[10];
        ItemCategoryCode: Code[20];

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        Item.Get(Rec."Item No.");
        ItemDescription := Item.Description;
        BaseUnitofMeasure := Item."Base Unit of Measure";
        ItemCategoryCode := Item."Item Category Code";
    end;
}
