/// <summary>
/// Page RV Item Balance by Vendor (ID 50904)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
page 50904 "RV Item Balance by Vendor"
{
    ApplicationArea = All;
    Caption = 'Item Balance by Vendor';
    PageType = List;
    SourceTable = "RV Item Balance by Vendor";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("History Entry No."; Rec."History Entry No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                }
                field("Opening Balance (BUOM)"; Rec."Opening Balance (BUOM)")
                {
                }
                field("Closing Balance (BUOM)"; Rec."Closing Balance (BUOM)")
                {
                }
                field("Opening Balance (KG)"; Rec."Opening Balance (KG)")
                {
                }
                field("Closing Balance (KG)"; Rec."Closing Balance (KG)")
                {
                }
                field("Opening Balance (RM)"; Rec."Opening Balance (RM)")
                {
                }
                field("Closing Balance (RM)"; Rec."Closing Balance (RM)")
                {
                }
                field("Note"; Rec."Note")
                {
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group(History)
            {
                Caption = 'History';
                Image = Confirm;
                action("Item Trace Details")
                {
                    ApplicationArea = ALL;
                    Caption = 'Item Trace Details';
                    Image = ChangeToLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        recItemDetail: Record "RV Item Trace Detail";
                    begin
                        recItemDetail.RESET;
                        recItemDetail.SETRANGE("History Entry No.", Rec."History Entry No.");
                        recItemDetail.FINDFIRST();
                        PAGE.RUN(Page::"RV Item Trace Detail", recItemDetail);
                    end;
                }
            }
        }
    }

}
