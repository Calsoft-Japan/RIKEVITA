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
                if "Data Type" IN [rec."Data Type"::"Adjust Consumption", rec."Data Type"::"Planned Consumption"] then
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
            begin
                if "Prod. Order No." = '' then
                    Error(ErrProdNoBlank, "Output Item No.");

                if rec.uom = '' then
                    case "Data Type" of
                        "RV Prod. Results Data Type"::"Planned Output",
                        "RV Prod. Results Data Type"::"Adjust Output":
                            begin
                                item.get("Output Item No.");
                                Validate(rec."UOM", item."Base Unit of Measure");
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
            begin
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
        }
        field(11; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            DecimalPlaces = 0 : 5;
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
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(15; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(16; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }
        field(17; "Status"; Enum "RV Prod. Results Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            begin
                if Rec.Status = Rec.Status::"Ready Post" then
                    xRec.TestField(Status, xRec.Status::Approved);
            end;
        }
        field(18; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE("Prod. Order No." = FIELD("Prod. Order No."), Status = CONST(Released));
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

    var
        ProdOrderLine: Record "Prod. Order Line";
        ErrProdNoBlank: Label 'You can not insert item number %1 because it is not produced on released production order.';
}