/// <summary>
/// Page RV QC Customer External Spec. (ID 50507).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50507 "RV QC Customer External Spec."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'QC Customer External Spec.';
    SourceTable = "RV QC Customer External Spec.";
    SourceTableView = sorting("QC Resource Group No.", "Customer No.", "Ship-to Code");
    DelayedInsert = true;

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
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
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
}