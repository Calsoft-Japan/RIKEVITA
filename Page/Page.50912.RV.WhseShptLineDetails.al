/// <summary>
/// Page RV Whse Shpt Line Details (ID 50912)
/// FDD101 2026/10/25: New. (Shawn)
/// </summary>
page 50912 "RV Whse Shpt Line Details"
{
    ApplicationArea = All;
    Caption = 'Warehouse Shipment Line Details';
    PageType = List;
    SourceTable = "Warehouse Shipment Line";
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
                field("Source No."; Rec."Source No.")
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
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
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
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                }
                field("Qty. Shipped"; Rec."Qty. Shipped")
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
                        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
                            PageManagement.PageRun(SalesHeader);
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
        ReserveEntry: Record "Reservation Entry";
        ItemTrackingSetup: Record "Item Tracking Setup";
        strConcat: Text[1024];
        formatDate: Text[20];
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        EntriesExist: Boolean;
        ExpDate: Date;

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

        if (Rec."Source Type" = 37) and (Rec."Source Subtype" = 1) then begin
            // Source is Sales Order Line
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
                SelltoCustNo := SalesHeader."Sell-to Customer No.";
                SelltoCustName := SalesHeader."Sell-to Customer Name";
                BilltoCustNo := SalesHeader."Bill-to Customer No.";
                BilltoName := SalesHeader."Bill-to Name";
                ShiptoCode := SalesHeader."Ship-to Code";
                ShiptoName := SalesHeader."Ship-to Name";
                ShiptoAddress := SalesHeader."Ship-to Address";
                ShiptoAddress2 := SalesHeader."Ship-to Address 2";
            end;
        end;

        ReserveEntry.SetRange("Source Type", 37); //Sales Line
        ReserveEntry.SetRange("Source Subtype", 1); //Order
        ReserveEntry.SetRange("Source ID", Rec."Source No."); // Sales Order No.
        ReserveEntry.SetRange("Source Ref. No.", Rec."Source Line No."); // Sales Order Line No.
        if ReserveEntry.FindSet() then
            repeat
                if ReserveEntry."Lot No." <> '' then begin
                    strConcat := (StrLen(LotNo) > 0) ? (LotNo + '|' + ReserveEntry."Lot No.") : ReserveEntry."Lot No.";
                    LotNo := CopyStr(strConcat, 1, 250);
                end;

                // Expiratin Date is not in Reservation Entry of Sales transactions. 
                // So refer code snip in AddToGlobalRecordSet of Item Tracking Lines.
                ItemTrackingSetup.CopyTrackingFromReservEntry(ReserveEntry);
                ExpDate := ItemTrackingMgt.ExistingExpirationDate(Rec."Item No.", Rec."Variant Code", ItemTrackingSetup, false, EntriesExist);

                if ExpDate <> 0D then begin
                    formatDate := Format(ExpDate, 0, '<Day,2>/<Month,2>/<Year4>');
                    strConcat := (StrLen(ExpirationDate) > 0) ? (ExpirationDate + '|' + formatDate) : formatDate;
                    ExpirationDate := CopyStr(strConcat, 1, 250);
                end;
            until ReserveEntry.Next() = 0;
    end;

    var
        SalesHeader: Record "Sales Header";
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
