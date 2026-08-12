page 50408 "RV Inventory Valuation Line"
{
    ApplicationArea = All;
    Caption = 'Inventory Valuation Line';
    PageType = ListPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    modifyAllowed = false;
    LinksAllowed = true;
    SourceTable = "RV.Inventory Valuation Line";
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }

                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field(Segment; Rec.Segment)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Starting Balance Quantity"; Rec."Starting Balance Quantity")
                {
                    ToolTip = 'Specifies the value of the Starting Balance Quantity field.', Comment = '%';
                }
                field("Starting Balance Amount"; Rec."Starting Balance Amount")
                {
                    ToolTip = 'Specifies the value of the Starting Balance Amount field.', Comment = '%';
                }

                field("Period Order Quantity"; Rec."Period Order Quantity")
                {
                    ToolTip = 'Specifies the value of the Period Order Quantity field.', Comment = '%';
                }
                field("Period Order Amount"; Rec."Period Order Amount")
                {
                    ToolTip = 'Specifies the value of the Period Order Amount field.', Comment = '%';
                }
                field("Period Credit Quantity"; Rec."Period Credit Quantity")
                {
                    ToolTip = 'Specifies the value of the Return Outward Quantity field.', Comment = '%';
                }
                field("Period Order Credit Amount"; Rec."Period Order Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Return Outward Amount field.', Comment = '%';
                }
                field("Consumption Quantity"; Rec."Consumption Quantity")
                {
                    ToolTip = 'Specifies the value of the Consumption Quantity field.', Comment = '%';
                }
                field("Consumption Amount"; Rec."Consumption Amount")
                {
                    ToolTip = 'Specifies the value of the Consumption Amount field.', Comment = '%';
                }
                field("Sample Dispose Quantity"; Rec."Sample Dispose Quantity")
                {
                    ToolTip = 'Specifies the value of the Sample Dispose Quantity field.', Comment = '%';
                }
                field("Sample Dispose Amount"; Rec."Sample Dispose Amount")
                {
                    ToolTip = 'Specifies the value of the Sample Dispose Amount field.', Comment = '%';
                }
                field("Transfer Amount"; Rec."Transfer Amount")
                {
                    ToolTip = 'Specifies the value of the Transfer Amount field.', Comment = '%';
                }
                field("Transfer Quantity"; Rec."Transfer Quantity")
                {
                    ToolTip = 'Specifies the value of the Transfer Quantity field.', Comment = '%';
                }
                field("Variance Quantity"; Rec."Variance Quantity")
                {
                    ToolTip = 'Specifies the value of the Variance Quantity field.', Comment = '%';
                }
                field("Variance Amount"; Rec."Variance Amount")
                {
                    ToolTip = 'Specifies the value of the Variance Amount field.', Comment = '%';
                }
                field("Waste Scrap Quantity"; Rec."Waste Scrap Quantity")
                {
                    ToolTip = 'Specifies the value of the Waste Scrap Quantity field.', Comment = '%';
                }
                field("Waste Scrap Amount"; Rec."Waste Scrap Amount")
                {
                    ToolTip = 'Specifies the value of the Waste Scrap Amount field.', Comment = '%';
                }

                field("Ending Balance Quantity"; Rec."Ending Balance Quantity")
                {
                    ToolTip = 'Specifies the value of the Ending Balance Quantity field.', Comment = '%';
                }
                field("Ending Balance Amount"; Rec."Ending Balance Amount")
                {
                    ToolTip = 'Specifies the value of the Ending Balance Amount field.', Comment = '%';
                }
            }
        }
    }
}
