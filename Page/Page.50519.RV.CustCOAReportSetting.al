/// <summary>
/// Page RV CustCOAReportSetting (ID 50519)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50519 "RV CustCOAReportSetting"
{
    Caption = 'Customer COA Report Setting';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RV Cust. COA Report Setting";

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Display COA Date"; Rec."Display COA Date")
                {
                    ApplicationArea = All;
                }
                field("Display Quantity Per Lot."; Rec."Display Quantity Per Lot.")
                {
                    ApplicationArea = All;
                }
                field("Display Method&Chars Spec."; Rec."Display Method&Chars Spec.")
                {
                    ApplicationArea = All;
                }
                field("Date Wording"; Rec."Date Wording")
                {
                    ApplicationArea = All;
                }
                field("Date Calculation"; Rec."Date Calculation")
                {
                    ApplicationArea = All;
                }
                field("Expired Date Calc. logic"; Rec."Expired Date Calc. logic")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}