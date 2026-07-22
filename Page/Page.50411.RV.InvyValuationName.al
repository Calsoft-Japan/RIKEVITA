page 50411 "RV Invy. Valuation Names"
{
    ApplicationArea = All;
    Caption = 'Inventory Valuation Names';
    PageType = List;
    usagecategory = Lists;
    SourceTable = "RV Invy. Valuation Name";
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
                }
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Update Valuation")
            {
                ApplicationArea = all;
                Caption = 'Update Valuation';
                Image = CalculateInventory;
                ShortCutKey = 'Return';
                ToolTip = 'Open the related Inventory Valuation.';

                trigger OnAction()
                var
                    InventoryValuation: Page "RV Inventory Valuation Name";
                begin
                    InventoryValuation.SetRecord(Rec);
                    InventoryValuation.Run();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Update Valuation_Promoted"; "Update Valuation")
                {
                }
            }
        }

    }
}
