/// <summary>
/// Page RV PQC Card (ID 50521)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50521 "RV PQC Card"
{
    Caption = 'PQC';
    PageType = Document;
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory = Documents;
    SourceTable = "RV QC Header";
    SourceTableView = WHERE("QC Type" = FILTER(PQC));

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
                    trigger OnAssistEdit()
                    begin
                        RIKEVITASetup.Get();
                        RIKEVITASetup.TestField("PQC No. Nos.");
                        if (Rec."QC No." = '') then begin
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."PQC No. Nos.", Rec."QC No.") then begin
                                Rec."QC No." := NoSeries.GetNextNo(RIKEVITASetup."PQC No. Nos.");
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
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                }
                field("Tan No."; Rec."Tan No.")
                {
                    ApplicationArea = All;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QC Standard Type"; Rec."QC Standard Type")
                {
                    ApplicationArea = All;
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
                    Editable = false;
                }
            }

            part(SubQCLine; "RV PQC Subform")
            {
                Caption = 'QC Line';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
            }
            part(SubInventoryResult; "RV PQC Iny. Result Subform")
            {
                Caption = 'Inventory Result';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
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
                               "No." = field("QC No."), "Line No." = const(1);
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

                trigger OnAction()
                begin
                    //IsQCCheckAllowed
                    Rec.IsQCCheckAllowed();

                    //CheckRemark_Input
                    Rec.CheckRemark_Input();
                end;
            }
            action("QC Approve")
            {
                Caption = 'QC Approve';
                ApplicationArea = All;
                Image = Approval;

                trigger OnAction()
                begin
                    //IsQCApproveAllowed
                    Rec.IsQCApproveAllowed();

                    //ApprovedRemark_Input
                    Rec.ApprovedRemark_Input();
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
        RIKEVITASetup: Record "RIKEVITA Setup";
    begin
        Rec."QC Type" := Rec."QC Type"::PQC;
        Rec."Ref. Order Type" := Rec."Ref. Order Type"::"Production Order";
    end;

    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RIKEVITA Setup";
}