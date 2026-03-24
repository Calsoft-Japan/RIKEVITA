/// <summary>
/// Page RV Prod. Result Journal Line (ID 50601)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
page 50601 "RV Prod. Result Journal Line"
{
    ApplicationArea = All;
    Caption = 'RV Prod. Result Journal Line';
    PageType = Worksheet;
    SourceTable = "RV Prod. Result Journal Line";
    UsageCategory = Tasks;
    AutoSplitKey = true;
    DelayedInsert = true;
    SaveValues = true;

    layout
    {
        area(Content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    RVProdResultsMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    RVProdResultsMgt.CheckName(CurrentJnlBatchName, Rec);
                end;

            }
            repeater(General)
            {
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.', Comment = '%';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                }
                field("Output Item No."; Rec."Output Item No.")
                {
                    ToolTip = 'Specifies the value of the Output Item No. field.', Comment = '%';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ToolTip = 'Specifies the value of the Operation No. field.', Comment = '%';
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ToolTip = 'Specifies the value of the Work Center No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Scrap Quantity"; Rec."Scrap Quantity")
                {
                    ToolTip = 'Specifies the value of the Scrap Quantity field.', Comment = '%';
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ToolTip = 'Specifies the value of the Manufacturing Date field.', Comment = '%';
                }
                field("Expire Date"; Rec."Expire Date")
                {
                    ToolTip = 'Specifies the value of the Expire Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Line No. field.', Comment = '%';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ToolTip = 'Specifies the value of the Routing No. field.', Comment = '%';
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Comp. Line No. field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Imported Date';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalProdJouornal)
            {
                Caption = 'Cal. Prod. Jouornal';
                Image = Calculate;

                trigger OnAction()
                var
                    ProdResultLine: Record "RV Prod. Result Journal Line";
                    CalcConsumption: Report "RV Calc. Consumption";
                begin
                    CurrPage.SetSelectionFilter(ProdResultLine);
                    ProdResultLine.SetFilter("Data Type", '%1|%2', ProdResultLine."Data Type"::"Adjust Output", ProdResultLine."Data Type"::"Planned Output");
                    CalcConsumption.SetTableView(ProdResultLine);
                    CalcConsumption.RunModal();
                end;
            }

            group(ApprovalRequest)
            {
                Caption = 'Approve Request';
                action(SendApprovalRequest)
                {

                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange("Data Type", ProdResultLine."Data Type"::"Adjust Consumption");
                        ProdResultLine.SetFilter(Status, '%1|%2', ProdResultLine.Status::Rejected, ProdResultLine.Status::Preparing);
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::"Pending Approve");
                    end;
                }
                action(CancelApprovalRequest)
                {

                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Preparing);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approve';
                action(Approve)
                {

                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Approved);
                    end;
                }
                action(RejectApprovalRequest)
                {

                    Caption = 'Reject Approval Request';
                    Image = Reject;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Rejected);
                    end;
                }
                action(CancelApprovalRequestForApprover)
                {

                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        ProdResultLine: Record "RV Prod. Result Journal Line";
                    begin
                        ProdResultLine.Reset();
                        CurrPage.SetSelectionFilter(ProdResultLine);
                        ProdResultLine.SetRange("Data Type", ProdResultLine."Data Type"::"Adjust Consumption");
                        ProdResultLine.SetRange(Status, ProdResultLine.Status::"Pending Approve");
                        if not ProdResultLine.IsEmpty then
                            ProdResultLine.ModifyAll(Status, ProdResultLine.Status::Preparing);
                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;

                trigger OnAction()
                var
                    PostProdResultLineBatch: codeunit "RV Post Prod Result Line Batch";
                begin
                    PostProdResultLineBatch.Run();
                end;
            }
        }
        area(Promoted)
        {

            actionref(CalProdJouornal_Promoted; CalProdJouornal)
            {

            }
            group(ApprovalRequestGrp)
            {
                Caption = 'Approve Request';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {

                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {

                }
            }
            group(ApproveGrp)
            {
                Caption = 'Approve';
                actionref(Approve_Promoted; Approve)
                {

                }
                actionref(RejectApprovalRequest_Promoted; RejectApprovalRequest)
                {

                }
                actionref(CancelApprovalRequestForApprover_Promoted; CancelApprovalRequestForApprover)
                {
                }
            }
            actionref(Post_Promoted; Post)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        OpenedFromBatch := (Rec."Batch Name" <> '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Batch Name";
            RVProdResultsMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        RVProdResultsMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        CurrentJnlBatchName: Code[10];
        RVProdResultsMgt: Codeunit "RV Prod. Results Management";
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        RVProdResultsMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}
