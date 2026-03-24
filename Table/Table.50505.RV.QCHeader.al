/// <summary>
/// Table RV QC Header (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50505 "RV QC Header"
{
    Caption = 'QC Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC No."; Code[20])
        {
            Caption = 'QC No.';
        }
        field(2; "QC Type"; Enum "RV QC Type")
        {
            Caption = 'QC Type';
        }

        field(3; "Ref. Order Type"; Enum "RV Ref. Order Type")
        {
            Caption = 'Ref. Order Type';
        }

        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            ValidateTableRelation = false;
            TableRelation =
            //if ("Ref. Order Type" = const(" ")) "Standard Text"
            //else
            if ("Ref. Order Type" = const("Purchase Order")) "Purchase Header"
            else
            if ("Ref. Order Type" = const("Posted Purchase Receipt")) "Purch. Rcpt. Header"
            else
            if ("Ref. Order Type" = const("Production Order")) "Production Order" where("Status" = const(Released));
        }

        field(5; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(7; "QC Date"; Date)
        {
            Caption = 'QC Date';
        }
        field(8; "QC Standard Type"; Enum "RV QC Standard Type")
        {
            Caption = 'QC Standard Type';
        }

        field(9; "QC Status"; Enum "RV QC Status")
        {
            Caption = 'QC Status';
        }
        field(10; "QC Checked By"; Text[50])
        {
            Caption = 'QC Checked By';
        }
        field(11; "QC Approved By"; Text[50])
        {
            Caption = 'QC Approved By';
        }
        field(12; "QC Check Remark"; Text[150])
        {
            Caption = 'QC Check Remark';
        }
        field(13; "QC Approved Remark"; Text[150])
        {
            Caption = 'QC Approved Remark';
        }
        field(14; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(15; "Tan No."; Code[10])
        {
            Caption = 'Tan No.';
            TableRelation = Location;
        }
    }
    keys
    {
        key(PK; "QC No.", "QC Type")
        {
            Clustered = true;
        }
    }

    /*
    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        RIKEVITASetup: Record "RIKEVITA Setup";
    begin

        if "QC No." = '' then begin
            RVVITASetup.Get();
            RVVITASetup.TestField("QC No. Nos.");
            "QC No." := NoSeriesMgt.GetNextNo(RVVITASetup."QC No. Nos.");
        end;
    end;
    */

    var
}