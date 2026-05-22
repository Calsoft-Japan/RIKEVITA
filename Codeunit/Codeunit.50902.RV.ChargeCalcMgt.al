/// <summary>
/// Codeunit RV ILE Item Trace Mgt (ID 50902)
/// FDD028 2026/05/22: New. (Shawn)
/// </summary>
codeunit 50902 "RV ILE Item Trace Mgt"
{
    Permissions = tabledata "Item Ledger Entry" = rm;
    trigger OnRun()
    begin
        RVSetup.Get();
        UpdateVendor();
    end;

    var
        RVSetup: Record "RV RIKEVITA Setup";
        ILE: Record "Item Ledger Entry";
        ILEFinder: Record "Item Ledger Entry";

    procedure UpdateVendor()
    begin

        //Step1: Update Source Type is Vendor.
        //OB Data will be set to Item Journal Line directly.
        ILE.Reset();
        ILE.SetFilter("Entry No.", '>%1', RVSetup."ILE Last Entry No (Item Trace)");
        ILE.SetRange("Source Type", Enum::"Analysis Source Type"::Vendor);
        if ILE.FindSet() then
            repeat
                ILE."RV_Vendor No." := ILE."Source No.";
                ILE.Modify();
            until ILE.Next() = 0;

        //Step2: Update other Source Types by same Lot No. ILE.
        ILE.Reset();
        ILE.SetFilter("Entry No.", '>%1', RVSetup."ILE Last Entry No (Item Trace)");
        ILE.SetFilter("Source Type", '<>%1', Enum::"Analysis Source Type"::Vendor);
        if ILE.FindSet() then
            repeat
                ILEFinder.Reset();
                ILEFinder.SetRange("Item No.", ILE."Item No.");
                ILEFinder.SetRange("Lot No.", ILE."Lot No.");
                ILEFinder.SetFilter("RV_Vendor No.", '<>%1', '');
                ILEFinder.Ascending(false);
                if ILEFinder.FindFirst() then begin
                    ILE."RV_Vendor No." := ILEFinder."RV_Vendor No.";
                    ILE.Modify();
                end;
            until ILE.Next() = 0;

        //Step3: For ILE with empty Vendor No,, retrieve same documnt no. ILEs.
        ILE.Reset();
        ILE.SetFilter("Entry No.", '>%1', RVSetup."ILE Last Entry No (Item Trace)");
        ILE.SetFilter("Source Type", '<>%1', Enum::"Analysis Source Type"::Vendor);
        ILE.SetFilter("RV_Vendor No.", '<>%1', '');
        if ILE.FindSet() then
            repeat
                ILEFinder.Reset();
                ILEFinder.SetRange("Item No.", ILE."Item No.");
                ILEFinder.SetRange("Document No.", ILE."Document No.");
                ILEFinder.SetFilter("RV_Vendor No.", '<>%1', '');
                ILEFinder.Ascending(false);
                if ILEFinder.FindFirst() then begin
                    ILE."RV_Vendor No." := ILEFinder."RV_Vendor No.";
                    ILE.Modify();
                end;
            until ILE.Next() = 0;

    end;

}
