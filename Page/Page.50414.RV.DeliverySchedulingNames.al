namespace RIKEVITA.RIKEVITA;

page 50414 "RV Invy. Planning Names"
{
    ApplicationArea = All;
    Caption = 'Inventory Planning Names';
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
    }
}
