/// <summary>
/// PageExtension RIKE Purchase Order Ext"(ID 50101) extends "Purchase Order" Page
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
pageextension 50101 "RV Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Remit-to")
        {
            group("RIKE")
            {
                ShowCaption = false;
                field(RV_ETA; Rec."RV ETA")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
                field(RV_ETD; Rec."RV ETD")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
                field("RV_Contract Month"; Rec."RV Contract Month")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
                field("RV_Contract Year"; Rec."RV Contract Year")
                {
                    ApplicationArea = All;
                    Description = 'FDD003';
                }
            }

        }
    }

    /// <summary>
    /// FDD003 2026/03/08: New. (Liuyang)
    /// Init "RV_Contract Month" and "RV_Contract Year" fields to current year and month.
    /// </summary>
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."RV Contract Month" := Enum::"RV Month".FromInteger(Today.Month);
        Rec."RV Contract Year" := Today.Year;
    end;
}
