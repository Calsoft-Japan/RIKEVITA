page 50412 "RV BackedDate Stock Names"
{
    ApplicationArea = All;
    Caption = 'BackedDate Stock Balance Names';
    PageType = List;
    usagecategory = Lists;
    SourceTable = "RV Invy. Available Name";
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
                field("Inventory Valuation Date"; Rec."Inventory Valuation Date")
                {
                    ToolTip = 'Specifies the value of the Inventory Valuation Date field.', Comment = '%';
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
            action("Update Available Inventory")
            {
                ApplicationArea = all;
                Caption = 'Update Available Inventory';
                Image = CalculateInventory;
                ShortCutKey = 'Return';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = false;
                ToolTip = 'Open the related Available Inventorys.';

                trigger OnAction()
                var
                    InventoryAvailble: Page "RV BackedDate Stock";
                begin
                    InventoryAvailble.SetRecord(Rec);
                    InventoryAvailble.Run();
                end;
            }
        }
        /*area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Update Available Inventory_Promoted"; "Update Available Inventory")
                {
                }
            }
        }
        */
    }
}
