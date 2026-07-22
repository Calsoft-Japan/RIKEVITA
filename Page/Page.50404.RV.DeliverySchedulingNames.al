page 50404 "RV Invy. Planning Names"
{
    ApplicationArea = All;
    Caption = 'Inventory Planning Name';
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
}
