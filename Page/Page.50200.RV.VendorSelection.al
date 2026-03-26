/// <summary>
/// Page RIKE Vendor Selection (ID 50200).
/// COMMON 2026/03/18: New. (Bobby.ji)
/// </summary>
page 50200 "RV Vendor Selection"
{
    ApplicationArea = All;
    Caption = 'Vendor Selection';
    PageType = Card;
    UsageCategory = Lists;
    SourceTable = "RV Vendor Selection";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Quantity"; RecQuantity)
                {
                    Caption = 'Quantity';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Total Split Quantity"; Rec."Total Split Quantity")
                {
                    Caption = 'Total Split Quantity';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Balance Quantity"; RecQuantity - Rec."Total Split Quantity")
                {
                    Caption = 'Balance Quantity';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
            }
            part(VendorSelectionLines; "RV Vendor Selection Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Journal Batch Name" = field("Journal Batch Name"), "Line No." = field("Line No."), "Item No." = field("Item No.");
                UpdatePropagation = Both;
            }
        }
    }
    var
        RecQuantity: Decimal;

    procedure SetParameters(Quantity: Decimal)
    begin
        RecQuantity := Quantity;
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if RecQuantity - Rec."Total Split Quantity" <> 0 then begin
            Error('Balance Quantity must be 0 before you close this page.');
        end;
    end;

}

