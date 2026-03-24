/// <summary>
/// Page RV Posted Prod. Result Journal Line (ID 50602)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
page 50602 "RV Pst. Prod. Resul Jnl Line"
{
    ApplicationArea = All;
    Caption = 'RV Posted Prod. Result Journal Line';
    PageType = Worksheet;
    SourceTable = "RV Pst. Prod. Res. Jnl. Line";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.', Comment = '%';
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
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ToolTip = 'Specifies the value of the Manufacturing Date field.', Comment = '%';
                }
                field("Expire Date"; Rec."Expire Date")
                {
                    ToolTip = 'Specifies the value of the Expire Date field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Cal)
            {
                Caption = 'Cal. Prod. Jouornal';
                Image = Calculate;

                trigger OnAction()
                begin

                end;
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Request)
                {

                    Caption = 'Approval Request';
                    Image = Approve;

                    trigger OnAction()
                    begin

                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        CurrentJnlBatchName: Code[10];
        RVProdResultsMgt: Codeunit "RV Prod. Results Management";
        OpenedFromBatch: Boolean;
}
