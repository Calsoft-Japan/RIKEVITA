page 50612 "RV Invy. Planning Lines"
{
    // ApplicationArea = All;
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    modifyAllowed = false;
    LinksAllowed = true;
    PageType = ListPart;
    SourceTable = "RV Invy. Planning Line";
    // SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field(VendorNo; Rec.VendorNo)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Description"; Rec."Vendor Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(PIC; Rec.PIC)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the PIC field.', Comment = '%';
                }
                // field("Site"; Rec."Site")
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                // }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                // field("Inventory Before Period"; Rec."Inventory Before Period")
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the value of the Inventory Before Period field.', Comment = '%';
                // }
                field("Date Type"; Rec."Date Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Date Type field.', Comment = '%';
                }
                field("Date1 Quantity"; Rec."Date1 Quantity")
                {
                    CaptionClass = '3,' + DayCaption[1];
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Date1  field.', Comment = '%';
                    // visible = DateVisible1;
                }
                field("Date2 Quantity"; Rec."Date2 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[2];
                    ToolTip = 'Specifies the value of the Date2 field.', Comment = '%';
                    visible = DateVisible2;
                }
                field("Date3 Quantity"; Rec."Date3 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[3];
                    ToolTip = 'Specifies the value of the Date3 field.', Comment = '%';
                    visible = DateVisible3;
                }
                field("Date4 Quantity"; Rec."Date4 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[4];
                    ToolTip = 'Specifies the value of the Date4 field.', Comment = '%';
                    visible = DateVisible4;
                }
                field("Date5 Quantity"; Rec."Date5 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[5];
                    ToolTip = 'Specifies the value of the Date5 field.', Comment = '%';
                    visible = DateVisible5;
                }
                field("Date6 Quantity"; Rec."Date6 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[6];
                    ToolTip = 'Specifies the value of the Date6 field.', Comment = '%';
                    visible = DateVisible6;
                }
                field("Date7 Quantity"; Rec."Date7 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[7];
                    ToolTip = 'Specifies the value of the Date7 field.', Comment = '%';
                    visible = DateVisible7;
                }
                field("Date8 Quantity"; Rec."Date8 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[8];
                    ToolTip = 'Specifies the value of the Date8 field.', Comment = '%';
                    visible = DateVisible8;
                }
                field("Date9 Quantity"; Rec."Date9 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[9];
                    ToolTip = 'Specifies the value of the Date9 field.', Comment = '%';
                    visible = DateVisible9;
                }
                field("Date10 Quantity"; Rec."Date10 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[10];
                    ToolTip = 'Specifies the value of the Date10 field.', Comment = '%';
                    visible = DateVisible10;
                }
                field("Date11 Quantity"; Rec."Date11 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[11];
                    ToolTip = 'Specifies the value of the Date11 field.', Comment = '%';
                    visible = DateVisible11;
                }
                field("Date12 Quantity"; Rec."Date12 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[12];
                    ToolTip = 'Specifies the value of the Date12 field.', Comment = '%';
                    visible = DateVisible12;
                }
                field("Date13 Quantity"; Rec."Date13 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[13];
                    ToolTip = 'Specifies the value of the Date13 field.', Comment = '%';
                    visible = DateVisible13;
                }
                field("Date14 Quantity"; Rec."Date14 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[14];
                    ToolTip = 'Specifies the value of the Date14 field.', Comment = '%';
                    visible = DateVisible14;
                }
                field("Date15 Quantity"; Rec."Date15 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[15];
                    ToolTip = 'Specifies the value of the Date15 field.', Comment = '%';
                    visible = DateVisible15;
                }
                field("Date16 Quantity"; Rec."Date16 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[16];
                    ToolTip = 'Specifies the value of the Date16 field.', Comment = '%';
                    visible = DateVisible16;
                }
                field("Date17 Quantity"; Rec."Date17 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[17];
                    ToolTip = 'Specifies the value of the Date17 field.', Comment = '%';
                    visible = DateVisible17;
                }
                field("Date18 Quantity"; Rec."Date18 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[18];
                    ToolTip = 'Specifies the value of the Date18 field.', Comment = '%';
                    visible = DateVisible18;
                }
                field("Date19 Quantity"; Rec."Date19 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[19];
                    ToolTip = 'Specifies the value of the Date19 field.', Comment = '%';
                    visible = DateVisible19;
                }
                field("Date20 Quantity"; Rec."Date20 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[20];
                    ToolTip = 'Specifies the value of the Date20 field.', Comment = '%';
                    visible = DateVisible20;
                }
                field("Date21 Quantity"; Rec."Date21 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[21];
                    ToolTip = 'Specifies the value of the Date21 field.', Comment = '%';
                    visible = DateVisible21;
                }
                field("Date22 Quantity"; Rec."Date22 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[22];
                    ToolTip = 'Specifies the value of the Date22 field.', Comment = '%';
                    visible = DateVisible22;
                }
                field("Date23 Quantity"; Rec."Date23 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[23];
                    ToolTip = 'Specifies the value of the Date23 field.', Comment = '%';
                    visible = DateVisible23;
                }
                field("Date24 Quantity"; Rec."Date24 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[24];
                    ToolTip = 'Specifies the value of the Date24 field.', Comment = '%';
                    visible = DateVisible24;
                }
                field("Date25 Quantity"; Rec."Date25 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[25];
                    ToolTip = 'Specifies the value of the Date25 field.', Comment = '%';
                    visible = DateVisible25;
                }
                field("Date26 Quantity"; Rec."Date26 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[26];
                    ToolTip = 'Specifies the value of the Date26 field.', Comment = '%';
                    visible = DateVisible26;
                }
                field("Date27 Quantity"; Rec."Date27 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[27];
                    ToolTip = 'Specifies the value of the Date27 field.', Comment = '%';
                    visible = DateVisible27;
                }
                field("Date28 Quantity"; Rec."Date28 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[28];
                    ToolTip = 'Specifies the value of the Date28 field.', Comment = '%';
                    visible = DateVisible28;
                }
                field("Date29 Quantity"; Rec."Date29 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[29];
                    ToolTip = 'Specifies the value of the Date29 field.', Comment = '%';
                    visible = DateVisible29;
                }
                field("Date30 Quantity"; Rec."Date30 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[30];
                    ToolTip = 'Specifies the value of the Date30 field.', Comment = '%';
                    visible = DateVisible30;
                }
                field("Date31 Quantity"; Rec."Date31 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[31];
                    ToolTip = 'Specifies the value of the Date31 field.', Comment = '%';
                    visible = DateVisible31;
                }
                field("Date32 Quantity"; Rec."Date32 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[32];
                    ToolTip = 'Specifies the value of the Date32 field.', Comment = '%';
                    visible = DateVisible32;
                }
            }
        }
    }
    trigger OnOpenPage()
    var

    begin
        //SetDayCaption(Rec."Starting Date");

    end;

    procedure SetDayCaption(parInvyPlanningName: Record "RV Invy. Planning Name")
    var
        I: Integer;
        FirstDay: Integer;
    begin
        clear(DateVisible1);
        clear(DateVisible2);
        //add othe 32
        clear(DateVisible3);
        clear(DateVisible4);
        clear(DateVisible5);
        clear(DateVisible6);
        clear(DateVisible7);
        clear(DateVisible8);
        clear(DateVisible9);
        clear(DateVisible10);
        clear(DateVisible11);
        clear(DateVisible12);
        clear(DateVisible13);
        clear(DateVisible14);
        clear(DateVisible15);
        clear(DateVisible16);
        clear(DateVisible17);
        clear(DateVisible18);
        clear(DateVisible19);
        clear(DateVisible20);
        clear(DateVisible21);
        clear(DateVisible22);
        clear(DateVisible23);
        clear(DateVisible24);
        clear(DateVisible25);
        clear(DateVisible26);
        clear(DateVisible27);
        clear(DateVisible28);
        clear(DateVisible29);
        clear(DateVisible30);
        clear(DateVisible31);
        clear(DateVisible32);

        InvyPlanningName := parInvyPlanningName;
        FirstDay := Date2DMY(parInvyPlanningName."Starting Date", 2);
        DayCaption[1] := '..Before';
        for I := 2 to 32 do begin
            DayCaption[I] := FORMAT(parInvyPlanningName."Starting Date", 0, '<Month,2>/<Day,2>');
            case I of
                2:
                    DateVisible2 := true;
                //add othe 32
                3:
                    DateVisible3 := true;
                4:
                    DateVisible4 := true;
                5:
                    DateVisible5 := true;
                6:
                    DateVisible6 := true;
                7:
                    DateVisible7 := true;
                8:
                    DateVisible8 := true;
                9:
                    DateVisible9 := true;
                10:
                    DateVisible10 := true;
                11:
                    DateVisible11 := true;
                12:
                    DateVisible12 := true;
                13:
                    DateVisible13 := true;
                14:
                    DateVisible14 := true;
                15:
                    DateVisible15 := true;
                16:
                    DateVisible16 := true;
                17:
                    DateVisible17 := true;
                18:
                    DateVisible18 := true;
                19:
                    DateVisible19 := true;
                20:
                    DateVisible20 := true;
                21:
                    DateVisible21 := true;
                22:
                    DateVisible22 := true;
                23:
                    DateVisible23 := true;
                24:
                    DateVisible24 := true;
                25:
                    DateVisible25 := true;
                26:
                    DateVisible26 := true;
                27:
                    DateVisible27 := true;
                28:
                    DateVisible28 := true;
                29:
                    DateVisible29 := true;
                30:
                    DateVisible30 := true;
                31:
                    DateVisible31 := true;
                32:
                    DateVisible32 := true;
            end;

            parInvyPlanningName."Starting Date" := CalcDate('1D', parInvyPlanningName."Starting Date");
            //if parInvyPlanningName."Starting Date" is next month then skip loop
            if Date2DMY(parInvyPlanningName."Starting Date", 2) <> FirstDay then
                I := 33;
        end;
    end;

    procedure SetShowDayCaption(parDate: integer): boolean
    begin
        if DayCaption[parDate] = '' then
            exit(false);
        exit(true);
    end;

    procedure InitDeliverySchedulingLine(parItemNo: Code[20]; tmpQty: decimal; parDataType: enum "RV Invy. Planning Data Type"; Days: Integer)
    Var
        Vendor: Record Vendor;
    begin
        Item.get(parItemNo);

        DeliverySchedulingLine.Init();
        DeliverySchedulingLine."Item No." := Item."No.";
        DeliverySchedulingLine."Delivery Scheduling Name" := InvyPlanningName.Name;
        DeliverySchedulingLine."Date Type" := parDataType;
        // DeliverySchedulingLine."Site" := parSite;
        DeliverySchedulingLine."Unit of Measure" := Item."Base Unit of Measure";
        DeliverySchedulingLine."Item Description" := Item.Description;
        DeliverySchedulingLine.PIC := Item."RV_PIC";
        DeliverySchedulingLine.VendorNo := Item."Vendor No.";
        if Item."Vendor No." <> '' then begin
            Vendor.Get(Item."Vendor No.");
            DeliverySchedulingLine."Vendor Description" := Vendor.Name;
        end;
        case Days of
            0:
                DeliverySchedulingLine."Inventory Before Period" := tmpQty;
            1:
                DeliverySchedulingLine."Date1 Quantity" := tmpQty;
            2:
                DeliverySchedulingLine."Date2 Quantity" := tmpQty;
            3:
                DeliverySchedulingLine."Date3 Quantity" := tmpQty;
            4:
                DeliverySchedulingLine."Date4 Quantity" := tmpQty;
            5:
                DeliverySchedulingLine."Date5 Quantity" := tmpQty;
            6:
                DeliverySchedulingLine."Date6 Quantity" := tmpQty;
            7:
                DeliverySchedulingLine."Date7 Quantity" := tmpQty;
            8:
                DeliverySchedulingLine."Date8 Quantity" := tmpQty;
            9:
                DeliverySchedulingLine."Date9 Quantity" := tmpQty;
            10:
                DeliverySchedulingLine."Date10 Quantity" := tmpQty;
            11:
                DeliverySchedulingLine."Date11 Quantity" := tmpQty;
            12:
                DeliverySchedulingLine."Date12 Quantity" := tmpQty;
            13:
                DeliverySchedulingLine."Date13 Quantity" := tmpQty;
            14:
                DeliverySchedulingLine."Date14 Quantity" := tmpQty;
            15:
                DeliverySchedulingLine."Date15 Quantity" := tmpQty;
            16:
                DeliverySchedulingLine."Date16 Quantity" := tmpQty;
            17:
                DeliverySchedulingLine."Date17 Quantity" := tmpQty;
            18:
                DeliverySchedulingLine."Date18 Quantity" := tmpQty;
            19:
                DeliverySchedulingLine."Date19 Quantity" := tmpQty;
            20:
                DeliverySchedulingLine."Date20 Quantity" := tmpQty;
            21:
                DeliverySchedulingLine."Date21 Quantity" := tmpQty;
            22:
                DeliverySchedulingLine."Date22 Quantity" := tmpQty;
            23:
                DeliverySchedulingLine."Date23 Quantity" := tmpQty;
            24:
                DeliverySchedulingLine."Date24 Quantity" := tmpQty;
            25:
                DeliverySchedulingLine."Date25 Quantity" := tmpQty;
            26:
                DeliverySchedulingLine."Date26 Quantity" := tmpQty;
            27:
                DeliverySchedulingLine."Date27 Quantity" := tmpQty;
            28:
                DeliverySchedulingLine."Date28 Quantity" := tmpQty;
            29:
                DeliverySchedulingLine."Date29 Quantity" := tmpQty;
            30:
                DeliverySchedulingLine."Date30 Quantity" := tmpQty;
            31:
                DeliverySchedulingLine."Date31 Quantity" := tmpQty;
            32:
                DeliverySchedulingLine."Date32 Quantity" := tmpQty;
        end;
        DeliverySchedulingLine.Insert(true);
    end;

    procedure UpdateDeliverySchedulingLine(var DeliverySchedulingLine: Record "RV Invy. Planning Line"; tmpQty: decimal; Days: Integer)
    begin
        case Days of
            1:
                DeliverySchedulingLine."Date1 Quantity" += tmpQty;
            2:
                DeliverySchedulingLine."Date2 Quantity" += tmpQty;
            3:
                DeliverySchedulingLine."Date3 Quantity" += tmpQty;
            4:
                DeliverySchedulingLine."Date4 Quantity" += tmpQty;
            5:
                DeliverySchedulingLine."Date5 Quantity" += tmpQty;
            6:
                DeliverySchedulingLine."Date6 Quantity" += tmpQty;
            7:
                DeliverySchedulingLine."Date7 Quantity" += tmpQty;
            8:
                DeliverySchedulingLine."Date8 Quantity" += tmpQty;
            9:
                DeliverySchedulingLine."Date9 Quantity" += tmpQty;
            10:
                DeliverySchedulingLine."Date10 Quantity" += tmpQty;
            11:
                DeliverySchedulingLine."Date11 Quantity" += tmpQty;
            12:
                DeliverySchedulingLine."Date12 Quantity" += tmpQty;
            13:
                DeliverySchedulingLine."Date13 Quantity" += tmpQty;
            14:
                DeliverySchedulingLine."Date14 Quantity" += tmpQty;
            15:
                DeliverySchedulingLine."Date15 Quantity" += tmpQty;
            16:
                DeliverySchedulingLine."Date16 Quantity" += tmpQty;
            17:
                DeliverySchedulingLine."Date17 Quantity" += tmpQty;
            18:
                DeliverySchedulingLine."Date18 Quantity" += tmpQty;
            19:
                DeliverySchedulingLine."Date19 Quantity" += tmpQty;
            20:
                DeliverySchedulingLine."Date20 Quantity" += tmpQty;
            21:
                DeliverySchedulingLine."Date21 Quantity" += tmpQty;
            22:
                DeliverySchedulingLine."Date22 Quantity" += tmpQty;
            23:
                DeliverySchedulingLine."Date23 Quantity" += tmpQty;
            24:
                DeliverySchedulingLine."Date24 Quantity" += tmpQty;
            25:
                DeliverySchedulingLine."Date25 Quantity" += tmpQty;
            26:
                DeliverySchedulingLine."Date26 Quantity" += tmpQty;
            27:
                DeliverySchedulingLine."Date27 Quantity" += tmpQty;
            28:
                DeliverySchedulingLine."Date28 Quantity" += tmpQty;
            29:
                DeliverySchedulingLine."Date29 Quantity" += tmpQty;
            30:
                DeliverySchedulingLine."Date30 Quantity" += tmpQty;
            31:
                DeliverySchedulingLine."Date31 Quantity" += tmpQty;
            32:
                DeliverySchedulingLine."Date32 Quantity" += tmpQty;
        end;
        DeliverySchedulingLine.Modify();
    end;

    procedure CalcNeed()
    var
        PlannedOrderReleaseQty: Decimal;
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        ProgressMsg: Label 'Item No. ------ #1';
        ProgressWindow: Dialog;
        Counter: Integer;

        // QueryItemInv: Query "RV Item Inventory";
        ItemQty: record Item;
        QueryQtyOnComponentLines: Query "RV Qty. on Component Lines";
        QueryPlanningIssues: Query "RV Planning Issues";
        QueryPlanningTranShip: Query "RV Planning Tran. Ship";
        QueryQtyOnSalesOrder: Query "RV Qty. on Sales Order";
        QueryTransOrdShipment: Query "RV Trans. Ord. Shipment";
        QueryQtyOnPurchReturn: Query "RV Qty. on Purch. Return";
        QueryScheduledReceipt: Query "RV Scheduled Receipt";
        QueryQtyOnPurchOrder: Query "RV Qty. on Purch. Order";
        QueryTransOrdReceipt: Query "RV Trans. Ord. Receipt";
        QueryQtyinTransit: Query "RV Qty. in Transit";
        QueryQtyOnSalesReturn: Query "RV Qty. on Sales Return";
        QueryPlanningReceipt: Query "RV Planning Receipt";
        QueryPlannedOrderReceipt: Query "RV Planned Order Receipt";
    begin
        InvyPlanningName.TestField("Starting Date");

        DeliverySchedulingLine.Reset();
        DeliverySchedulingLine.DeleteAll();
        Lastno := 0;

        GLSetup.get();
        PeriodStartDate[2] := InvyPlanningName."Starting Date";
        for i := 2 to 32 do begin
            PeriodStartDate[i + 1] := CalcDate('+1D', PeriodStartDate[i]);
        end;

        ItemQty.Reset();
        if InvyPlanningName."Item Filter" <> '' then
            ItemQty.SetFilter("No.", InvyPlanningName."Item Filter");
        // QueryItemInv.SetRange(PostingDate, 0D, InvyPlanningName."Starting Date" - 1);
        ItemQty.setfilter(Inventory, '<>%1', 0);
        ItemQty.setautoCalcFields(Inventory);
        if ItemQty.findset() then
            repeat
                InitDeliverySchedulingLine(ItemQty."No.", ItemQty.Inventory, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                InitDeliverySchedulingLine(ItemQty."No.", ItemQty.Inventory, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                InitDeliverySchedulingLine(ItemQty."No.", ItemQty.Inventory, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
            until ItemQty.next() = 0;


        for i := 1 to 32 do begin

            if InvyPlanningName."Item Filter" <> '' then begin
                QueryQtyOnComponentLines.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryPlanningIssues.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryPlanningTranShip.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryQtyOnSalesOrder.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryTransOrdShipment.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryQtyOnPurchReturn.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryScheduledReceipt.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryQtyOnPurchOrder.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryTransOrdReceipt.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryQtyinTransit.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryQtyOnSalesReturn.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryPlanningReceipt.SetFilter(ItemNo, InvyPlanningName."Item Filter");
                QueryPlannedOrderReceipt.SetFilter(ItemNo, InvyPlanningName."Item Filter");
            end;

            QueryQtyOnComponentLines.SetRange(DueDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyOnComponentLines.setfilter(Quantity, '<>%1', 0);
            QueryQtyOnComponentLines.open();
            while QueryQtyOnComponentLines.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyOnComponentLines.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyOnComponentLines.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyOnComponentLines.ItemNo, QueryQtyOnComponentLines.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryQtyOnComponentLines.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyOnComponentLines.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryQtyOnComponentLines.Close();

            QueryPlanningIssues.SetRange(DueDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryPlanningIssues.setfilter(Quantity, '<>%1', 0);
            QueryPlanningIssues.open();
            while QueryPlanningIssues.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryPlanningIssues.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryPlanningIssues.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryPlanningIssues.ItemNo, QueryPlanningIssues.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryPlanningIssues.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryPlanningIssues.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryPlanningIssues.Close();

            QueryPlanningTranShip.SetRange(TransferShipmentDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryPlanningTranShip.setfilter(Quantity, '<>%1', 0);
            QueryPlanningTranShip.open();
            while QueryPlanningTranShip.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryPlanningTranShip.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryPlanningTranShip.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryPlanningTranShip.ItemNo, QueryPlanningTranShip.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryPlanningTranShip.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryPlanningTranShip.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryPlanningTranShip.Close();

            QueryQtyOnSalesOrder.SetRange(ShipmentDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyOnSalesOrder.setfilter(Quantity, '<>%1', 0);
            QueryQtyOnSalesOrder.open();
            while QueryQtyOnSalesOrder.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyOnSalesOrder.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyOnSalesOrder.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyOnSalesOrder.ItemNo, QueryQtyOnSalesOrder.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryQtyOnSalesOrder.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyOnSalesOrder.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryQtyOnSalesOrder.Close();

            QueryTransOrdShipment.SetRange(ShipmentDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryTransOrdShipment.setfilter(Quantity, '<>%1', 0);
            QueryTransOrdShipment.open();
            while QueryTransOrdShipment.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryTransOrdShipment.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryTransOrdShipment.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryTransOrdShipment.ItemNo, QueryTransOrdShipment.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryTransOrdShipment.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryTransOrdShipment.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryTransOrdShipment.Close();

            QueryQtyOnPurchReturn.SetRange(ExpectedReceiptDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyOnPurchReturn.setfilter(Quantity, '<>%1', 0);
            QueryQtyOnPurchReturn.open();
            while QueryQtyOnPurchReturn.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyOnPurchReturn.ItemNo,
                                                "RV Invy. Planning Data Type"::"Gross Requirement") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyOnPurchReturn.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyOnPurchReturn.ItemNo, QueryQtyOnPurchReturn.Quantity, "RV Invy. Planning Data Type"::"Gross Requirement", i);
                    InitDeliverySchedulingLine(QueryQtyOnPurchReturn.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyOnPurchReturn.ItemNo, 0, "RV Invy. Planning Data Type"::"Scheduled Receipt", 0);
                end;
            end;
            QueryQtyOnPurchReturn.Close();

            QueryScheduledReceipt.SetRange(DueDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryScheduledReceipt.setfilter(Quantity, '<>%1', 0);
            QueryScheduledReceipt.open();
            while QueryScheduledReceipt.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryScheduledReceipt.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryScheduledReceipt.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryScheduledReceipt.ItemNo, QueryScheduledReceipt.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryScheduledReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryScheduledReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryScheduledReceipt.Close();

            QueryQtyOnPurchOrder.SetRange(ExpectedReceiptDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyOnPurchOrder.setfilter(Quantity, '<>%1', 0);
            QueryQtyOnPurchOrder.open();
            while QueryQtyOnPurchOrder.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyOnPurchOrder.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyOnPurchOrder.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyOnPurchOrder.ItemNo, QueryQtyOnPurchOrder.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryQtyOnPurchOrder.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyOnPurchOrder.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryQtyOnPurchOrder.Close();

            QueryTransOrdReceipt.SetRange(ReceiptDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryTransOrdReceipt.setfilter(Quantity, '<>%1', 0);
            QueryTransOrdReceipt.open();
            while QueryTransOrdReceipt.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryTransOrdReceipt.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryTransOrdReceipt.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryTransOrdReceipt.ItemNo, QueryTransOrdReceipt.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryTransOrdReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryTransOrdReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryTransOrdReceipt.Close();

            QueryQtyinTransit.SetRange(ReceiptDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyinTransit.setfilter(Quantity, '<>%1', 0);
            QueryQtyinTransit.open();
            while QueryQtyinTransit.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyinTransit.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyinTransit.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyinTransit.ItemNo, QueryQtyinTransit.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryQtyinTransit.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyinTransit.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryQtyinTransit.Close();

            QueryQtyOnSalesReturn.SetRange(ShipmentDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryQtyOnSalesReturn.setfilter(Quantity, '<>%1', 0);
            QueryQtyOnSalesReturn.open();
            while QueryQtyOnSalesReturn.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryQtyOnSalesReturn.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryQtyOnSalesReturn.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryQtyOnSalesReturn.ItemNo, QueryQtyOnSalesReturn.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryQtyOnSalesReturn.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryQtyOnSalesReturn.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryQtyOnSalesReturn.Close();

            QueryPlanningReceipt.SetRange(DueDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryPlanningReceipt.setfilter(Quantity, '<>%1', 0);
            QueryPlanningReceipt.open();
            while QueryPlanningReceipt.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryPlanningReceipt.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryPlanningReceipt.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryPlanningReceipt.ItemNo, QueryPlanningReceipt.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryPlanningReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryPlanningReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);
                end;
            end;
            QueryPlanningReceipt.Close();

            QueryPlannedOrderReceipt.SetRange(DueDate, PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            QueryPlannedOrderReceipt.setfilter(Quantity, '<>%1', 0);
            QueryPlannedOrderReceipt.open();
            while QueryPlannedOrderReceipt.Read() do begin
                if DeliverySchedulingLine.get(InvyPlanningName.Name,
                                                QueryPlannedOrderReceipt.ItemNo,
                                                "RV Invy. Planning Data Type"::"Scheduled Receipt") then begin

                    UpdateDeliverySchedulingLine(DeliverySchedulingLine, QueryPlannedOrderReceipt.Quantity, i);
                end else begin
                    InitDeliverySchedulingLine(QueryPlannedOrderReceipt.ItemNo, QueryPlannedOrderReceipt.Quantity, "RV Invy. Planning Data Type"::"Scheduled Receipt", i);
                    InitDeliverySchedulingLine(QueryPlannedOrderReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Planned Inventory", 0);
                    InitDeliverySchedulingLine(QueryPlannedOrderReceipt.ItemNo, 0, "RV Invy. Planning Data Type"::"Gross Requirement", 0);

                end;
            end;
            QueryPlannedOrderReceipt.Close();

        end;

        DeliverySchedulingLine.Reset();
        DeliverySchedulingLine.SetRange("Date Type", DeliverySchedulingLine."Date Type"::"Planned Inventory");
        if DeliverySchedulingLine.FindSet() then
            repeat
                GrossReq.get(DeliverySchedulingLine."Delivery Scheduling Name", DeliverySchedulingLine."Item No.", "RV Invy. Planning Data Type"::"Gross Requirement");
                SchedReceipt.get(DeliverySchedulingLine."Delivery Scheduling Name", DeliverySchedulingLine."Item No.", "RV Invy. Planning Data Type"::"Scheduled Receipt");
                DeliverySchedulingLine."Date1 Quantity" := DeliverySchedulingLine."Inventory Before Period" -
                                                            GrossReq."Date1 Quantity" +
                                                            SchedReceipt."Date1 Quantity";
                DeliverySchedulingLine."Date2 Quantity" := DeliverySchedulingLine."Date1 Quantity" -
                                                            GrossReq."Date2 Quantity" +
                                                            SchedReceipt."Date2 Quantity";
                DeliverySchedulingLine."Date3 Quantity" := DeliverySchedulingLine."Date2 Quantity" -
                                                            GrossReq."Date3 Quantity" +
                                                            SchedReceipt."Date3 Quantity";
                DeliverySchedulingLine."Date4 Quantity" := DeliverySchedulingLine."Date3 Quantity" -
                                                            GrossReq."Date4 Quantity" +
                                                            SchedReceipt."Date4 Quantity";
                //add other 32
                DeliverySchedulingLine."Date5 Quantity" := DeliverySchedulingLine."Date4 Quantity" -
                                                                GrossReq."Date5 Quantity" +
                                                                SchedReceipt."Date5 Quantity";
                DeliverySchedulingLine."Date6 Quantity" := DeliverySchedulingLine."Date5 Quantity" -
                                                            GrossReq."Date6 Quantity" +
                                                            SchedReceipt."Date6 Quantity";
                DeliverySchedulingLine."Date7 Quantity" := DeliverySchedulingLine."Date6 Quantity" -
                                                            GrossReq."Date7 Quantity" +
                                                            SchedReceipt."Date7 Quantity";
                DeliverySchedulingLine."Date8 Quantity" := DeliverySchedulingLine."Date7 Quantity" -
                                                            GrossReq."Date8 Quantity" +
                                                            SchedReceipt."Date8 Quantity";
                DeliverySchedulingLine."Date9 Quantity" := DeliverySchedulingLine."Date8 Quantity" -
                                                            GrossReq."Date9 Quantity" +
                                                            SchedReceipt."Date9 Quantity";
                DeliverySchedulingLine."Date10 Quantity" := DeliverySchedulingLine."Date9 Quantity" -
                                                            GrossReq."Date10 Quantity" +
                                                            SchedReceipt."Date10 Quantity";
                DeliverySchedulingLine."Date11 Quantity" := DeliverySchedulingLine."Date10 Quantity" -
                                                            GrossReq."Date11 Quantity" +
                                                            SchedReceipt."Date11 Quantity";
                DeliverySchedulingLine."Date12 Quantity" := DeliverySchedulingLine."Date11 Quantity" -
                                                            GrossReq."Date12 Quantity" +
                                                            SchedReceipt."Date12 Quantity";
                DeliverySchedulingLine."Date13 Quantity" := DeliverySchedulingLine."Date12 Quantity" -
                                                            GrossReq."Date13 Quantity" +
                                                            SchedReceipt."Date13 Quantity";
                DeliverySchedulingLine."Date14 Quantity" := DeliverySchedulingLine."Date13 Quantity" -
                                                            GrossReq."Date14 Quantity" +
                                                            SchedReceipt."Date14 Quantity";
                DeliverySchedulingLine."Date15 Quantity" := DeliverySchedulingLine."Date14 Quantity" -
                                                            GrossReq."Date15 Quantity" +
                                                            SchedReceipt."Date15 Quantity";
                DeliverySchedulingLine."Date16 Quantity" := DeliverySchedulingLine."Date15 Quantity" -
                                                            GrossReq."Date16 Quantity" +
                                                            SchedReceipt."Date16 Quantity";
                DeliverySchedulingLine."Date17 Quantity" := DeliverySchedulingLine."Date16 Quantity" -
                                                            GrossReq."Date17 Quantity" +
                                                            SchedReceipt."Date17 Quantity";
                DeliverySchedulingLine."Date18 Quantity" := DeliverySchedulingLine."Date17 Quantity" -
                                                            GrossReq."Date18 Quantity" +
                                                            SchedReceipt."Date18 Quantity";
                DeliverySchedulingLine."Date19 Quantity" := DeliverySchedulingLine."Date18 Quantity" -
                                                            GrossReq."Date19 Quantity" +
                                                            SchedReceipt."Date19 Quantity";
                DeliverySchedulingLine."Date20 Quantity" := DeliverySchedulingLine."Date19 Quantity" -
                                                            GrossReq."Date20 Quantity" +
                                                            SchedReceipt."Date20 Quantity";
                DeliverySchedulingLine."Date21 Quantity" := DeliverySchedulingLine."Date20 Quantity" -
                                                            GrossReq."Date21 Quantity" +
                                                            SchedReceipt."Date21 Quantity";
                DeliverySchedulingLine."Date22 Quantity" := DeliverySchedulingLine."Date21 Quantity" -
                                                            GrossReq."Date22 Quantity" +
                                                            SchedReceipt."Date22 Quantity";
                DeliverySchedulingLine."Date23 Quantity" := DeliverySchedulingLine."Date22 Quantity" -
                                                            GrossReq."Date23 Quantity" +
                                                            SchedReceipt."Date23 Quantity";
                DeliverySchedulingLine."Date24 Quantity" := DeliverySchedulingLine."Date23 Quantity" -
                                                            GrossReq."Date24 Quantity" +
                                                            SchedReceipt."Date24 Quantity";
                DeliverySchedulingLine."Date25 Quantity" := DeliverySchedulingLine."Date24 Quantity" -
                                                            GrossReq."Date25 Quantity" +
                                                            SchedReceipt."Date25 Quantity";
                DeliverySchedulingLine."Date26 Quantity" := DeliverySchedulingLine."Date25 Quantity" -
                                                            GrossReq."Date26 Quantity" +
                                                            SchedReceipt."Date26 Quantity";
                DeliverySchedulingLine."Date27 Quantity" := DeliverySchedulingLine."Date26 Quantity" -
                                                            GrossReq."Date27 Quantity" +
                                                            SchedReceipt."Date27 Quantity";
                DeliverySchedulingLine."Date28 Quantity" := DeliverySchedulingLine."Date27 Quantity" -
                                                            GrossReq."Date28 Quantity" +
                                                            SchedReceipt."Date28 Quantity";
                DeliverySchedulingLine."Date29 Quantity" := DeliverySchedulingLine."Date28 Quantity" -
                                                            GrossReq."Date29 Quantity" +
                                                            SchedReceipt."Date29 Quantity";
                DeliverySchedulingLine."Date30 Quantity" := DeliverySchedulingLine."Date29 Quantity" -
                                                            GrossReq."Date30 Quantity" +
                                                            SchedReceipt."Date30 Quantity";
                DeliverySchedulingLine."Date31 Quantity" := DeliverySchedulingLine."Date30 Quantity" -
                                                            GrossReq."Date31 Quantity" +
                                                            SchedReceipt."Date31 Quantity";
                DeliverySchedulingLine."Date32 Quantity" := DeliverySchedulingLine."Date31 Quantity" -
                                                            GrossReq."Date32 Quantity" +
                                                            SchedReceipt."Date32 Quantity";
                DeliverySchedulingLine.Modify();
            until DeliverySchedulingLine.Next() = 0;

        if rec.FindFirst() then;
    end;

    procedure CalcGrossRequirement(var Item: Record Item) GrossRequirement: Decimal
    var
        QtyOnComponentLines: Decimal;
        IsHandled: Boolean;
    begin
        CalcAllItemFields(Item);
        IsHandled := false;
        if not IsHandled then begin
            QtyOnComponentLines := Item.CalcQtyOnComponentLines();
            GrossRequirement :=
                QtyOnComponentLines +
                Item."Planning Issues (Qty.)" +
                Item."RV_Planning Tran. Ship. (Qty)." +
                Item."Qty. on Sales Order" +
                Item."RV_Qty. on Job Order" +
                Item."Trans. Ord. Shipment (Qty.)" +
                Item."Qty. on Asm. Component" +
                Item."Qty. on Purch. Return";
        end;

        exit(GrossRequirement);
    end;

    local procedure CalcAllItemFields(var Item: Record Item)
    var
        IsHandled: Boolean;
    begin
        if AllFieldCalculated and (PrevItemNo = Item."No.") and (PrevItemFilters = Item.GetFilters) then
            exit;

        Item.CalcFields(
          Inventory, "Reserved Qty. on Inventory",
          "Planning Issues (Qty.)",
          "RV_Planning Tran. Ship. (Qty).",
          "Qty. on Sales Order",
          "RV_Qty. on Job Order",
          "Trans. Ord. Shipment (Qty.)",
          "Qty. on Asm. Component",
          "Qty. on Purch. Return",
          "Reserved Qty. on Sales Orders",
          "Res. Qty. on Job Order",
          "Res. Qty. on Outbound Transfer",
          "Res. Qty. on  Asm. Comp.",
          "Res. Qty. on Purch. Returns");

        // Max function parameters is 20, hence split in 2
        Item.CalcFields(
          "Qty. on Purch. Order",
          "Trans. Ord. Receipt (Qty.)",
          "Qty. in Transit",
          "Qty. on Assembly Order",
          "Qty. on Sales Return",
          "Reserved Qty. on Purch. Orders",
          "Res. Qty. on Inbound Transfer",
          "Res. Qty. on Assembly Order",
          "Res. Qty. on Sales Returns");

        AllFieldCalculated := true;
        PrevItemNo := Item."No.";
        PrevItemFilters := Item.GetFilters();
    end;

    var
        DayCaption: array[32] of Text[30];
        DeliverySchedulingLine: Record "RV Invy. Planning Line";
        GrossReq: Record "RV Invy. Planning Line";
        SchedReceipt: Record "RV Invy. Planning Line";
        i: Integer;
        j: Integer;
        Item: Record Item;
        Print: boolean;
        PeriodStartDate: array[33] of Date;
        AvailToPromise: Codeunit "Available to Promise";
        InvyPlanningName: Record "RV Invy. Planning Name";
        AllFieldCalculated: Boolean;
        PrevItemNo: Code[20];
        PrevItemFilters: Text;
        Lastno: Integer;
        OpenQty: Decimal;
        //add other 32
        DateVisible1: Boolean;
        DateVisible2: Boolean;
        DateVisible3: Boolean;
        DateVisible4: Boolean;
        DateVisible5: Boolean;
        DateVisible6: Boolean;
        DateVisible7: Boolean;
        DateVisible8: Boolean;
        DateVisible9: Boolean;
        DateVisible10: Boolean;
        DateVisible11: Boolean;
        DateVisible12: Boolean;
        DateVisible13: Boolean;
        DateVisible14: Boolean;
        DateVisible15: Boolean;
        DateVisible16: Boolean;
        DateVisible17: Boolean;
        DateVisible18: Boolean;
        DateVisible19: Boolean;
        DateVisible20: Boolean;
        DateVisible21: Boolean;
        DateVisible22: Boolean;
        DateVisible23: Boolean;
        DateVisible24: Boolean;
        DateVisible25: Boolean;
        DateVisible26: Boolean;
        DateVisible27: Boolean;
        DateVisible28: Boolean;
        DateVisible29: Boolean;
        DateVisible30: Boolean;
        DateVisible31: Boolean;
        DateVisible32: Boolean;
}
