/// <summary>
/// Page RV Posted Whse Shpt Line Dtl (ID 50914)
/// FDD101 2026/10/26: New. (Shawn)
/// </summary>
page 50914 "RV Posted Whse Shpt Line Dtl"
{
    ApplicationArea = All;
    Caption = 'Posted Whse. Shipment Line Details';
    PageType = List;
    SourceTable = "Posted Whse. Shipment Line";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                }
                field("Source Document"; Rec."Source Document")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                }
                field("Sell-to Customer No."; SelltoCustNo)
                {
                }
                field("Sell-to Customer Name"; SelltoCustName)
                {
                }
                field("Bill-to Customer No."; BilltoCustNo)
                {
                }
                field("Bill-to Name"; BilltoName)
                {
                }
                field("Ship-to Code"; ShiptoCode)
                {
                }
                field("Ship-to Name"; ShiptoName)
                {
                }
                field("Ship-to Address"; ShiptoAddress)
                {
                }
                field("Ship-to Address2"; ShiptoAddress2)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Lot No."; LotNo)
                {
                }
                field("Expiration Date"; ExpirationDate)
                {
                }
                field("RV_B/L Date"; Rec."RV_B/L Date")
                {
                    Caption = 'B/L Date';
                }
                field("RV_Closing Date"; Rec."RV_Closing Date")
                {
                    Caption = 'Closing Date';
                }
                field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
                {
                    Caption = 'Stuffing Date';
                }
                field(RV_ETD; Rec.RV_ETD)
                {
                    Caption = 'ETD';
                }
                field(RV_ETA; Rec.RV_ETA)
                {
                    Caption = 'ETA';
                }
                field("RV_SI Received Date"; Rec."RV_SI Received Date")
                {
                    Caption = 'SI Received Date';
                }
                field("RV_Print RSPO No."; Rec."RV_Print RSPO No.")
                {
                    Caption = 'Print RSPO No.';
                }
                field("RV_Symbol Display Packing List"; Rec."RV_Symbol Display Packing List")
                {
                    Caption = 'Symbol Display Packing List';
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        if SalesShptHeader.Get(Rec."Posted Source No.") then begin
                            PageManagement.PageRun(SalesShptHeader);
                        end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Show Document_Promoted"; "Show Document")
                {
                }
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        strConcat: Text[1024];
        formatDate: Text[20];

    begin
        Clear(SelltoCustNo);
        Clear(SelltoCustName);
        Clear(BilltoCustNo);
        Clear(BilltoName);
        Clear(ShiptoCode);
        Clear(ShiptoName);
        Clear(ShiptoAddress);
        Clear(ShiptoAddress2);
        Clear(LotNo);
        Clear(ExpirationDate);
        Clear(strConcat);
        TempItemLedgEntry.DeleteAll();

        if (Rec."Source Document" = Rec."Source Document"::"Sales Order") then begin
            // Source is Purchase Order Line
            if SalesShptHeader.Get(Rec."Posted Source No.") then begin
                SelltoCustNo := SalesShptHeader."Sell-to Customer No.";
                SelltoCustName := SalesShptHeader."Sell-to Customer Name";
                BilltoCustNo := SalesShptHeader."Bill-to Customer No.";
                BilltoName := SalesShptHeader."Bill-to Name";
                ShiptoCode := SalesShptHeader."Ship-to Code";
                ShiptoName := SalesShptHeader."Ship-to Name";
                ShiptoAddress := SalesShptHeader."Ship-to Address";
                ShiptoAddress2 := SalesShptHeader."Ship-to Address 2";
            end;
        end;

        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgEntry, DATABASE::"Sales Shipment Line", 0, Rec."Posted Source No.", '', 0, Rec."Source Line No.");
        if TempItemLedgEntry.FindSet() then
            repeat
                if TempItemLedgEntry."Lot No." <> '' then begin
                    strConcat := (StrLen(LotNo) > 0) ? (LotNo + '|' + TempItemLedgEntry."Lot No.") : TempItemLedgEntry."Lot No.";
                    LotNo := CopyStr(strConcat, 1, 250);
                end;
                if TempItemLedgEntry."Expiration Date" <> 0D then begin
                    formatDate := Format(TempItemLedgEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    strConcat := (StrLen(ExpirationDate) > 0) ? (ExpirationDate + '|' + formatDate) : formatDate;
                    ExpirationDate := CopyStr(strConcat, 1, 250);
                end;
            until TempItemLedgEntry.Next() = 0;
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
        SelltoCustNo: Code[20];
        SelltoCustName: Text[100];
        BilltoCustNo: Code[20];
        BilltoName: Text[100];
        ShiptoCode: Code[20];
        ShiptoName: Text[100];
        ShiptoAddress: Text[100];
        ShiptoAddress2: Text[100];
        LotNo: Text[250];
        ExpirationDate: Text[250];
}
