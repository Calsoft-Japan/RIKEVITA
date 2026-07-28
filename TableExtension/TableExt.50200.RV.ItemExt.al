/// <summary>
/// TableExtension RV_ITEM (ID 50200) extends Item table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// FDD020 2026/04
/// FDD006 2026/07/17: Add fields (Stephen)
/// FDD006 2026/07/28: Add fields (Stephen)
/// </summary>
tableextension 50200 "RV ITEM" extends "Item"
{
    fields
    {
        field(50200; "RV_RSPO"; Boolean)
        {
            Caption = 'RSPO';
            Description = 'FDD027';
        }
        field(50201; "RV_Expiration Base Date (RM)"; Option)
        {
            Caption = 'Expiration Base Date (RM)';
            Description = 'FDD001';
            OptionCaption = ' ,Manufacture Date,Posting Date';
            OptionMembers = " ","Manufacture Date","Posting Date";
        }
        field(50202; "RV_ECR Required"; Boolean)
        {
            Caption = 'ECR Required';
            Description = 'FDD006';
        }
        field(50203; "RV_RSPO Type"; Enum "RV RSPO Type")
        {
            Caption = 'RSPO Type';
            Description = 'FDD020';
        }
        field(50204; "RV_Print RSPO No."; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD020';
            InitValue = true;
        }
        field(50205; "RV_Grade"; Text[20])
        {
            Caption = 'Grade';
            Description = 'FDD027';
        }
        field(50401; "Allergen"; Boolean)
        {
            Caption = 'Allergen';
            Description = 'FDD043';
        }
        field(50600; "RV_ECR Ageing Period"; DateFormula)
        {
            Caption = 'ECR Ageing Period';
            Description = 'FDD001';
        }
        field(50601; "RV_Planning Tran. Ship. (Qty)."; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where("Worksheet Template Name" = filter(<> ''),
                                                                          "Journal Batch Name" = filter(<> ''),
                                                                          "Replenishment System" = const(Transfer),
                                                                          Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Transfer-from Code" = field("Location Filter"),
                                                                          "Transfer Shipment Date" = field("Date Filter")));
            Caption = 'RV_Planning Transfer Ship. (Qty).';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
        }
        field(50602; "RV_Qty. on Job Order"; Decimal)
        {
            CalcFormula = sum("Job Planning Line"."Remaining Qty. (Base)" where(Status = const(Order),
                                                                                 Type = const(Item),
                                                                                 "No." = field("No."),
                                                                                 "Location Code" = field("Location Filter"),
                                                                                 "Variant Code" = field("Variant Filter"),
                                                                                 "RV_Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                 "RV_Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                 "Planning Date" = field("Date Filter"),
                                                                                 "Unit of Measure Code" = field("Unit of Measure Filter")));
            Caption = 'RV_Qty. on Project Order';
            ToolTip = 'Specifies how many units of the item are allocated to projects, meaning listed on outstanding project planning lines.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
        }
        field(50603; "RV_PIC"; text[50])
        {
            Caption = 'PIC';
            Description = 'FDDXXX';
        }
    }
    trigger OnBeforeModify()
    begin
        if "RV_RSPO Type" = "RV_RSPO Type"::"Non-RSPO" then begin
            "RV_Print RSPO No." := false;
        end else begin
            "RV_Print RSPO No." := true;
        end;

    end;
}
