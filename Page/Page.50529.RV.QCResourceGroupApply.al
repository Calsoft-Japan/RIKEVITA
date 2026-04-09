/// <summary>
/// Page RV QC Resource Group Apply (ID 50529).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50529 "RV QC Resource Group Apply"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Resource Group Apply';
    SourceTable = "RV QC Resource Group Apply";
    SourceTableView = sorting("Item No.");
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("QC Resource Group No."; Rec."QC Resource Group No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}