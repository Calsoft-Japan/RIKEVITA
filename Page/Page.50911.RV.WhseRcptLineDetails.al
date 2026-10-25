/// <summary>
/// Page RV Whse Rcpt Line Details (ID 50911)
/// FDD101 2026/10/25: New. (Shawn)
/// </summary>
page 50911 "RV Whse Rcpt Line Details"
{
    ApplicationArea = All;
    Caption = 'Warehouse Receipt Line Details';
    PageType = List;
    SourceTable = "Warehouse Receipt Line";
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
                field("Buy-from Vendor No."; VendorNo)
                {
                }
                field("Buy-from Vendor Name"; VendorName)
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
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                }
                field("Qty. Received"; Rec."Qty. Received")
                {
                }
                field("Lot No."; LotNo)
                {
                }
                field("Expiration Date"; ExpirationDate)
                {
                }
                field("Manufacture Date"; ManufactureDate)
                {
                }
                field("Container No."; ContainerNo)
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
                        if PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Source No.") then begin
                            PageManagement.PageRun(PurchHeader);
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
        strConcat: Text[1024];
        formatDate: Text[20];

    begin
        Clear(VendorNo);
        Clear(VendorName);
        Clear(LotNo);
        Clear(ExpirationDate);
        Clear(ManufactureDate);
        Clear(ContainerNo);
        Clear(strConcat);

        if (Rec."Source Type" = 39) and (Rec."Source Subtype" = 1) then begin
            // Source is Purchase Order Line
            if PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Source No.") then begin
                VendorNo := PurchHeader."Buy-from Vendor No.";
                VendorName := PurchHeader."Buy-from Vendor Name";
            end;
        end;

        ReserveEntry.SetRange("Source Type", 39); //Purchase Line
        ReserveEntry.SetRange("Source Subtype", 1); //Order
        ReserveEntry.SetRange("Source ID", Rec."Source No."); // Purchase Order No.
        ReserveEntry.SetRange("Source Ref. No.", Rec."Source Line No."); // Purchase Order Line No.
        if ReserveEntry.FindSet() then
            repeat
                if ReserveEntry."Lot No." <> '' then begin
                    strConcat := (StrLen(LotNo) > 0) ? (LotNo + '|' + ReserveEntry."Lot No.") : ReserveEntry."Lot No.";
                    LotNo := CopyStr(strConcat, 1, 250);
                end;
                if ReserveEntry."Expiration Date" <> 0D then begin
                    formatDate := Format(ReserveEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    strConcat := (StrLen(ExpirationDate) > 0) ? (ExpirationDate + '|' + formatDate) : formatDate;
                    ExpirationDate := CopyStr(strConcat, 1, 250);
                end;
                if ReserveEntry."RV_Manufacture Date" <> 0D then begin
                    formatDate := Format(ReserveEntry."RV_Manufacture Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    strConcat := (StrLen(ManufactureDate) > 0) ? (ManufactureDate + '|' + formatDate) : formatDate;
                    ManufactureDate := CopyStr(strConcat, 1, 250);
                end;
                if ReserveEntry."RV_Container No." <> '' then begin
                    strConcat := (StrLen(ContainerNo) > 0) ? (ContainerNo + '|' + ReserveEntry."RV_Container No.") : ReserveEntry."RV_Container No.";
                    ContainerNo := CopyStr(strConcat, 1, 250);
                end;
            until ReserveEntry.Next() = 0;
    end;

    var
        PurchHeader: Record "Purchase Header";
        VendorNo: Code[20];
        VendorName: Text[100];
        LotNo: Text[250];
        ExpirationDate: Text[250];
        ManufactureDate: Text[250];
        ContainerNo: Text[250];
}
