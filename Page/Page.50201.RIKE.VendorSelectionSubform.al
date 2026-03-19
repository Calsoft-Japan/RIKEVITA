/// <summary>
/// Page RIKE Vendor Selection Subform (ID 50201).
/// COMMON 2026/03/18: New. (Bobby.ji)
/// </summary>
page 50201 "RIKEV Vendor Selection Subform"
{
    ApplicationArea = All;
    Caption = 'Vendor Selection Lines';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "RIKE Vendor Selection";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    AutoSplitKey = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                    Description = 'FDD002';
                    ApplicationArea = All;
                    NotBlank = true;
                    TableRelation = Vendor;
                }
                field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                {
                    Caption = 'Minimum Order Quantity';
                    Description = 'FDD002';
                    ApplicationArea = All;
                }
                field("Maxmum Order Quantity"; Rec."Maxmum Order Quantity")
                {
                    Caption = 'Maxmum Order Quantity';
                    Description = 'FDD002';
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
                    end;

                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    Description = 'FDD002';
                    ApplicationArea = All;
                }
            }

        }
    }


}

