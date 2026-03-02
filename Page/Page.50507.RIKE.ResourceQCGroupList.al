/// <summary>
/// Page RIKE Resource QC Group List (ID 50507).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50507 "RIKE Resource QC Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Resource QC Group List';
    SourceTable = "RIKE Resource QC Group";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                    ApplicationArea = All;
                }
                field("QC Group No."; Rec."QC Group No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}