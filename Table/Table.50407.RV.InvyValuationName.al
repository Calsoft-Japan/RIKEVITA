table 50407 "RV Invy. Valuation Name"

{
    Caption = 'Invy. Valuation Name';
    DrillDownPageId = "RV Invy. Valuation Names";
    LookupPageId = "RV Invy. Valuation Names";
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
            tableRelation = "Dimension Value" where("Global Dimension No." = const(1));
        }

        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(6; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
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

    var

    var
        Confirm001Qst: Label 'Are you sure you want to delete the Inventory Valuation Name %1? All related Invnentory Valuation Lines will also be deleted.';

}
