/// <summary>
/// Page Warehouse Packing Info (ID 50205).
/// FDD019 2026/04/24: New. (Bobby.ji)
/// </summary>
page 50205 "Warehouse Packing Info"
{
    ApplicationArea = All;
    Caption = 'Warehouse Packing Info';
    PageType = ListPlus;
    //UsageCategory = Lists;
    SourceTable = "RV Warehouse Packing Info.";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    Caption = 'Sales Order No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SO Line No."; Rec."SO Line No.")
                {
                    Caption = 'SO Line No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Case No."; Rec."Case No.")
                {
                    Caption = 'Case No.';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("No. of Packages"; Rec."No. of Packages")
                {
                    Caption = 'No. of Packages';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Contents Per Package"; Rec."Contents Per Package")
                {
                    Caption = 'Contents Per Package';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Contents UOM"; Rec."Contents UOM")
                {
                    Caption = 'Contents UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    Caption = 'Net Weight';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    Caption = 'Gross Weight';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Gross Weight UOM"; Rec."Gross Weight UOM")
                {
                    Caption = 'Gross Weight UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field(Measurement; Rec.Measurement)
                {
                    Caption = 'Measurement';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
                field("Measurement UOM"; Rec."Measurement UOM")
                {
                    Caption = 'Measurement UOM';
                    Description = 'FDD019';
                    ApplicationArea = All;
                }
            }

        }

    }

}

