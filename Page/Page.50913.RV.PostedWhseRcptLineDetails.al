/// <summary>
/// Page RV Posted Whse Rcpt Line Dtl (ID 50913)
/// FDD101 2026/10/26: New. (Shawn)
/// </summary>
page 50913 "RV Posted Whse Rcpt Line Dtl"
{
    ApplicationArea = All;
    Caption = 'Posted Whse. Receipt Line Details';
    PageType = List;
    SourceTable = "Posted Whse. Receipt Line";
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
                field("Source Document"; Rec."Source Document")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                }
                field("Buy-from Vendor No."; VendorNo)
                {
                }
                field("Buy-from Vendor Name"; VendorName)
                {
                }
                field("Posting Date"; Rec."Posting Date")
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
                field("Lot No."; LotNo)
                {
                }
                field("Expiration Date"; ExpirationDate)
                {
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
                        if PurchRcptHeader.Get(Rec."Posted Source No.") then begin
                            PageManagement.PageRun(PurchRcptHeader);
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
        Clear(VendorNo);
        Clear(VendorName);
        Clear(LotNo);
        Clear(ExpirationDate);
        Clear(strConcat);
        TempItemLedgEntry.DeleteAll();

        if (Rec."Source Document" = Rec."Source Document"::"Purchase Order") then begin
            // Source is Purchase Order Line
            if PurchRcptHeader.Get(Rec."Posted Source No.") then begin
                VendorNo := PurchRcptHeader."Buy-from Vendor No.";
                VendorName := PurchRcptHeader."Buy-from Vendor Name";
            end;
        end;

        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgEntry, DATABASE::"Purch. Rcpt. Line", 0, Rec."Posted Source No.", '', 0, Rec."Source Line No.");
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
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        VendorNo: Code[20];
        VendorName: Text[100];
        LotNo: Text[250];
        ExpirationDate: Text[250];
}
