/// <summary>
/// Page RV RSPO Ratio (ID 50109).
/// FDD027 2026/05/01: New. (Liuyang)
/// </summary>
page 50109 "RV RSPO Ratio"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'RSPO Ratio';
    PageType = Worksheet;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    SourceTable = "RV_RSPO Ratio";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Lines';
                field("Item No. (FP)"; Rec."Item No. (FP)")
                {
                    ApplicationArea = All;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Item No. (RM)"; Rec."Item No. (RM)")
                {
                    ApplicationArea = All;
                }
                field("Output Quantity (KG)"; Rec."Output Quantity (KG)")
                {
                    ApplicationArea = All;
                }

                field("RSPO Ratio %"; Rec."RSPO Ratio %")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                trigger OnAction()
                begin
                    RefreshPage();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("refresh_Promoted"; "refresh")
                {
                }
            }

        }
    }


    trigger OnOpenPage()
    begin
        Rec.Reset();
        CurrPage.Update();
    end;

    var
        TempBOMBuff: Record "BOM Buffer" temporary;
        Item: Record Item;
        SourceRecordVar: Variant;
        IsParentExpr: Boolean;
        HasWarning: Boolean;
        CouldNotFindBOMLevelsErr: Label 'Could not find items with BOM levels.';


    protected var
        ItemFilter: Code[250];
        ShowBy: Enum "BOM Structure Show By";

    procedure InitItem(var NewItem: Record Item)
    begin
        Item := NewItem;
        ItemFilter := Item."No.";
        ShowBy := ShowBy::Item;
    end;

    procedure InitSource(NewSourceRecordVar: Variant; NewShowBy: Enum "BOM Structure Show By")
    begin
        SourceRecordVar := NewSourceRecordVar;
        ShowBy := NewShowBy;
    end;


    procedure RefreshPage()
    var
        CalculateBOMTree: Codeunit "Calculate BOM Tree";
        RaiseError: Boolean;
        ErrorText: Text;
        IsHandled: Boolean;
    begin
        TempBOMBuff.Reset();
        TempBOMBuff.DeleteAll();

        Item.Reset();
        Item.SetRange("Inventory Posting Group", 'FP');
        Item.SetFilter("Production BOM No.", '<>""');
        if ItemFilter <> '' then
            Item.SetFilter("No.", ItemFilter);
        Item.SetRange("Date Filter", 0D, WorkDate());
        CalculateBOMTree.SetItemFilter(Item);
        case ShowBy of
            ShowBy::Item:
                begin
                    Item.FindFirst();
                    RaiseError := (not Item.HasBOM()) and (not Item.HasRoutingNo());
                    ErrorText := CouldNotFindBOMLevelsErr;
                    if RaiseError then
                        Error(ErrorText);
                    CalculateBOMTree.GenerateTreeForManyItems(Item, TempBOMBuff, "BOM Tree Type"::" ");
                end;
            else
                CalculateBOMTree.GenerateTreeForSource(SourceRecordVar, TempBOMBuff, "BOM Tree Type"::" ", ShowBy, WorkDate());
        end;

        GenerateRSPORatioFromBOM();
    end;

    procedure GenerateRSPORatioFromBOM()
    var
        ItemCard: Record Item;
        ItemUOM: Record "Item Unit of Measure";
        PrdBomHdr: Record "Production BOM Header";
        PrdBOMLine: Record "Production BOM Line";
        BOMList: List of [Text];
        CurFPNo, CurBOMNo : Text;
        CurFPConsumQtyKG: Decimal;
        BOMLineQtyper, KGQtyper : Decimal;
    begin
        Rec.Reset();
        if Rec.FindSet() then
            Rec.DeleteAll();

        //TempBOMBuff.SetRange("Replenishment System", "Replenishment System"::Purchase);
        if TempBOMBuff.FindSet() then begin
            repeat
                if TempBOMBuff.Indentation = 0 then begin
                    //Calculate the Ratio for last FG here.
                    if CurFPConsumQtyKG > 0 then begin
                        Rec.Reset();
                        Rec.SetRange("Item No. (FP)", CurFPNo);
                        if Rec.FindSet() then
                            repeat
                                Rec."RSPO Ratio %" := Rec."Consumption Quantity (KG)" / CurFPConsumQtyKG;
                                Rec.Modify();
                            until Rec.Next() = 0;

                        Rec.Reset();
                    end;

                    CurFPNo := TempBOMBuff."No.";
                    ItemCard.Get(CurFPNo);
                    CurBOMNo := ItemCard."Production BOM No.";

                    CurFPConsumQtyKG := 0;
                    Clear(BOMList);
                end;

                IF TempBOMBuff."Replenishment System" <> "Replenishment System"::Purchase then
                    continue;

                Clear(BOMLineQtyper);
                BOMLineQtyper := TempBOMBuff."Qty. per Top Item";//TempBOMBuff."Qty. per BOM Line";

                /* PrdBOMLine.Reset();
                PrdBOMLine.SetRange("Production BOM No.", CurBOMNo);
                PrdBOMLine.SetRange("No.", TempBOMBuff."No.");
                if PrdBOMLine.FindFirst() then
                    BOMLineQtyper := PrdBOMLine."Quantity per"; */

                Clear(KGQtyper);
                if ItemUOM.Get(TempBOMBuff."No.", 'KG') then
                    KGQtyper := ItemUOM."Qty. per Unit of Measure";

                if BOMList.Contains(TempBOMBuff."No.") then begin
                    Rec.Reset();
                    Rec.Get(CurFPNo, TempBOMBuff."No.");

                    Rec."Consumption Quantity (KG)" += BOMLineQtyper * KGQtyper;
                    Rec."RSPO Ratio %" := 0;

                    Rec.Modify();
                    CurFPConsumQtyKG += BOMLineQtyper * KGQtyper;
                end else begin
                    Rec.Init();
                    Rec."Item No. (FP)" := CurFPNo;
                    Rec."Production BOM No." := CurBOMNo;
                    Rec."Item No. (RM)" := TempBOMBuff."No.";
                    Rec."Output Quantity (KG)" := KGQtyper;
                    Rec."Consumption Quantity (KG)" := BOMLineQtyper * KGQtyper;
                    Rec."RSPO Ratio %" := 0;

                    Rec.Insert();

                    CurFPConsumQtyKG += Rec."Consumption Quantity (KG)";
                    BOMList.Add(TempBOMBuff."No.");
                end;
            until TempBOMBuff.Next() = 0;

            //Calculate the Ratio for last FG here. last FG case
            if (CurFPConsumQtyKG > 0) and (Rec."RSPO Ratio %" = 0) then begin
                Rec.Reset();
                Rec.SetRange("Item No. (FP)", CurFPNo);
                if Rec.FindSet() then
                    repeat
                        Rec."RSPO Ratio %" := Rec."Consumption Quantity (KG)" / CurFPConsumQtyKG;
                        Rec.Modify();
                    until Rec.Next() = 0;

                Rec.Reset();
            end;
        end;

    end;

}
