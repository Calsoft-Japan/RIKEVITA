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
    SourceTableView = sorting("Period Code", "Item No.");

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
                field("Direct Dep. Exp."; Rec."Direct Dep. Exp.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Direct Dep. Exp.';
                }
                field("Direct Fixed Cost"; Rec."Direct Fixed Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Direct Fixed Cost.';
                }
                field("Direct Labor Cost"; Rec."Direct Labor Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Direct Labor Cost';
                }
                field("Electricity Fee"; Rec."Electricity Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Electricity Fee';
                }
                field("Gas Fee"; Rec."Gas Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Gas Fee';
                }
                field("Indirect Cost"; Rec."Indirect Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indirect Cost';
                }
                field("Raw Material Cost"; Rec."Raw Material Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Raw Material Cost';
                }
                field("Package Material Cost"; Rec."Package Material Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Package Material Cost';
                }
                field("Water"; Rec."Water")
                {
                    ApplicationArea = All;
                    ToolTip = 'Water';
                }
                field("Total Standard Cost"; Rec."Total Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Standard Cost';
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