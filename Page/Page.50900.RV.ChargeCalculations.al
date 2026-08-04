/// <summary>
/// Page RV Charge Calculations (ID 50900)
/// FDD009 2026/05/01: New. (Shawn)
/// </summary>
page 50900 "RV Charge Calculations"
{
    ApplicationArea = All;
    Caption = 'Charge Calculations';
    PageType = List;
    CardPageID = "RV Charge Calculation";
    SourceTable = "RV Charge Calc. Header";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Charge Type"; Rec."Charge Type")
                {
                }
                field(LOB; Rec.LOB)
                {
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                }
                field("Calculated By"; Rec."Calculated By")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("HTP Adjustment Price"; Rec."HTP Adjustment Price")
                {
                }
                field("01-COO"; Rec."01-COO")
                {
                }
                field("02-FORWARDING"; Rec."02-FORWARDING")
                {
                }
                field("03-FUMIGATION"; Rec."03-FUMIGATION")
                {
                }
                field("04-HEALTH"; Rec."04-HEALTH")
                {
                }
                field("05-PALLETIZING"; Rec."05-PALLETIZING")
                {
                }
                field("06-PHYTO"; Rec."06-PHYTO")
                {
                }
                field("07-STUFFING"; Rec."07-STUFFING")
                {
                }
                field("08-TRANSPORT"; Rec."08-TRANSPORT")
                {
                }
                field("09-REACH"; Rec."09-REACH")
                {
                }
                field("10-Label"; Rec."10-Label")
                {
                }
                field("11-OF"; Rec."11-OF")
                {
                }
                field("99-OTHERS"; Rec."99-OTHERS")
                {
                }
                field(FREIGHT; Rec.FREIGHT)
                {
                }
            }
        }
    }
}
