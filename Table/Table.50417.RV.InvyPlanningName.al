/// <summary>
/// Table RV Invy. Planning Name (ID 50407).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>

table 50417 "RV Invy. Planning Name"
{
    Caption = 'Invy. Planning Name';
    //DrillDownPageID = "Demand Forecast Names";
    //LookupPageID = "Demand Forecast Names";
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

        field(4; "Site"; text[250])
        {
            Caption = 'Site';
            // tableRelation = "Dimension Value".code where("Global Dimension No." = const(1));
        }

        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(6; "Item Filter"; Text[100])
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
        Confirm001Qst: Label 'Are you sure you want to delete the Delivery Scheduling Name %1? All related Delivery Scheduling Lines will also be deleted.';

    [TryFunction]
    local procedure TrySetFilter(DateFilter: Text)
    var
        Period: Record Date;
    begin
        Period.SetFilter("Period Start", DateFilter);
    end;
}

