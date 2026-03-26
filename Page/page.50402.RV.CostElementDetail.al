/// <summary>
/// Page RV Cost Element Details (ID 50402).
/// FDD034 2026/03/19: New. (Vani)
/// </summary>
page 50402 "Standard Cost Element Details"
{
    PageType = List;
    SourceTable = "Standard Cost Element Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = sorting("Period Code", "Site", "Item No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Code"; Rec."Period Code")
                {
                    TableRelation = "Standard Cost Element Period";
                }
                field("Site"; Rec."Site")
                {
                    ApplicationArea = All;
                    ToolTip = 'Site(ACC_SITE)';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item No.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Description(FlowField).';
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unit of Measure Code(FlowField).';
                    Editable = false;
                }
                field("Cost Element Code"; Rec."Cost Element Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cost Element Code';
                }
                field("Standard Cost"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Standard Cost for the selected Cost Element';
                    DecimalPlaces = 0 : 9;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PeriodFilter: Text[20];
    begin
        // Set default filter value for Period Code as current active period
        PeriodFilter := Rec.GetFilter("Period Code");
        if PeriodFilter = '' then
            Error('Open this page from Standard Cost Element Period using the Details action');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Keep the Period Code same as the filter value when user tries to add new record from the page
        Rec."Period Code" := CopyStr(Rec."Period Code", 1, MaxStrLen(Rec."Period Code"));
    end;
}