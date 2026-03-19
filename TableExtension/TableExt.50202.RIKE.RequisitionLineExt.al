/// <summary>
/// TableExtension RV_Requisition Line (ID 50202) extends Requisition Line table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
tableextension 50202 "RV_Requisition Line" extends "Requisition Line"
{
    fields
    {
        field(50200; "RV_Expiration Calculation"; DateFormula)
        {
            Caption = 'Expiration Calculation';
            Description = 'FDD001';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Expiration Calculation" where("No." = field("No.")));
            TableRelation = Item;
        }
        field(50201; "RV_AvailableInMultipleVendor"; Boolean)
        {
            Caption = 'Available in Multiple Vendors';
            Description = 'FDD002';
            trigger OnValidate()
            var
                ItemVendor: Record "Item Vendor";
            begin
                ItemVendor.Reset();
                ItemVendor.SetRange("Item No.", Rec."No.");
                if ItemVendor.FindFirst() then begin
                    if ItemVendor.Count > 1 then begin
                        RV_AvailableInMultipleVendor := true;
                    end;
                end;

            end;
        }
    }
}
