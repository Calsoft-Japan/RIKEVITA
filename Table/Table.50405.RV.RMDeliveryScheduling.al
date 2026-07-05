// ------------------------------------------------------------------------------------------------
// Raw Material Delivery Scheduling for prod.
// ------------------------------------------------------------------------------------------------
table 50405 "RM Delivery Scheduling Name"
{
    Caption = 'Delivery Scheduling Name';
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

        field(4; "Site"; Code[20])
        {
            Caption = 'Site';
            tableRelation = "Dimension Value" where("Global Dimension No." = const(1));
        }

        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
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

    /* trigger OnDelete()
     var
         ProdForecastEntry: Record "Production Forecast Entry";
     begin
         ProdForecastEntry.SetRange("Production Forecast Name", Name);
         if not ProdForecastEntry.IsEmpty() then begin
             if GuiAllowed then
                 if not Confirm(Confirm001Qst, true, Name) then
                     Error('');
             ProdForecastEntry.DeleteAll();
         end;
     end;
 */
    var

    [TryFunction]
    local procedure TrySetFilter(DateFilter: Text)
    var
        Period: Record Date;
    begin
        Period.SetFilter("Period Start", DateFilter);
    end;
}

