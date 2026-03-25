/// <summary>
/// Page Customer Details - Warehouse (ID 50102).
/// FDD008 2026/03/09: New. (Liuyang)
/// </summary>
page 50102 "RV Customer Details - Whs."
{
    ApplicationArea = All;
    PageType = CardPart;
    Caption = 'Customer Details - Warehouse';
    SourceTable = "Sales Header";
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(SalesOrderInfo)
            {
                ShowCaption = false;

                // "No." on Sales Header = the Sales Order number
                field("No."; Rec."No.")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Sales Order No.';
                    ToolTip = 'Specifies the sales order number linked to the selected shipment line.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number of the customer who will receive the shipment.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer who will receive the shipment.';
                }
                // Actual field name on Sales Header is "Sell-to Address"; Caption overridden
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Address';
                    ToolTip = 'Specifies the address of the customer who will receive the shipment.';
                }
                field("Sell-to Address2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies the address 2 of the customer who will receive the shipment.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'City';
                    ToolTip = 'Specifies the city of the customer''s address.';
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'County';
                    ToolTip = 'Specifies the county/state of the customer''s address.';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Post Code';
                    ToolTip = 'Specifies the postal code of the customer''s address.';
                }
                // Actual field name is "Sell-to Country/Region Code"; Caption overridden
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Country/Region';
                    ToolTip = 'Specifies the country or region of the customer''s address.';
                }
            }
        }
    }
}
