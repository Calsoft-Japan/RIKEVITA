/// <summary>
/// Page RIKE Vendor Selection (ID 50200).
/// COMMON 2026/03/18: New. (Bobby.ji)
/// </summary>
page 50200 "RV Vendor Selection"
{
    ApplicationArea = All;
    Caption = 'Vendor Selection';
    PageType = Worksheet;
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
            repeater(VendorSelectionLines)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    NotBlank = true;
                    TableRelation = "Item Vendor" where("Item No." = field("Item No."));
                }
                field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                {
                    Caption = 'Minimum Order Quantity';
                    Description = 'FDD002';
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                {
                    Caption = 'Maximum Order Quantity';
                    Description = 'FDD002';
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Quantity to Order"; Rec."Quantity to Order")
                {
                    Caption = 'Quantity to Order';
                    Description = 'FDD002';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        Rec.CalcFields("Total Split Quantity");
                        if (RecQuantity - Rec."Total Split Quantity" < 0) and (Rec."Total Split Quantity" <> 0) then begin
                            Message('Balance Quantity must be 0 before you close this page.');
                        end;
                    end;

                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    Enabled = false;
                }
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

        if (RecQuantity - Rec."Total Split Quantity" > 0) and (Rec."Total Split Quantity" <> 0) then begin
            Error('Balance Quantity must be 0 before you close this page.');
        end;

    end;

}

