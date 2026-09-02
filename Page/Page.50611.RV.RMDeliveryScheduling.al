/// <summary>
/// Page RV Invy. Planning Name (ID 50405).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>

page 50611 "RV Invy. Planning Name"
{
    // ApplicationArea = All;
    Caption = 'Inventory Planning';
    PageType = Document;
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
                    applicationarea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    applicationarea = All;
                }
                field("starting Date"; Rec."Starting Date")
                {
                    caption = 'Inventory Planning Starting Date';
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                    applicationarea = All;
                }
                field("Item Filter"; Rec."Item Filter")
                {
                    caption = 'Item Filter';
                    ToolTip = 'Specifies the value of the Item Filter field.', Comment = '%';
                    applicationarea = All;

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
                field("PIC Filter"; Rec."PIC Filter")
                {
                    caption = 'PIC Filter';
                    ToolTip = 'Specifies the value of the PIC Filter field.', Comment = '%';
                    applicationarea = All;
                }
            }

            Part(DeliverySchedulingLines; "RV Invy. Planning Lines")
            {
                ApplicationArea = All;
                // Caption = 'Delivery Scheduling Lines';
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

                    currpage.DeliverySchedulingLines.page.SetDayCaption(Rec);
                    currpage.DeliverySchedulingLines.Page.CalcNeed();
                    currPage.Update();
                end;
            }
        }
        area(Promoted)
        {
            actionref(CollectData_prompt; "Collect Data")
            {
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
}
