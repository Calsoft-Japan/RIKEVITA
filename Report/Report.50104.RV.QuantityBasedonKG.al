/// <summary>
/// Report RIKE Quantity Based on KG JobQueue (ID 50104).
/// FDD100 2026/05/05: New. (Liuyang)
/// </summary>
report 50104 "RV Quantity on KG JobQueue"
{
    ApplicationArea = All;
    Caption = 'RV Quantity Based on KG';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions =
        tabledata "Item Ledger Entry" = rm,
        tabledata "Value Entry" = rm;

    dataset
    {
        //dataitem(Item; Item)
        //{

        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            //DataItemLink = "Item No." = field("No.");
            DataItemTableView = sorting("Entry No.");

            trigger OnAfterGetRecord()
            begin
                ItemUOM.Reset();
                if ItemUOM.Get("Item No.", "Item Ledger Entry"."RV_Supp. Unit of Measure Code") then begin//'KG'
                    "RV_Quantity (Supp. UOM)" := "Item Ledger Entry".Quantity * ItemUOM."Qty. per Unit of Measure";
                    Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
                if RVSetup."Calc. Item No." <> '' then
                    SetFilter("Item No.", RVSetup."Calc. Item No.");

                if RVSetup."ILE Last Entry No." > 0 then
                    SetFilter("Entry No.", StrSubstNo('>%1', RVSetup."ILE Last Entry No."));
            end;

            trigger OnPostDataItem()
            begin
                if LastILENo < "Item Ledger Entry"."Entry No." then begin
                    LastILENo := "Item Ledger Entry"."Entry No.";
                end;
            end;
        }

        dataitem("Value Entry"; "Value Entry")
        {
            //DataItemLink = "Item No." = field("No.");
            DataItemTableView = sorting("Entry No.");

            trigger OnAfterGetRecord()
            begin
                ItemUOM.Reset();
                if ItemUOM.Get("Item No.", "Value Entry"."RV_Supp. Unit of Measure Code") then begin//'KG'
                    "RV_IL Entry Qty (Supp. UOM)" := "Value Entry"."Item Ledger Entry Quantity" * ItemUOM."Qty. per Unit of Measure";
                    "RV_Value Quantity (Supp. UOM)" := "Value Entry"."Valued Quantity" * ItemUOM."Qty. per Unit of Measure";
                    "RV_Invoiced Qty (Supp. UOM)" := "Value Entry"."Invoiced Quantity" * ItemUOM."Qty. per Unit of Measure";
                    Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
                if RVSetup."Calc. Item No." <> '' then
                    SetFilter("Item No.", RVSetup."Calc. Item No.");

                if RVSetup."VE Last Entry No." > 0 then
                    SetFilter("Entry No.", StrSubstNo('>%1', RVSetup."VE Last Entry No."));
            end;

            trigger OnPostDataItem()
            begin
                if LastVENo < "Value Entry"."Entry No." then begin
                    LastVENo := "Value Entry"."Entry No.";
                end;
            end;
        }


        /* trigger OnPreDataItem()
        begin
            if RVSetup."Calc. Item No." <> '' then
                SetFilter("No.", RVSetup."Calc. Item No.");
        end; */

        //}
    }
    trigger OnInitReport()
    begin
        if not RVSetup.Get() then CurrReport.Break();

        LastILENo := RVSetup."ILE Last Entry No.";
        LastVENo := RVSetup."VE Last Entry No.";
    end;

    trigger OnPostReport()
    begin
        if RVSetup."ILE Last Entry No." <> LastILENo then begin
            RVSetup."ILE Last Entry No." := LastILENo;
            RVSetup.Modify();
        end;

        if RVSetup."VE Last Entry No." <> LastVENo then begin
            RVSetup."VE Last Entry No." := LastVENo;
            RVSetup.Modify();
        end;
    end;

    var
        ItemFilter: Text;
        LastILENo: Integer;
        LastVENo: Integer;
        RVSetup: Record "RV RIKEVITA Setup";
        ItemUOM: Record "Item Unit of Measure";
}
