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
                    ValuesAllowed = 2;
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
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
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
                field("QC Rejected By"; Rec."QC Rejected By")
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
                field("QC Rejected Date"; Rec."QC Rejected Date")
                {
                    ApplicationArea = All;
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
                begin
                    //IsQCApproveAllowed
                    Rec.IsQCApproveAllowed();

                    //CheckFail
                    if Rec.CheckFail() then
                        exit;

                    //CheckInit
                    Rec.CheckInit();
                    //check setting for post
                    Rec.TestField("Location Code");
                    Rec.TestField("Bin Code");
                    Rec.TestField("Storage Bin Code");
                    Rec.TestField("Quantity");
                    //ApprovedRemark_Input
                    Rec.ApprovedRemark_Input();
                    //Post Item Reclass Journal
                    Rec.PostItemReclassJournal(Rec."Location Code", Rec."Location Code", Rec."Bin Code", Rec."Storage Bin Code", Rec.Quantity, Rec."Expiration Date");

                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);

                end;
            }
            action("QC Reverse")
            {
                Caption = 'QC Reverse';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCReverseEnable;
                trigger OnAction()
                var
                    oldStatus: Enum "RV QC Status";
                begin
                    //IsQCReverseAllowed
                    Rec.IsQCReverseAllowed();

                    oldStatus := Rec."QC Status";
                    Rec.TestField("Location Code");
                    Rec.TestField("Bin Code");
                    Rec.TestField("Storage Bin Code");
                    Rec.TestField("Quantity");
                    // Rec.TestField("Expiration Date");
                    if oldStatus = oldStatus::Approved then
                        Rec.PostItemReclassJournal(Rec."Location Code", Rec."Location Code", Rec."Storage Bin Code", Rec."Bin Code", Rec.Quantity, Rec."Expiration Date");
                    if oldStatus = oldStatus::Rejected then begin
                        RIKEVITASetup.Get();
                        RIKEVITASetup.TestField("NC Location Code");
                        RIKEVITASetup.TestField("NC Bin Code");
                        Rec.PostItemReclassJournal(RIKEVITASetup."NC Location Code", Rec."Location Code", RIKEVITASetup."NC Bin Code", rec."Bin Code", Rec.Quantity, Rec."Expiration Date");
                    end;
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
                    //Check setting for reject posting
                    RIKEVITASetup.Get();
                    RIKEVITASetup.TestField("NC Location Code");
                    RIKEVITASetup.TestField("NC Bin Code");
                    Rec.TestField("Location Code");
                    Rec.TestField("Bin Code");
                    // Rec.TestField("Storage Bin Code");
                    Rec.TestField("Quantity");
                    // Rec.TestField("Expiration Date");

                    //RejectedRemark_Input
                    Rec.RejectedRemark_Input();

                    Rec."QC Status" := Rec."QC Status"::Rejected;
                    Rec.Modify();
                    //Enable
                    Rec.SetQCEnable(CreateQCLineEnable, QCCheckEnable, QCApproveEnable, QCReverseEnable, QCRejectEnable, NCResultEnable, SubQCLineEnable, SubInventoryResultEnable, QCCardEnable);

                    Rec.PostItemReclassJournal(Rec."Location Code", RIKEVITASetup."NC Location Code", Rec."Bin Code", RIKEVITASetup."NC Bin Code", Rec.Quantity, Rec."Expiration Date");
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