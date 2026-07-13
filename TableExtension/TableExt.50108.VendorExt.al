/// <summary>
/// TableExtension Vendor Ext (ID 50108) extends "Vendor" table
/// FDD017 2026/04/13: New. (Liuyang)
/// </summary>
tableextension 50108 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50001; "RV_ID No./Passport No."; Code[30])
        {
            Description = 'FDD017';
            Caption = 'ID No./Passport No.';
            InitValue = '';

            trigger OnValidate()
            begin
                if Rec."Partner Type" <> Rec."Partner Type"::Person then begin
                    Error('Can not edit [ID No./Passport No.] while Partner Type is Person.');
                end;
            end;
        }
        field(50002; "RV_Biller Code"; Text[100])//Biller Code is an External Code used in Malaysian government system
        {
            Description = 'FDD017';
            Caption = 'Biller Code';
        }
    }
}
