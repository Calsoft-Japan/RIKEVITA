/// <summary>
/// Page RV NC Card (ID 50539)
/// FDD039 2026/10/09: New. (Mike)
/// </summary>
page 50539 "RV NC Card"
{
    Caption = 'Non-Conformance';
    PageType = Card;
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
                field("NC location Code"; Rec."NC location Code")
                {
                    ApplicationArea = All;
                    //Editable = QCCardEnable;
                    Editable = false;
                }
                field("NC Bin Code"; Rec."Inspect Bin Code")
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
                field("NC Invy. Transfer to Bin"; Rec."NC Invy. Transfer to Bin")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                    //Editable = true;
                }
                field("Stock Transfer to Location"; Rec."Stock Transfer to Location")
                {
                    ApplicationArea = All;
                    Editable = QCCardEnable;
                    //Editable = true;
                }
                field("Stock Transfer to Bin"; Rec."Stock Transfer to Bin")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = QCCardEnable;
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
                field("NC Checked Date"; Rec."NC Checked Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Checked Remark"; Rec."NC Checked Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }
                field("NC Approved By"; Rec."NC Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Approved Date"; Rec."NC Approved Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NC Approved Remark"; Rec."NC Approved Remark")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
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
                SubPageLink = "Table ID" = const(Database::"RV NC Header"),
                               "No." = field("QC No."), "Line No." = field("QC Type");
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

                    //CheckTestField
                    Rec.CheckTestField();

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
                    Rec.testfield(Quantity);
                    Rec.testfield("Expiration Date");
                    //CheckTotalQuantity
                    Rec.CheckTotalQuantity();
                    if Rec.CheckSameLocation() then
                        Rec.PostItemReclassJournal(Rec.Quantity, Rec."Expiration Date");
                    //Enable
                    Rec.SetQCEnable(QCCheckEnable, QCApproveEnable, SubInventoryResultEnable, QCCardEnable);

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