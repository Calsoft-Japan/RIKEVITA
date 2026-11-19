/// <summary>
/// PageExtension RV_ItemReclassJnl (ID 50910) extends "Item Reclass. Journal"
/// FDD102 2026/11/19: New. (Shawn) 
/// </summary>
pageextension 50910 "RV_ItemReclassJnl Ext" extends "Item Reclass. Journal"
{
    actions
    {
        addafter("&Print")
        {
            action("PrintBinMovement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Bin Movement';
                Ellipsis = true;
                Image = PrintExcise;

                trigger OnAction()
                begin
                    Rec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    Rec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    Report.RunModal(Report::"RV Item Reclass. for Whse", true, true, Rec);
                end;

            }
        }

        addafter("&Print_Promoted")
        {

            actionref("PrintBinMovement_Promoted"; "PrintBinMovement")
            {
            }
        }
    }
}
