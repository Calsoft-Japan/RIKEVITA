/// <summary>
/// Page RV External Spec. Description (ID 50530).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50530 "RV External Spec. Description"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'External Spec. Description';
    SourceTable = "RV External Spec. Description";
    //SourceTableView = sorting("QC Resource Group No.");
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
                field("External Spec. Name"; Rec."External Spec. Name")
                {
                    ApplicationArea = All;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Description"; Rec."Customer Description")
                {
                    ApplicationArea = All;
                }
                field("Characteristic Specification"; Rec."Characteristic Specification")
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}