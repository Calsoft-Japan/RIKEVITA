table 50409 "RV Invy. Available Name"
{
    Caption = 'Invy. Available Name';
    DrillDownPageId = "RV BackedDate Stock Names";
    LookupPageId = "RV BackedDate Stock Names";
    DataCaptionFields = Name, Description;
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "View By"; Enum "Analysis Period Type")
        {
            Caption = 'View By';
        }

        field(4; "Site"; Code[20])
        {
            Caption = 'Site';
            tableRelation = "Dimension Value" where("Global Dimension No." = const(2));
        }

        field(5; "Inventory Valuation Date"; Date)
        {
            Caption = 'Inventory Valuation Date';
        }
        field(6; "Item Filter"; Text[250])
        {
            Caption = 'Item Filter';
        }

    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DeliverySchedulingLine: Record "RV Invy. Planning Line";
    begin
        DeliverySchedulingLine.SetRange("Delivery Scheduling Name", Name);
        if not DeliverySchedulingLine.IsEmpty() then begin
            if GuiAllowed then
                if not Confirm(Confirm001Qst, true, Name) then
                    Error('');
            DeliverySchedulingLine.DeleteAll();
        end;
    end;

    trigger OnInsert()
    begin
        rec.TestField(Name);
    end;

    trigger OnModify()
    begin
        rec.TestField(Name);
    end;

    var

    var
        Confirm001Qst: Label 'Are you sure you want to delete the Inventory Available Name %1? All related Invnentory Available Lines will also be deleted.';

}
