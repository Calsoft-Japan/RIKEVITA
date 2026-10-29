/// <summary>
/// PageExtension General Ledger Entries (ID 50219) extends "General Ledger Entries"
/// On-demand request: Add "Source Name" field (Variable) by Bobby 10/29/2026
/// </summary>
pageextension 50219 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addafter("Source Type")
        {
            field(SourceName; SourceName)
            {
                ApplicationArea = All;
                Caption = 'Source Name';
                Editable = false;
            }
        }
    }
    var
        SourceName: Text[100];

    trigger OnAfterGetRecord()
    begin
        SourceName := GetSourceName();
    end;

    local procedure GetSourceName(): Text[100]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
    begin
        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if Customer.Get(Rec."Source No.") then
                    exit(Customer.Name);
            Rec."Source Type"::Vendor:
                if Vendor.Get(Rec."Source No.") then
                    exit(Vendor.Name);
            Rec."Source Type"::"Bank Account":
                if BankAccount.Get(Rec."Source No.") then
                    exit(BankAccount.Name);
            Rec."Source Type"::"Fixed Asset":
                if FixedAsset.Get(Rec."Source No.") then
                    exit(FixedAsset.Description);
            Rec."Source Type"::Employee:
                if Employee.Get(Rec."Source No.") then
                    exit(Employee.FullName());
        end;
        exit('');
    end;
}

