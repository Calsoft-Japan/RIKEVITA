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
        dataitem(Item; Item)
        {

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    ItemUOM.Reset();
                    if ItemUOM.Get(Item."No.", 'KG') then begin
                        "RV_Quantity (KG)" := "Item Ledger Entry".Quantity / ItemUOM."Qty. per Unit of Measure";
                        Modify();
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if RVSetup."ILE Last Entry No." <> "Item Ledger Entry"."Entry No." then begin
                        RVSetup."ILE Last Entry No." := "Item Ledger Entry"."Entry No.";
                        RVSetup.Modify();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if RVSetup."ILE Last Entry No." > 0 then
                        SetFilter("Entry No.", StrSubstNo('>%1', RVSetup."ILE Last Entry No."));
                end;
            }

            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    ItemUOM.Reset();
                    if ItemUOM.Get(Item."No.", 'KG') then begin
                        "RV_Item Ledger Entry Qty (KG)" := "Value Entry"."Item Ledger Entry Quantity" / ItemUOM."Qty. per Unit of Measure";
                        "RV_Value Quantity (KG)" := "Value Entry"."Valued Quantity" / ItemUOM."Qty. per Unit of Measure";
                        "RV_Invoiced Quantity (KG)" := "Value Entry"."Invoiced Quantity" / ItemUOM."Qty. per Unit of Measure";
                        Modify();
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if RVSetup."ILE Last Entry No." <> "Value Entry"."Entry No." then begin
                        RVSetup."VE Last Entry No." := "Value Entry"."Entry No.";
                        RVSetup.Modify();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if RVSetup."VE Last Entry No." > 0 then
                        SetFilter("Entry No.", StrSubstNo('>%1', RVSetup."VE Last Entry No."));
                end;
            }


            trigger OnPreDataItem()
            begin
                if RVSetup."Calc. Item No." <> '' then
                    SetFilter("No.", RVSetup."Calc. Item No.");
            end;
        }
    }
    trigger OnInitReport()
    begin
        if not RVSetup.Get() then CurrReport.Break();
    end;

    var
        ItemFilter: Text;
        LastILENo: Integer;
        LastVENo: Integer;
        RVSetup: Record "RV RIKEVITA Setup";
        ItemUOM: Record "Item Unit of Measure";
}
