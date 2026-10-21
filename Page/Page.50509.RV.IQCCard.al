/// <summary>
/// Page RV IQC Card (ID 50509)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50509 "RV IQC Card"
{
    Caption = 'IQC';
    PageType = Card;
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory = Documents;
    SourceTable = "RV QC Header";
    SourceTableView = WHERE("QC Type" = FILTER(IQC));


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
                        RIKEVITASetup.TestField("IQC No. Nos.");
                        if (Rec."QC No." = '') then begin
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."IQC No. Nos.", Rec."QC No.") then begin
                                Rec."QC No." := NoSeries.GetNextNo(RIKEVITASetup."IQC No. Nos.");
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
                    ValuesAllowed = 0, 1;
                    Editable = QCCardEnable;
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
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("UOM"; Rec."UOM")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("Storage Bin Code"; Rec."Storage Bin Code")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                }
                field("RM Manufacture Date"; Rec."RM Manufacture Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
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
                field("QC Comment"; Rec."QC Comment")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                    MultiLine = true;
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
                field("QC Checked Date"; Rec."QC Checked Date")
                {
                    ApplicationArea = All;
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
                field("QC Approved Date"; Rec."QC Approved Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Rejected Remark"; Rec."QC Rejected Remark")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }

            part(SubQCLine; "RV IQC Subform")
            {
                Caption = 'QC Line';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
                Editable = SubQCLineEnable;
            }
            part(SubInventoryResult; "RV IQC Iny. Result Subform")
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
                              "No." = field("QC No."), "Line No." = const(0);
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

                    //CheckFail
                    if Rec.CheckFail() then
                        exit;

                    //CheckInit
                    Rec.CheckInit();

                    //CheckRemark_Input
                    Rec.CheckRemark_Input();
                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
            action("QC Approve")
            {
                Caption = 'QC Approve';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCApproveEnable;
                trigger OnAction()
                var
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                begin
                    if Rec."Ref. Order Type" = Rec."Ref. Order Type"::"Purchase Order" then begin
                        PurchRcptLine.SetRange("Order No.", Rec."Order No.");
                        PurchRcptLine.SetRange("Order Line No.", Rec."Line No.");
                        if PurchRcptLine.FindFirst() then
                            Error('Purchase Order %1, line %2 has already been received.', Rec."Order No.", Rec."Line No.");
                    end;

                    //IsQCApproveAllowed
                    Rec.IsQCApproveAllowed();

                    //CheckFail
                    if Rec.CheckFail() then
                        exit;

                    //CheckInit
                    Rec.CheckInit();

                    //ApprovedRemark_Input
                    Rec.ApprovedRemark_Input();

                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);

                    //Post Item Reclass Journal
                    if Rec."Ref. Order Type" = Rec."Ref. Order Type"::"Posted Purchase Receipt" then begin
                        Rec.TestField("Location Code");
                        Rec.TestField("Bin Code");
                        Rec.TestField("Storage Bin Code");
                        Rec.TestField("Quantity");
                        Rec.TestField("Expiration Date");
                        Rec.PostItemReclassJournal(Rec."Location Code", Rec."Location Code", Rec."Bin Code", Rec."Storage Bin Code", Rec.Quantity, Rec."Expiration Date");
                    end;
                end;
            }
            action("QC Reverse")
            {
                Caption = 'QC Reverse';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCReverseEnable;
                trigger OnAction()
                begin
                    //IsQCReverseAllowed
                    Rec.IsQCReverseAllowed();

                    Rec."QC Status" := Rec."QC Status"::Checked;
                    Rec.Modify();
                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
            action("QC Reject")
            {
                Caption = 'QC Reject';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCRejectEnable;
                trigger OnAction()
                begin
                    //IsQCRejectAllowed
                    Rec.IsQCRejectAllowed();

                    Rec."QC Status" := Rec."QC Status"::Rejected;
                    Rec.Modify();
                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
            action("NC Result")
            {
                Caption = 'NC Result';
                ApplicationArea = All;
                Image = ViewDetails;
                Enabled = NCResultEnable;

                trigger OnAction()
                begin
                    //CreateNCHeader
                    Rec.CreateNCHeader();
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
                actionref("QC Reject_Promoted"; "QC Reject")
                {
                }
                actionref("QC Reverse_Promoted"; "QC Reverse")
                {
                }
                actionref("NC Result_Promoted"; "NC Result")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";

        QCCardEnable: Boolean;
        CreateQCLineEnable: Boolean;
        QCCheckEnable: Boolean;
        QCApproveEnable: Boolean;
        QCReverseEnable: Boolean;
        QCRejectEnable: Boolean;
        NCResultEnable: Boolean;
        SubQCLineEnable: Boolean;
        SubInventoryResultEnable: Boolean;
}