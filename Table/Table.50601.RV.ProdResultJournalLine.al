/// <summary>
/// Table RV Prod. Results Journal Line (ID 50601)
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
table 50601 "RV Prod. Result Journal Line"
{
    DataClassification = ToBeClassified;
    Caption = 'RV Prod. Results Journal Line';

    fields
    {
        field(2; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "RV Prod. Results Journal Bat"."Name";
            NotBlank = true;
        }
        field(3; "Journal Line No."; Integer)
        {
            Caption = 'Journal Line No.';
        }
        field(4; "Data Type"; Enum "RV Prod. Results Data Type")
        {
            Caption = 'Data Type';
        }
        field(5; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." where(Status = CONST(Released));

            trigger OnValidate()
            var
                ProdOrderLine: Record "Prod. Order Line";
            begin
                if "Data Type" IN [rec."Data Type"::"Adjust Consumption", rec."Data Type"::"Planned Consumption", rec."Data Type"::"Recycle Consumption"] then
                    if "Prod. Order No." <> '' then begin
                        ProdOrderLine.SetFilterByReleasedOrderNo(Rec."Prod. Order No.");
                        if ProdOrderLine.Count = 1 then begin
                            ProdOrderLine.FindFirst();
                            Rec.Validate("Prod. Order Line No.", ProdOrderLine."Line No.");
                        end;
                    end;
            end;
        }
        field(6; "Output Item No."; Code[20])
        {
            Caption = 'Output Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                item: Record Item;
                ProdOrderLine: Record "Prod. Order Line";
                T83: Record "item journal line";
            begin
                if "Prod. Order No." = '' then
                    Error(ErrProdNoBlank, "Output Item No.");
                if "Output Item No." = '' then begin
                    "Prod. Order Line No." := 0;
                    "output item description" := '';
                    UOM := '';
                    "location code" := '';
                end else begin
                    ProdOrderLine.SetFilterByReleasedOrderNo(Rec."Prod. Order No.");
                    ProdOrderLine.SetRange("Item No.", Rec."Output Item No.");
                    if not ProdOrderLine.FindFirst() then
                        Error(ErrOutputItemNoNotExist, "Output Item No.", Rec."Prod. Order No.");
                    "Prod. Order Line No." := ProdOrderLine."Line No.";
                    "Routing No." := ProdOrderLine."Routing No.";
                    "location code" := ProdOrderLine."Location Code";

                    if rec.uom = '' then
                        case "Data Type" of
                            "RV Prod. Results Data Type"::"Planned Output",
                            "RV Prod. Results Data Type"::"Adjust Output":
                                begin
                                    item.get("Output Item No.");
                                    "Output Item Description" := item."Description";
                                    Validate(rec."UOM", ProdOrderLine."Unit of Measure Code");
                                    // end;
                                end;
                            "RV Prod. Results Data Type"::"Planned Consumption",
                            "RV Prod. Results Data Type"::"Adjust Consumption",
                            "RV Prod. Results Data Type"::"Recycle Consumption":
                                begin
                                    item.get("Output Item No.");
                                    "Output Item Description" := item."Description";
                                end;
                        end;
                end;
            end;

            trigger OnLookup()
            var
                ProdOrderLine: Record "Prod. Order Line";
                ProdOrderLineList: Page "Prod. Order Line List";
            begin
                ProdOrderLine.SetFilterByReleasedOrderNo(rec."Prod. Order No.");
                ProdOrderLine.Status := ProdOrderLine.Status::Released;
                ProdOrderLine."Prod. Order No." := rec."Prod. Order No.";
                ProdOrderLine."Line No." := rec."Prod. Order Line No.";
                ProdOrderLine."Item No." := rec."Item No.";

                ProdOrderLineList.LookupMode(true);
                ProdOrderLineList.SetTableView(ProdOrderLine);
                ProdOrderLineList.SetRecord(ProdOrderLine);

                if ProdOrderLineList.RunModal() = ACTION::LookupOK then begin
                    ProdOrderLineList.GetRecord(ProdOrderLine);
                    rec.Validate("Output Item No.", ProdOrderLine."Item No.");
                    if rec."Prod. Order Line No." <> ProdOrderLine."Line No." then
                        rec.Validate("Prod. Order Line No.", ProdOrderLine."Line No.");
                    if rec."Routing No." <> ProdOrderLine."Routing No." then
                        rec.Validate("Routing No.", ProdOrderLine."Routing No.");
                end;
            end;
        }
        field(7; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No."
                            WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                  "Routing No." = FIELD("Routing No."),
                                  "Routing Reference No." = field("Prod. Order Line No."),
                                  Status = CONST(Released));

            trigger OnValidate()
            var
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
                WorkCenter: Record "Work Center";
            begin
                if ProdOrderRtngLine.Get(
                    ProdOrderRtngLine.Status::Released, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.") then begin
                    WorkCenter.Get(ProdOrderRtngLine."No.");
                    "Work Center No." := WorkCenter."No.";
                end else
                    "Work Center No." := '';
            end;
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                UOM: Record "Item Unit of Measure";
                ProdOrderComponent: Record "Prod. Order Component";
                Item: Record Item;
            begin
                if rec."Data Type" in [rec."Data Type"::"Adjust Consumption", rec."Data Type"::"Planned Consumption", rec."Data Type"::"Recycle Consumption"] then begin
                    ProdOrderComponent.SetFilterByReleasedOrderNo(Rec."Prod. Order No.");
                    if Rec."Prod. Order Line No." <> 0 then
                        ProdOrderComponent.SetRange("Prod. Order Line No.", Rec."Prod. Order Line No.");
                    ProdOrderComponent.SetRange("Item No.", Rec."Item No.");
                    if ProdOrderComponent.FindFirst() then begin
                        if Rec."Prod. Order Line No." = 0 then
                            Rec."Prod. Order Line No." := ProdOrderComponent."Prod. Order Line No.";
                        Validate("Prod. Order Comp. Line No.", ProdOrderComponent."Line No.");
                        rec.UOM := ProdOrderComponent."Unit of Measure Code";
                        rec."Location Code" := ProdOrderComponent."Location Code";
                        rec."Bin Code" := ProdOrderComponent."Bin Code";
                    end else begin
                        Validate("Prod. Order Comp. Line No.", 0);
                        rec.UOM := '';
                        rec."Location Code" := '';
                        rec."Bin Code" := '';
                    end;

                    if rec.uom = '' then
                        case "Data Type" of
                            "RV Prod. Results Data Type"::"Adjust Consumption",
                            "RV Prod. Results Data Type"::"Planned Consumption":
                                begin
                                    UOM.SetRange("Item No.", Rec."Item No.");
                                    if UOM.FindFirst() then
                                        Validate(rec."UOM", UOM.Code);
                                end;
                        end;

                    if rec.UOM = '' then begin
                        if item.Get(Rec."Item No.") then
                            Validate(rec."UOM", item."Base Unit of Measure");
                    end;

                    if item.Get(Rec."Item No.") then
                        rec."Item Description" := item."Description";
                end;
            end;
        }
        field(9; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";
        }
        field(10; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(11; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(12; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = IF ("Data Type" = CONST("Planned Output")) "Item Unit of Measure".code where("Item No." = FIELD("Output Item No."))
            ELSE IF ("Data Type" = CONST("Adjust Output")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Output Item No."))
            ELSE IF ("Data Type" = CONST("Planned Consumption")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."))
            ELSE IF ("Data Type" = CONST("Adjust Consumption")) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(13; "Lot No."; Code[30])
        {
            Caption = 'Lot No.';
        }
        field(15; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';

            trigger OnValidate()
            begin
                UpdateExpireDate();
            end;
        }
        field(16; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }
        field(17; "Status"; Enum "RV Prod. Results Status")
        {
            Caption = 'Status';
        }
        field(18; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE("Prod. Order No." = FIELD("Prod. Order No."), Status = CONST(Released));
            BlankZero = true;
            trigger OnValidate()
            var
                ProdOrderLine: Record "Prod. Order Line";
            begin
                ProdOrderLine.SetFilterByReleasedOrderNo(Rec."Prod. Order No.");
                ProdOrderLine.SetRange("Line No.", Rec."Prod. Order Line No.");
                if ProdOrderLine.FindFirst() then begin
                    rec."Routing No." := ProdOrderLine."Routing No.";
                end;
            end;
        }
        field(19; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
        }
        field(20; "Prod. Order Comp. Line No."; Integer)
        {
            Caption = 'Prod. Order Comp. Line No.';
            TableRelation = "Prod. Order Component"."Line No."
                            WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                  "Prod. Order Line No." = field("Prod. Order Line No."),
                                  Status = CONST(Released));
            BlankZero = true;
            trigger OnLookup()
            var
                ProdOrderComp: Record "Prod. Order Component";
                ProdOrderCompLineList: Page "Prod. Order Comp. Line List";
            begin
                ProdOrderComp.SetFilterByReleasedOrderNo("Prod. Order No.");
                if "Prod. Order Line No." <> 0 then
                    ProdOrderComp.SetRange("Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComp.Status := ProdOrderComp.Status::Released;
                ProdOrderComp."Prod. Order No." := "Prod. Order No.";
                ProdOrderComp."Prod. Order Line No." := "Prod. Order Line No.";
                ProdOrderComp."Line No." := "Prod. Order Comp. Line No.";
                ProdOrderComp."Item No." := "Item No.";

                ProdOrderCompLineList.LookupMode(true);
                ProdOrderCompLineList.SetTableView(ProdOrderComp);
                ProdOrderCompLineList.SetRecord(ProdOrderComp);

                if ProdOrderCompLineList.RunModal() = ACTION::LookupOK then begin
                    ProdOrderCompLineList.GetRecord(ProdOrderComp);
                    if "Prod. Order Comp. Line No." <> ProdOrderComp."Line No." then begin
                        Validate("Item No.", ProdOrderComp."Item No.");
                        Validate("Prod. Order Comp. Line No.", ProdOrderComp."Line No.");
                    end;
                end;
            end;
        }
        field(21; "Error Message"; text[250])
        {
            Caption = 'Error Message';
        }
        field(22; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = "Location";
            trigger OnValidate()
            begin
                if rec."Location Code" <> xrec."Location Code" then
                    rec."Bin Code" := '';
            end;
        }
        field(23; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = if ("Data Type" = filter("Planned Output" | "Adjust Output"),
                                Quantity = filter(>= 0)) Bin.Code
                                where("Location Code" = field("Location Code"),
                                "Item Filter" = field("Item No."))
            else
            if ("Data Type" = filter("Planned Output" | "Adjust Output"),
                              Quantity = filter(< 0)) "Bin Content"."Bin Code"
                              where("Location Code" = field("Location Code"),
                              "Item No." = field("Item No."))
            else
            if ("Data Type" = filter("Planned Consumption" | "Adjust Consumption" | "Recycle Consumption"),
                              Quantity = filter(> 0)) "Bin Content"."Bin Code"
                              where("Location Code" = field("Location Code"),
                              "Item No." = field("Item No."))
            else
            if ("Data Type" = filter("Planned Consumption" | "Adjust Consumption" | "Recycle Consumption"),
                              Quantity = filter(<= 0)) Bin.Code where("Location Code" = field("Location Code"),
                              "Item Filter" = field("Item No."));
        }
        field(24; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            ToolTip = 'Specifies the variant of the item on the line.';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(25; "Qty. per Unit of Measure"; decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Output Item Description"; Text[100])
        {
            Caption = 'Output Item Description';
        }
        field(27; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
    }
    keys
    {
        key(PK; "Batch Name", "Journal Line No.")
        {
            Clustered = true;
        }
        key(SK1; Status, "Prod. Order No.", "Prod. Order Line No.")
        {
        }
    }
    procedure UpdateExpireDate()
    var
        Item: Record Item;
    begin
        if rec."Data Type" IN [rec."Data Type"::"Adjust Output", rec."Data Type"::"Planned Output"] then begin
            Item.Get(Rec."Output Item No.");
            if Format(Item."Expiration Calculation") <> '' then begin
                if rec."Manufacturing Date" <> 0D then
                    Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Manufacturing Date")
            end;
        end else begin
            // Item.Get(Rec."Item No.");
            // if Format(Item."Expiration Calculation") <> '' then begin
            //     if rec."Manufacturing Date" <> 0D then
            //         Rec."Expire Date" := CalcDate(Item."Expiration Calculation", Rec."Manufacturing Date")
            // end;
        end;
    end;

    var
        ProdOrderLine: Record "Prod. Order Line";
        ErrProdNoBlank: Label 'You can not insert item number %1 because it is not produced on released production order.';
        ErrOutputItemNoNotExist: Label 'You can not insert item number %1 because it is not produced on released production order %2.';
}