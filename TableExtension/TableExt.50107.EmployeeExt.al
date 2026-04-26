/// <summary>
/// TableExtension RV Employee Ext (ID 50107) extends "Employee" table
/// FDD017 2026/04/13: New. (Liuyang)
/// </summary>
tableextension 50107 "RV Employee Ext" extends Employee
{
    fields
    {
        field(50000; "RV_Expat Employee"; Boolean)
        {
            Description = 'FDD017';
            Caption = 'Expat Employee';
            trigger OnValidate()
            begin
                if (UpperCase(Rec.Nationality) <> UpperCase('Malaysian')) and (not Rec."RV_Expat Employee") then begin
                    Message('Nationality is NOT Malaysian, Expat Employee must be TRUE.');
                    "RV_Expat Employee" := true;
                end;
            end;
        }
        field(50001; "RV_ID No./Passport No."; Code[30])
        {
            Description = 'FDD017';
            Caption = 'ID No./Passport No.';
        }
        field(50002; "RV_Bank Account Code"; Code[20])
        {
            Description = 'FDD017';
            Caption = 'Bank Account Code';
            TableRelation = "Vendor Bank Account".Code;
        }

        modify(Nationality)
        {
            trigger OnAfterValidate()
            begin
                if UpperCase(Rec.Nationality) <> UpperCase('Malaysia') then begin
                    "RV_Expat Employee" := true;
                end;
            end;
        }
    }
}
