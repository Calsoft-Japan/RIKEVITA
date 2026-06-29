/// <summary>
/// Page RV Posted Prod. Result Journal Line (ID 50602)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
page 50602 "RV Pst. Prod. Resul Jnl Line"
{
    ApplicationArea = All;
    Caption = 'Posted Prod. Result Journal';
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
                field("Output Item Description"; Rec."Output Item Description")
                {
                    ToolTip = 'Specifies the value of the Output Item Description field.', Comment = '%';
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
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
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
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ToolTip = 'Specifies the value of the Routing No. field.', Comment = '%';
                    Editable = false;
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order Comp. Line No. field.', Comment = '%';
                    Editable = false;
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
