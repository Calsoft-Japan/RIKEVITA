/// <summary>
/// Page RV NC Card (ID 50539)
/// FDD039 2026/10/09: New. (Mike)
/// </summary>
page 50539 "RV NC Card"
{
    Caption = 'NC';
    PageType = Document;
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory = Documents;
    SourceTable = "RV NC Header";
    InsertAllowed = false;
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
                    Editable = false;
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
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("location Code"; Rec."location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Inspect Bin Code"; Rec."Inspect Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Storage Bin Code"; Rec."Storage Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC location Code"; Rec."NC location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Analyzed by"; Rec."QC Analyzed by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Comment"; Rec."QC Comment")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                    MultiLine = true;
                }
                field("QC Rejected by"; Rec."QC Rejected by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Analyzed by"; Rec."NC Analyzed by")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Remark"; Rec."NC Remark")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                    MultiLine = true;
                }
                field("NC Checked By"; Rec."NC Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Checked Remark"; Rec."NC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NC Approved By"; Rec."NC Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Status"; Rec."NC Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(SubInventoryResult; "RV FQC Iny. Result Subform")
            {
                Caption = 'NC Line';
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
            action("NC Check")
            {
                Caption = 'NC Check';
                ApplicationArea = All;
                Image = Check;
                Enabled = QCCheckEnable;

                trigger OnAction()
                var
                    NCResultLine: Record "RV QC Iny. Result Line";
                    TotalNCQuantity: Decimal;
                begin
                    //IsNCCheckAllowed
                    Rec.IsNCCheckAllowed();

                    //CheckTotalQuantity
                    Rec.CheckTotalQuantity();

                    //CheckRemark_Input
                    Rec.CheckRemark_Input();

                    //Enable
                    Rec.SetQCEnable(QCCheckEnable, QCApproveEnable, SubInventoryResultEnable, QCCardEnable);
                end;
            }
            action("NC Approve")
            {
                Caption = 'NC Approve';
                ApplicationArea = All;
                Image = Approval;
                Enabled = QCApproveEnable;

                trigger OnAction()
                begin
                    //IsNCApproveAllowed
                    Rec.IsNCApproveAllowed();

                    //ApprovedRemark_Input
                    Rec.ApprovedRemark_Input();

                    //Enable
                    Rec.SetQCEnable(QCCheckEnable, QCApproveEnable, SubInventoryResultEnable, QCCardEnable);

                    Rec.testfield(Quantity);
                    Rec.testfield("Expiration Date");
                    Rec.PostItemReclassJournal(Rec.Quantity, Rec."Expiration Date");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("NC Check_Promoted"; "NC Check")
                {
                }
                actionref("NC Approve_Promoted"; "NC Approve")
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

    end;

    trigger OnOpenPage()
    begin
        Rec.SetQCEnable(QCCheckEnable, QCApproveEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetQCEnable(QCCheckEnable, QCApproveEnable, SubInventoryResultEnable, QCCardEnable);
    end;

    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RV RIKEVITA Setup";
        QCCardEnable: Boolean;
        CreateQCLineEnable: Boolean;
        QCCheckEnable: Boolean;
        QCApproveEnable: Boolean;
        QCReverseEnable: Boolean;
        SubQCLineEnable: Boolean;
        SubInventoryResultEnable: Boolean;
}