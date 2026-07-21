/// <summary>
/// TableExtension RV_ITEM (ID 50200) extends Item table
/// FDD001 2026/03/12: New. (Bobby.ji)
/// FDD020 2026/04
/// FDD006 2026/07/17: Add fields (Stephen)
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
        field(50600; "RV_ECR Ageing Period"; DateFormula)
        {
            Caption = 'ECR Ageing Period';
            Description = 'FDD001';
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
