namespace RIKEVITA.RIKEVITA;

page 50404 "Delivery Scheduling Names"
{
    ApplicationArea = All;
    Caption = 'Delivery Scheduling Names';
    PageType = List;
    usagecategory = Lists;
    SourceTable = "RM Delivery Scheduling Name";

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
            action("Update Delivery Scheduling")
            {
                ApplicationArea = Planning;
                Caption = 'Update Delivery Scheduling';
                Image = Delivery;
                ShortCutKey = 'Return';
                ToolTip = 'Open the related delivery Scheduling.';

                trigger OnAction()
                var
                    RMDeliveryScheduling: Page "RV.RM Delivery Scheduling";
                begin
                    RMDeliveryScheduling.SetRecord(Rec);
                    RMDeliveryScheduling.Run();
                end;
            }
        }
    }
}
