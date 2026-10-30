/// <summary>
/// Page RV QC Resource Group List (ID 50506).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50506 "RV QC Resource Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Resource Group List';
    SourceTable = "RV QC Resource Group";
    SourceTableView = sorting("QC Resource Group No.");

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("QC Resource Group No."; Rec."QC Resource Group No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Internal Specification"; Rec."Internal Specification")
                {
                    ApplicationArea = All;
                }
                field("External Specification"; Rec."External Specification")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(QCResourceGroupRemarks)
            {
                Caption = 'QC Resource Group Remarks';
                ApplicationArea = All;
                Image = Create;
                RunObject = Page "RV QC Resource Group Remarks";
                RunPageLink = "QC Resource Group No." = field("QC Resource Group No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("QCResourceGroupRemarks_Promoted"; "QCResourceGroupRemarks")
                {
                }
            }
        }
    }
}