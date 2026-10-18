table 50409 "RV Invy. Available Name"
{
    Caption = 'Invy. Available Name';
    DrillDownPageId = "RV Inventory Monitorings";
    LookupPageId = "RV Inventory Monitorings";
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

        field(5; "Inventory Valuation Date"; Date)
        {
            Caption = 'Inventory Valuation Date';
        }
        field(6; "Item Filter"; Text[250])
        {
            Caption = 'Item Filter';
        }
        field(7; "Location Filter"; Text[250])
        {
            Caption = 'Location Filter';
        }
        field(8; "Stock Status"; Text[250])
        {
            Caption = 'Stock Status';
        }

        field(10; "Shortcut Dimension 1 Code"; Text[250])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(11; "Shortcut Dimension 2 Code"; Text[250])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

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
