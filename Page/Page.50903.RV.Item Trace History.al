/// <summary>
/// Page RV Item Trace History (ID 50903)
/// FDD028 2026/05/17: New. (Shawn)
/// </summary>
page 50903 "RV Item Trace History"
{
    ApplicationArea = All;
    Caption = 'Item Trace Histories';
    PageType = List;
    SourceTable = "RV Item Trace History";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {

                }
                field("Start Date"; Rec."Start Date")
                {

                }
                field("End Date"; Rec."End Date")
                {

                }
                field("Collected On"; Rec."Collected On")
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
                action("Collect")
                {
                    ApplicationArea = ALL;
                    Caption = 'Collect';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        repCollect: Report "RV Item Trace Collect";
                        cuItemTraceMgt: Codeunit "RV ILE Item Trace Mgt";
                    begin
                        Clear(cuItemTraceMgt);
                        cuItemTraceMgt.Run();

                        //Need commit before run report
                        Commit();

                        Clear(repCollect);
                        repCollect.RunModal();
                    end;
                }

                action("Item Balance by Vendor")
                {
                    ApplicationArea = ALL;
                    Caption = 'Item Balance by Vendor';
                    Image = ChangeToLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        recItemBalance: Record "RV Item Balance by Vendor";
                    begin
                        recItemBalance.RESET;
                        recItemBalance.SETRANGE("History Entry No.", Rec."Entry No.");
                        recItemBalance.FINDFIRST();
                        PAGE.RUN(Page::"RV Item Balance by Vendor", recItemBalance);
                    end;
                }

                action("Delete")
                {
                    ApplicationArea = ALL;
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        recItemBalance: Record "RV Item Balance by Vendor";
                        recItemDetail: Record "RV Item Trace Detail";
                        DeleteAllQst: Label 'Click Yes will delete all data of this History No.';
                    begin

                        if not Confirm(DeleteAllQst, false) then begin
                            exit;
                        end;

                        recItemDetail.RESET;
                        recItemDetail.SetRange("History Entry No.", Rec."Entry No.");
                        recItemDetail.DeleteAll();

                        recItemBalance.RESET;
                        recItemBalance.SETRANGE("History Entry No.", Rec."Entry No.");
                        recItemBalance.DeleteAll();

                        Rec.Delete();
                    end;
                }
            }
        }
    }

}
