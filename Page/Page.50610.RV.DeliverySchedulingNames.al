/// <summary>
/// Page RV Invy. Planning Names (ID 50404).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>

page 50610 "RV Invy. Planning Names"
{
    ApplicationArea = All;
    Caption = 'Inventory Planning';
    PageType = List;
    usagecategory = Lists;
    SourceTable = "RV Invy. Planning Name";

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
                    caption = 'Inventory Planning Starting Date';
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Item Filter"; Rec."Item Filter")
                {
                    ToolTip = 'Specifies the value of the Item Filter field.', Comment = '%';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(ItemList);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text := ItemList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Calculate Inventory Planning")
            {
                ApplicationArea = Planning;
                Caption = 'Calculate Inventory Planning';
                Image = CalculateInventory;
                ShortCutKey = 'Return';
                ToolTip = 'Open the related delivery Scheduling.';

                trigger OnAction()
                var
                    RMDeliveryScheduling: Page "RV Invy. Planning Name";
                begin
                    RMDeliveryScheduling.SetRecord(Rec);
                    RMDeliveryScheduling.Run();
                end;
            }

        }
        area(Promoted)
        {
            actionref(CalculateInventoryPlanning_prompt; "Calculate Inventory Planning")
            {

            }
        }
    }
}
