page 50499 "OB Data Update Tool"
{
    ApplicationArea = All;
    Caption = 'OB Data Update Tool';
    PageType = Card;
    RefreshOnActivate = true;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Purchase Price Verify Line")
            {
                ApplicationArea = all;
                Caption = 'Purchase Price Verify Line';
                Image = CalculateInventory;
                ShortCutKey = 'Update';
                ToolTip = 'Update Purchase Price Lines';

                trigger OnAction()
                var
                    PriceListLine: Record "Price List Line";
                begin
                    PriceListLine.Reset();
                    priceListLine.SetRange("price Type", PriceListLine."price Type"::Purchase);
                    if PriceListLine.FindSet() then
                        repeat
                            PriceListLine.Verify();
                        until PriceListLine.Next() = 0;
                end;
            }
            action("Sales Price Verify Line")
            {
                ApplicationArea = all;
                Caption = 'Sales Price Verify Line';
                Image = CalculateInventory;
                ShortCutKey = 'Update';
                ToolTip = 'Update Sales Price Lines';

                trigger OnAction()
                var
                    PriceListLine: Record "Price List Line";
                begin
                    PriceListLine.Reset();
                    priceListLine.SetRange("price Type", PriceListLine."price Type"::Sale);
                    if PriceListLine.FindSet() then
                        repeat
                            PriceListLine.Verify();
                        until PriceListLine.Next() = 0;
                end;
            }
        }
    }

}
