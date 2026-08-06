/// <summary>
/// Page RV Invy. Planning Name (ID 50405).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>

page 50611 "RV Invy. Planning Name"
{
    ApplicationArea = All;
    Caption = 'Inventory Planning Name';
    PageType = Card;
    UsageCategory = tasks;
    SourceTable = "RV Invy. Planning Name";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("starting Date"; Rec."Starting Date")
                {
                    caption = 'Delivery Scheduling Starting Date';
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                // field(site; Rec.Site)
                // {
                //     CaptionClass = '1,3,1';
                //     ToolTip = 'Specifies the global dimension 1 filter that will be used to create the worksheet.';

                //     trigger OnLookup(var Text: Text): Boolean
                //     var
                //         DimVal: Record "Dimension Value";
                //         DimValList: Page "Dimension Value List";
                //     begin
                //         Clear(DimValList);
                //         DimVal.SetRange("Global Dimension No.", 1);
                //         DimValList.SetTableView(DimVal);
                //         DimValList.LookupMode(true);
                //         if DimValList.RunModal() = Action::LookupOK then begin
                //             Text := DimValList.GetSelectionFilter();
                //             exit(true);
                //         end else
                //             exit(false);
                //     end;
                // }
                field("Item Filter"; Rec."Item Filter")
                {
                    caption = 'Item Filter';
                    ToolTip = 'Specifies the value of the Item Filter field.', Comment = '%';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(ItemList);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text := ItemList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
            }
            Part(DeliverySchedulingLines; "RV Invy. Planning Lines")
            {
                ApplicationArea = All;
                Caption = 'Delivery Scheduling Lines';
                UpdatePropagation = Both;
                SubPageLink = "Delivery Scheduling Name" = field(Name);
            }

        }

    }
    actions
    {
        area(processing)
        {
            action("Collect Data")
            {
                Caption = 'Collect Data';
                ApplicationArea = All;
                Image = Create;
                trigger OnAction()
                var
                    ProdOrderComponent: Record "Prod. Order Component";
                    ProdOrderComponent1: Record "Prod. Order Component";
                    Vendor: Record Vendor;
                    Item: Record Item;
                    DeliverySchedulingLine: record "RV Invy. Planning Line";
                    EntryNo: Integer;
                    ItemNo: Code[20];
                    SITECODE: Code[20];
                begin
                    Rec.TestField("Starting Date");
                    DeliverySchedulingLine.Reset();
                    DeliverySchedulingLine.SetRange("Delivery Scheduling Name", Rec.Name);
                    DeliverySchedulingLine.DeleteAll();
                    DeliverySchedulingLine."Delivery Scheduling Name" := Rec.Name;
                    // DeliverySchedulingLine."Entry No." := 1;
                    // ProdOrderComponent.Reset();
                    // prodOrderComponent.SetCurrentKey("Shortcut Dimension 2 Code", "Item No.");
                    // ProdOrderComponent.Setrange("Due Date",
                    //                                rec."Starting Date",
                    //                                CalcDate('1M', Rec."Starting Date"));

                    // If rec.Site <> '' then
                    //     ProdOrderComponent.Setrange("Shortcut Dimension 2 Code", rec.Site);
                    // IF prodOrderComponent.FindSet() THEN begin
                    //     ProdOrderComponent1.Reset();
                    //     ProdOrderComponent1.SetFilter("Due Date", '%1..%2',
                    //                                    rec."Starting Date",
                    //                                    CalcDate('1M', Rec."Starting Date"));
                    //     repeat
                    //         if (ItemNo <> prodOrderComponent."Item No.") OR (SITECODE <> prodOrderComponent."Shortcut Dimension 2 Code") then begin
                    //             ItemNo := prodOrderComponent."Item No.";
                    //             SITECODE := prodOrderComponent."Shortcut Dimension 2 Code";
                    //             Item.Get(prodOrderComponent."Item No.");
                    //             IF Item."Replenishment System" = Item."Replenishment System"::Purchase THEN begin
                    //                 InitDeliverySchedulingLine(prodOrderComponent, DeliverySchedulingLine);
                    //                 ProdOrderComponent1.setrange("Item No.", ItemNo);
                    //                 ProdOrderComponent1.setrange("Shortcut Dimension 2 Code", SITECODE);
                    //                 if ProdOrderComponent1.FindSet() THEN
                    //                     repeat
                    //                         updateDeliverySchedulingLine(ProdOrderComponent1, DeliverySchedulingLine);
                    //                     until ProdOrderComponent1.Next() = 0;
                    //                 DeliverySchedulingLine.Insert();
                    //                 DeliverySchedulingLine."Entry No." += 1;
                    //             end;
                    //         end;
                    //     until prodOrderComponent.Next() = 0;
                    // end;
                    currpage.DeliverySchedulingLines.page.SetDayCaption(Rec);
                    currpage.DeliverySchedulingLines.Page.CalcNeed();
                    currPage.Update();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        if Rec."Starting Date" = 0D then begin
            Rec."Starting Date" := WORKDATE;
        end;
        currpage.DeliverySchedulingLines.page.SetDayCaption(Rec);
    end;

    // procedure updateDeliverySchedulingLine(prodOrderComponent: Record "Prod. Order Component"; var DeliverySchedulingLine: Record "RV Invy. Planning Line")
    // var
    //     QtyUpdated: Boolean;
    // begin
    //     Case prodOrderComponent."Due Date" of
    //         rec."Starting Date":
    //             DeliverySchedulingLine."Date1 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('1D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date2 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('2D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date3 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('3D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date4 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('4D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date5 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('5D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date6 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('6D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date7 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('7D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date8 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('8D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date9 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('9D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date10 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('10D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date11 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('11D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date12 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('12D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date13 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('13D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date14 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('14D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date15 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('15D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date16 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('16D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date17 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('17D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date18 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('18D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date19 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('19D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date20 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('20D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date21 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('21D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date22 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('22D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date23 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('23D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date24 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('24D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date25 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('25D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date26 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('26D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date27 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('27D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date28 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('28D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date29 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('29D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date30 Quantity" += prodOrderComponent.Quantity;
    //         CalcDate('30D', rec."Starting Date"):
    //             DeliverySchedulingLine."Date31 Quantity" += prodOrderComponent.Quantity;
    //     end;
    // end;
}
