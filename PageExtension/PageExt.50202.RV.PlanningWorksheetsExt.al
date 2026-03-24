/// <summary>
/// PageExtension Rv_Planning Worksheet (ID 50202) extends "Planning Worksheet"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// FDD002 2026/03/16: New. (Bobby.ji)
/// </summary>
pageextension 50202 "RV_Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        addafter("Accept Action Message")
        {
            field("Available in Multiple Vendors"; Rec.RV_AvailableInMultipleVendor)
            {
                Caption = 'Available in Multiple Vendors';
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Description")
        {
            field("Expiration Calculation"; Rec."RV_Expiration Calculation")
            {
                Caption = 'Expiration Calculation';
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {
        addbefore("F&unctions")
        {
            action("Vendor Selection")
            {
                ApplicationArea = All;
                Caption = 'Vendor Selection';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Enabled = IsVendorSelection;

                trigger OnAction()
                var
                    VendorSelection: page "RIKEV Vendor Selection";
                    RV_VendorSelection: Record "RIKE Vendor Selection";
                    ItemVendor: Record "Item Vendor";
                begin
                    //RV_VendorSelection.DeleteAll();
                    RV_VendorSelection.Reset();
                    RV_VendorSelection.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    RV_VendorSelection.SetRange("Line No.", Rec."Line No.");
                    RV_VendorSelection.SetRange("Item No.", Rec."No.");
                    if not RV_VendorSelection.FindFirst() then begin
                        ItemVendor.Reset();
                        ItemVendor.SetRange("Item No.", Rec."No.");
                        if ItemVendor.FindFirst() then begin
                            repeat
                                RV_VendorSelection.Init();
                                RV_VendorSelection."Journal Batch Name" := Rec."Journal Batch Name";
                                RV_VendorSelection."Line No." := Rec."Line No.";
                                RV_VendorSelection."Item No." := Rec."No.";
                                RV_VendorSelection."Vendor No." := ItemVendor."Vendor No.";
                                RV_VendorSelection."Starting Date" := Rec."Starting Date";
                                RV_VendorSelection."Ending Date" := Rec."Ending Date";
                                RV_VendorSelection."Minimum Order Quantity" := ItemVendor."RV_Minimum Order Quantity";
                                RV_VendorSelection."Maxmum Order Quantity" := ItemVendor."RV_Maximum Order Quantity";
                                RV_VendorSelection."Quantity to Order" := 0;
                                RV_VendorSelection."Unit of Measure Code" := Rec."Unit of Measure Code";
                                RV_VendorSelection.Insert();
                            until ItemVendor.Next() = 0;
                        end;
                        Commit();
                    end;

                    VendorSelection.SetParameters(Rec.Quantity);
                    VendorSelection.SetTableView(RV_VendorSelection);
                    VendorSelection.RunModal();
                end;
            }
        }
    }
    var
        IsVendorSelection: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsVendorSelection := false;
        if Rec.RV_AvailableInMultipleVendor then begin
            IsVendorSelection := true;
        end;
    end;
}
