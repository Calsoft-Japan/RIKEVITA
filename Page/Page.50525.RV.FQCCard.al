/// <summary>
/// Page RV FQC Card (ID 50525)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50525 "RV FQC Card"
{
    Caption = 'FQC';
    PageType = Card;
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory = Documents;
    SourceTable = "RV QC Header";
    SourceTableView = WHERE("QC Type" = FILTER(FQC));

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                    trigger OnAssistEdit()
                    begin
                        RIKEVITASetup.Get();
                        RIKEVITASetup.TestField("FQC No. Nos.");
                        if (Rec."QC No." = '') then begin
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."FQC No. Nos.", Rec."QC No.") then begin
                                Rec."QC No." := NoSeries.GetNextNo(RIKEVITASetup."FQC No. Nos.");
                            end;
                        end;
                    end;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ref. Order Type"; Rec."Ref. Order Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Tan No."; Rec."Tan No.")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Standard Type"; Rec."QC Standard Type")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("QC Status"; Rec."QC Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked By"; Rec."QC Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Checked Remark"; Rec."QC Checked Remark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("QC Approved By"; Rec."QC Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
            }

            part(SubQCLine; "RV FQC Subform")
            {
                Caption = 'QC Line';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
                Editable = SubQCLineEnable;
            }
            part(SubInventoryResult; "RV FQC Iny. Result Subform")
            {
                Caption = 'Inventory Result';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
                Editable = SubInventoryResultEnable;
            }
        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"RV QC Header"),
                               "No." = field("QC No."), "Line No." = const(2);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create QC Line")
            {
                Caption = 'Create QC Line';
                ApplicationArea = All;
                Image = Create;
                Enabled = CreateQCLineEnable;

                trigger OnAction()
                begin
                    //CreateQCLine
                    Rec.CreateQCLine();
                end;
            }
            action("QC Check")
            {
                Caption = 'QC Check';
                ApplicationArea = All;
                Image = Check;
                Enabled = QCCheckEnable;

                trigger OnAction()
                begin
                    //IsQCCheckAllowed
                    Rec.IsQCCheckAllowed();

                    //CheckRemark_Input
                    Rec.CheckRemark_Input();

                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
            action("QC Approve")
            {
                Caption = 'QC Approve';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCApproveEnable;

                trigger OnAction()
                begin
                    //IsQCApproveAllowed
                    Rec.IsQCApproveAllowed();
                    //ApprovedRemark_Input
                    Rec.ApprovedRemark_Input();

                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("Create QC Line_Promoted"; "Create QC Line")
                {
                }
                actionref("QC Check_Promoted"; "QC Check")
                {
                }
                actionref("QC Approve_Promoted"; "QC Approve")
                {
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        Rec."QC Type" := Rec."QC Type"::FQC;
        Rec."Ref. Order Type" := Rec."Ref. Order Type"::"Production Order";
    end;

    trigger OnOpenPage()
    begin
        Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        QCCardEnable: Boolean;
        CreateQCLineEnable: Boolean;
        QCCheckEnable: Boolean;
        QCApproveEnable: Boolean;
        SubQCLineEnable: Boolean;
        SubInventoryResultEnable: Boolean;
}