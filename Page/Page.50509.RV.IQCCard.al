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
    DelayedInsert = true;
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
                    trigger OnAssistEdit()
                    begin
                        if (Rec."QC No." = '') then begin
                            RIKEVITASetup.Get();
                            RIKEVITASetup.TestField("QC No. Nos.");
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."QC No. Nos.", Rec."QC No.") then begin
                                Rec."QC No." := NoSeries.GetNextNo(RIKEVITASetup."QC No. Nos.");
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
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                }
                field("QC Standard Type"; Rec."QC Standard Type")
                {
                    ApplicationArea = All;
                }
                field("QC Status"; Rec."QC Status")
                {
                    ApplicationArea = All;
                }
                field("QC Checked By"; Rec."QC Checked By")
                {
                    ApplicationArea = All;
                }
                field("QC Approved By"; Rec."QC Approved By")
                {
                    ApplicationArea = All;
                }
                field("QC Approved Remark"; Rec."QC Approved Remark")
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
            }

            part(SubQCLine; "RV IQC Subform")
            {
                Caption = 'QC Line';
                ApplicationArea = All;
                SubPageLink = "QC No." = field("QC No."), "QC Type" = field("QC Type");
                UpdatePropagation = Both;
            }
            part(SubInventoryResult; "RV IQC Iny. Result Subform")
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
                SubPageLink = "Table ID" = const(Database::"RV QA Header"),
                              "No." = field("QC No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    trigger OnOpenPage()
    var

    begin

    end;


    var
        NoSeries: Codeunit "No. Series";
        RIKEVITASetup: Record "RIKEVITA Setup";

}