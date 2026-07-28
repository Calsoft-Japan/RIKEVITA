page 50417 "RV Invy. Planning Lines"
{
    ApplicationArea = All;
    Caption = 'Inventory Planning Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    modifyAllowed = false;
    LinksAllowed = true;
    PageType = ListPart;
    SourceTable = "RV Invy. Planning Line";

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
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
                field("Site"; Rec."Site")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
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
                }
                field("Date2 Quantity"; Rec."Date2 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[2];
                    ToolTip = 'Specifies the value of the Date2 field.', Comment = '%';
                }
                field("Date3 Quantity"; Rec."Date3 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[3];
                    ToolTip = 'Specifies the value of the Date3 field.', Comment = '%';
                }
                field("Date4 Quantity"; Rec."Date4 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[4];
                    ToolTip = 'Specifies the value of the Date4 field.', Comment = '%';
                }
                field("Date5 Quantity"; Rec."Date5 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[5];
                    ToolTip = 'Specifies the value of the Date5 field.', Comment = '%';
                }
                field("Date6 Quantity"; Rec."Date6 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[6];
                    ToolTip = 'Specifies the value of the Date6 field.', Comment = '%';
                }
                field("Date7 Quantity"; Rec."Date7 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[7];
                    ToolTip = 'Specifies the value of the Date7 field.', Comment = '%';
                }
                field("Date8 Quantity"; Rec."Date8 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[8];
                    ToolTip = 'Specifies the value of the Date8 field.', Comment = '%';
                }
                field("Date9 Quantity"; Rec."Date9 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[9];
                    ToolTip = 'Specifies the value of the Date9 field.', Comment = '%';
                }
                field("Date10 Quantity"; Rec."Date10 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[10];
                    ToolTip = 'Specifies the value of the Date10 field.', Comment = '%';
                }
                field("Date11 Quantity"; Rec."Date11 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[11];
                    ToolTip = 'Specifies the value of the Date11 field.', Comment = '%';
                }
                field("Date12 Quantity"; Rec."Date12 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[12];
                    ToolTip = 'Specifies the value of the Date12 field.', Comment = '%';
                }
                field("Date13 Quantity"; Rec."Date13 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[13];
                    ToolTip = 'Specifies the value of the Date13 field.', Comment = '%';
                }
                field("Date14 Quantity"; Rec."Date14 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[14];
                    ToolTip = 'Specifies the value of the Date14 field.', Comment = '%';
                }
                field("Date15 Quantity"; Rec."Date15 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[15];
                    ToolTip = 'Specifies the value of the Date15 field.', Comment = '%';
                }
                field("Date16 Quantity"; Rec."Date16 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[16];
                    ToolTip = 'Specifies the value of the Date16 field.', Comment = '%';
                }
                field("Date17 Quantity"; Rec."Date17 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[17];
                    ToolTip = 'Specifies the value of the Date17 field.', Comment = '%';
                }
                field("Date18 Quantity"; Rec."Date18 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[18];
                    ToolTip = 'Specifies the value of the Date18 field.', Comment = '%';
                }
                field("Date19 Quantity"; Rec."Date19 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[19];
                    ToolTip = 'Specifies the value of the Date19 field.', Comment = '%';
                }
                field("Date20 Quantity"; Rec."Date20 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[20];
                    ToolTip = 'Specifies the value of the Date20 field.', Comment = '%';
                }
                field("Date21 Quantity"; Rec."Date21 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[21];
                    ToolTip = 'Specifies the value of the Date21 field.', Comment = '%';
                }
                field("Date22 Quantity"; Rec."Date22 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[22];
                    ToolTip = 'Specifies the value of the Date22 field.', Comment = '%';
                }
                field("Date23 Quantity"; Rec."Date23 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[23];
                    ToolTip = 'Specifies the value of the Date23 field.', Comment = '%';
                }
                field("Date24 Quantity"; Rec."Date24 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[24];
                    ToolTip = 'Specifies the value of the Date24 field.', Comment = '%';
                }
                field("Date25 Quantity"; Rec."Date25 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[25];
                    ToolTip = 'Specifies the value of the Date25 field.', Comment = '%';
                }
                field("Date26 Quantity"; Rec."Date26 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[26];
                    ToolTip = 'Specifies the value of the Date26 field.', Comment = '%';
                }
                field("Date27 Quantity"; Rec."Date27 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[27];
                    ToolTip = 'Specifies the value of the Date27 field.', Comment = '%';
                }
                field("Date28 Quantity"; Rec."Date28 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[28];
                    ToolTip = 'Specifies the value of the Date28 field.', Comment = '%';
                }
                field("Date29 Quantity"; Rec."Date29 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[29];
                    ToolTip = 'Specifies the value of the Date29 field.', Comment = '%';
                }
                field("Date30 Quantity"; Rec."Date30 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[30];
                    ToolTip = 'Specifies the value of the Date30 field.', Comment = '%';
                }
                field("Date31 Quantity"; Rec."Date31 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[31];
                    ToolTip = 'Specifies the value of the Date31 field.', Comment = '%';
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
        InvyPlanningName := parInvyPlanningName;
        FirstDay := Date2DMY(parInvyPlanningName."Starting Date", 3);
        for I := 1 to 31 do begin
            DayCaption[I] := FORMAT(parInvyPlanningName."Starting Date", 0, '<Month,2>/<Day,2>');
            parInvyPlanningName."Starting Date" := CalcDate('1D', parInvyPlanningName."Starting Date");
        end;
    end;

    procedure InitDeliverySchedulingLine(parSite: Code[20])
    Var
        Vendor: Record Vendor;
    begin
        DeliverySchedulingLine.Init();
        DeliverySchedulingLine."Entry No." := 0;
        DeliverySchedulingLine."Item No." := Item."No.";
        DeliverySchedulingLine."Delivery Scheduling Name" := InvyPlanningName.Name;
        DeliverySchedulingLine."Site" := parSite;
        DeliverySchedulingLine."Unit of Measure" := Item."Base Unit of Measure";
        DeliverySchedulingLine."Item Description" := Item.Description;
        DeliverySchedulingLine.VendorNo := Item."Vendor No.";
        if Item."Vendor No." <> '' then begin
            Vendor.Get(Item."Vendor No.");
            DeliverySchedulingLine."Vendor Description" := Vendor.Name;
        end;
        DeliverySchedulingLine.Insert();
    end;

    procedure CalcNeed()
    var
        PlannedOrderReleaseQty: Decimal;
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        GLSetup.get();
        PeriodStartDate[1] := InvyPlanningName."Starting Date";
        for i := 1 to 31 do begin
            PeriodStartDate[i + 1] := CalcDate('+1D', PeriodStartDate[i]);
        end;

        Item.reset();
        if InvyPlanningName."Item Filter" <> '' then
            Item.setfilter("No.", InvyPlanningName."Item Filter");
        // Item.SetRange("Global Dimension 1 Code", InvyPlanningName."Site");
        if Item.FindSet() then
            repeat

                DimValue.Reset();
                DimValue.setrange("Dimension Code", GLSetup."Global Dimension 1 Code");
                DimValue.setrange("Global Dimension No.", 1);
                if InvyPlanningName.Site <> '' then
                    DimValue.setfilter(Code, InvyPlanningName."Site");

                if DimValue.findset() then
                    repeat
                        Item.setrange("Global Dimension 1 Filter", DimValue.Code);
                        for j := 1 to 3 do begin
                            case j of
                                1:
                                    begin
                                        InitDeliverySchedulingLine(DimValue.Code);
                                        for i := 1 to 31 do begin
                                            Item.SetRange("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                                            DeliverySchedulingLine."Date Type" := DeliverySchedulingLine."Date Type"::"Gross Requirement";
                                            case i of
                                                1:
                                                    DeliverySchedulingLine."Date1 Quantity" := CalcGrossRequirement(Item);
                                                2:
                                                    DeliverySchedulingLine."Date2 Quantity" := CalcGrossRequirement(Item);
                                                3:
                                                    DeliverySchedulingLine."Date3 Quantity" := CalcGrossRequirement(Item);
                                                4:
                                                    DeliverySchedulingLine."Date4 Quantity" := CalcGrossRequirement(Item);
                                                5:
                                                    DeliverySchedulingLine."Date5 Quantity" := CalcGrossRequirement(Item);
                                                6:
                                                    DeliverySchedulingLine."Date6 Quantity" := CalcGrossRequirement(Item);
                                                7:
                                                    DeliverySchedulingLine."Date7 Quantity" := CalcGrossRequirement(Item);
                                                8:
                                                    DeliverySchedulingLine."Date8 Quantity" := CalcGrossRequirement(Item);
                                                9:
                                                    DeliverySchedulingLine."Date9 Quantity" := CalcGrossRequirement(Item);
                                                10:
                                                    DeliverySchedulingLine."Date10 Quantity" := CalcGrossRequirement(Item);
                                                11:
                                                    DeliverySchedulingLine."Date11 Quantity" := CalcGrossRequirement(Item);
                                                12:
                                                    DeliverySchedulingLine."Date12 Quantity" := CalcGrossRequirement(Item);
                                                13:
                                                    DeliverySchedulingLine."Date13 Quantity" := CalcGrossRequirement(Item);
                                                14:
                                                    DeliverySchedulingLine."Date14 Quantity" := CalcGrossRequirement(Item);
                                                15:
                                                    DeliverySchedulingLine."Date15 Quantity" := CalcGrossRequirement(Item);
                                                16:
                                                    DeliverySchedulingLine."Date16 Quantity" := CalcGrossRequirement(Item);
                                                17:
                                                    DeliverySchedulingLine."Date17 Quantity" := CalcGrossRequirement(Item);
                                                18:
                                                    DeliverySchedulingLine."Date18 Quantity" := CalcGrossRequirement(Item);
                                                19:
                                                    DeliverySchedulingLine."Date19 Quantity" := CalcGrossRequirement(Item);
                                                20:
                                                    DeliverySchedulingLine."Date20 Quantity" := CalcGrossRequirement(Item);
                                                21:
                                                    DeliverySchedulingLine."Date21 Quantity" := CalcGrossRequirement(Item);
                                                22:
                                                    DeliverySchedulingLine."Date22 Quantity" := CalcGrossRequirement(Item);
                                                23:
                                                    DeliverySchedulingLine."Date23 Quantity" := CalcGrossRequirement(Item);
                                                24:
                                                    DeliverySchedulingLine."Date24 Quantity" := CalcGrossRequirement(Item);
                                                25:
                                                    DeliverySchedulingLine."Date25 Quantity" := CalcGrossRequirement(Item);
                                                26:
                                                    DeliverySchedulingLine."Date26 Quantity" := CalcGrossRequirement(Item);
                                                27:
                                                    DeliverySchedulingLine."Date27 Quantity" := CalcGrossRequirement(Item);
                                                28:
                                                    DeliverySchedulingLine."Date28 Quantity" := CalcGrossRequirement(Item);
                                                29:
                                                    DeliverySchedulingLine."Date29 Quantity" := CalcGrossRequirement(Item);
                                                30:
                                                    DeliverySchedulingLine."Date30 Quantity" := CalcGrossRequirement(Item);
                                                31:
                                                    DeliverySchedulingLine."Date31 Quantity" := CalcGrossRequirement(Item);
                                            end;
                                        end;
                                        DeliverySchedulingLine.Modify();
                                    end;
                                2:
                                    begin
                                        InitDeliverySchedulingLine(DimValue.Code);
                                        for i := 1 to 31 do begin

                                            Item.SetRange("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                                            DeliverySchedulingLine."Date Type" := DeliverySchedulingLine."Date Type"::"Scheduled Receipt";
                                            case i of
                                                1:
                                                    begin
                                                        DeliverySchedulingLine."Date1 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date1 Quantity" -= PlannedOrderReleaseQty;
                                                    end;

                                                2:
                                                    begin
                                                        DeliverySchedulingLine."Date2 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date2 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                3:
                                                    begin
                                                        DeliverySchedulingLine."Date3 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date3 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                4:
                                                    begin
                                                        DeliverySchedulingLine."Date4 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date4 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                5:
                                                    begin
                                                        DeliverySchedulingLine."Date5 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date5 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                6:
                                                    begin
                                                        DeliverySchedulingLine."Date6 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date6 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                7:
                                                    begin
                                                        DeliverySchedulingLine."Date7 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date7 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                8:
                                                    begin
                                                        DeliverySchedulingLine."Date8 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date8 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                9:
                                                    begin
                                                        DeliverySchedulingLine."Date9 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date9 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                10:
                                                    begin
                                                        DeliverySchedulingLine."Date10 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date10 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                11:
                                                    begin
                                                        DeliverySchedulingLine."Date11 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date11 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                12:
                                                    begin
                                                        DeliverySchedulingLine."Date12 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date12 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                13:
                                                    begin
                                                        DeliverySchedulingLine."Date13 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date13 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                14:
                                                    begin
                                                        DeliverySchedulingLine."Date14 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date14 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                15:
                                                    begin
                                                        DeliverySchedulingLine."Date15 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date15 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                16:
                                                    begin
                                                        DeliverySchedulingLine."Date16 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date16 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                17:
                                                    begin
                                                        DeliverySchedulingLine."Date17 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date17 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                18:
                                                    begin
                                                        DeliverySchedulingLine."Date18 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date18 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                19:
                                                    begin
                                                        DeliverySchedulingLine."Date19 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date19 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                20:
                                                    begin
                                                        DeliverySchedulingLine."Date20 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date20 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                21:
                                                    begin
                                                        DeliverySchedulingLine."Date21 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date21 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                22:
                                                    begin
                                                        DeliverySchedulingLine."Date22 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date22 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                23:
                                                    begin
                                                        DeliverySchedulingLine."Date23 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date23 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                24:
                                                    begin
                                                        DeliverySchedulingLine."Date24 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date24 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                25:
                                                    begin
                                                        DeliverySchedulingLine."Date25 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date25 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                26:
                                                    begin
                                                        DeliverySchedulingLine."Date26 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date26 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                27:
                                                    begin
                                                        DeliverySchedulingLine."Date27 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date27 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                28:
                                                    begin
                                                        DeliverySchedulingLine."Date28 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date28 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                29:
                                                    begin
                                                        DeliverySchedulingLine."Date29 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date29 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                30:
                                                    begin
                                                        DeliverySchedulingLine."Date30 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date30 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                                31:
                                                    begin
                                                        DeliverySchedulingLine."Date31 Quantity" := AvailToPromise.CalcScheduledReceipt(Item);
                                                        PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                                        DeliverySchedulingLine."Date31 Quantity" -= PlannedOrderReleaseQty;
                                                    end;
                                            end;
                                        end;
                                        DeliverySchedulingLine.Modify();
                                    end;
                                3:
                                    begin
                                        InitDeliverySchedulingLine(DimValue.Code);
                                        for i := 1 to 31 do begin

                                            Item.SetRange("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                                            DeliverySchedulingLine."Date Type" := DeliverySchedulingLine."Date Type"::"Planned Inventory";

                                            Item.CalcFields("Planning Receipt (Qty.)");
                                            PlannedOrderReleaseQty := Item.CalcPlannedOrderReceiptQty();
                                            case i of
                                                1:
                                                    DeliverySchedulingLine."Date1 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                2:
                                                    DeliverySchedulingLine."Date2 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                3:
                                                    DeliverySchedulingLine."Date3 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                4:
                                                    DeliverySchedulingLine."Date4 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                5:
                                                    DeliverySchedulingLine."Date5 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                6:
                                                    DeliverySchedulingLine."Date6 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                7:
                                                    DeliverySchedulingLine."Date7 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                8:
                                                    DeliverySchedulingLine."Date8 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                9:
                                                    DeliverySchedulingLine."Date9 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                10:
                                                    DeliverySchedulingLine."Date10 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                11:
                                                    DeliverySchedulingLine."Date11 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                12:
                                                    DeliverySchedulingLine."Date12 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                13:
                                                    DeliverySchedulingLine."Date13 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                14:
                                                    DeliverySchedulingLine."Date14 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                15:
                                                    DeliverySchedulingLine."Date15 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                16:
                                                    DeliverySchedulingLine."Date16 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                17:
                                                    DeliverySchedulingLine."Date17 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                18:
                                                    DeliverySchedulingLine."Date18 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                19:
                                                    DeliverySchedulingLine."Date19 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                20:
                                                    DeliverySchedulingLine."Date20 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                21:
                                                    DeliverySchedulingLine."Date21 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                22:
                                                    DeliverySchedulingLine."Date22 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                23:
                                                    DeliverySchedulingLine."Date23 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                24:
                                                    DeliverySchedulingLine."Date24 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                25:
                                                    DeliverySchedulingLine."Date25 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                26:
                                                    DeliverySchedulingLine."Date26 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                27:
                                                    DeliverySchedulingLine."Date27 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                28:
                                                    DeliverySchedulingLine."Date28 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                29:
                                                    DeliverySchedulingLine."Date29 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                30:
                                                    DeliverySchedulingLine."Date30 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                                31:
                                                    DeliverySchedulingLine."Date31 Quantity" := Item."Planning Receipt (Qty.)" + PlannedOrderReleaseQty;
                                            end;
                                        end;
                                        DeliverySchedulingLine.Modify();
                                    end;
                            end;
                        end;
                    until DimValue.Next() = 0;
            until Item.Next() = 0;
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
          "Planning Transfer Ship. (Qty).",
          "Qty. on Sales Order",
          "Qty. on Job Order",
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
        DayCaption: array[31] of Text[30];
        DeliverySchedulingLine: Record "RV Invy. Planning Line";
        i: Integer;
        j: Integer;
        Item: Record Item;
        PeriodStartDate: array[32] of Date;
        AvailToPromise: Codeunit "Available to Promise";
        InvyPlanningName: Record "RV Invy. Planning Name";
        AllFieldCalculated: Boolean;
        PrevItemNo: Code[20];
        PrevItemFilters: Text;
}
