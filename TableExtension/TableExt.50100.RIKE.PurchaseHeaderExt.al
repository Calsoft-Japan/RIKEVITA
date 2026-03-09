/// <summary>
/// TableExtension RIKE Purchase Header Ext (ID 50100) extends "Purchase Header" table
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
tableextension 50100 "RIKE Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50100; RV_ETA; Date)
        {
            Caption = 'ETA';
            Description = 'FDD003';
        }
        field(50101; RV_ETD; Date)
        {
            Caption = 'ETD';
            Description = 'FDD003';
        }
        field(50102; "RV_Contract Month"; Enum "RV_Month")
        {
            Caption = 'Contract Month';
            Description = 'FDD003';

            trigger OnValidate()
            begin
                checkRVContractDate();
            end;
        }
        field(50103; "RV_Contract Year"; Integer)
        {
            Caption = 'Contract Year';
            Description = 'FDD003';

            trigger OnValidate()
            begin
                checkRVContractDate();
            end;
        }
    }

    /// <summary>
    /// FDD003 2026/03/08: New. (Liuyang)
    /// check if the Combined dates of Contract Month and Contract Year is correct. will be use in the OnValidate trigger of both "RV_Contract Month" and "RV_Contract Year" fields to make sure the data is correct when user input or update the data.
    /// </summary>
    procedure checkRVContractDate()
    begin
        if ("RV_Contract Month" = "RV_Month"::" ") then
            Error('Contract Month cannot be empty. Please correct the date.');
        if ("RV_Contract Year" < Today.Year) then
            Error('Contract Year cannot be less than current year. Please correct the date.');

        if ("RV_Contract Month" <> "RV_Month"::" ") and ("RV_Contract Year" <> 0) then begin
            if DMY2Date(1, "RV_Contract Month".AsInteger(), "RV_Contract Year") < DMY2Date(1, Today.Month, Today.Year) then
                Error('Combined dates of Contract Month and Contract Year is in the past dates. Please correct the dates.');
        end;
    end;
}
