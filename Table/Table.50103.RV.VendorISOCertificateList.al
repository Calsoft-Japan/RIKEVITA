/// <summary>
/// Table RV_Vendor ISO Certificate List (ID 50103).
/// FDD013 2026/03/19: New (Liuyang)
/// </summary>
table 50103 "RV Vendor ISO Certificate Line"
{
    Caption = 'RV Vendor ISO Certificate List';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Vendor No.", "Vendor Name";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                Vend.Get("Vendor No.");
                "Vendor Name" := Vend.Name;

                ValidateCombination();
            end;
        }
        field(2; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(3; "ISO Certificate"; Code[20])
        {
            Caption = 'ISO Certificate';
            NotBlank = true;
            TableRelation = "RV ISO Certificate Code".Code;

            trigger OnValidate()
            begin
                ValidateCombination();
            end;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,"In-Active",Expired;
            InitValue = Active;
            NotBlank = true;

            trigger OnValidate()
            begin
                ValidateCombination();
            end;
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                ValidateCombination();
            end;
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(7; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(8; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(9; "Attach. Doc. No."; Code[20])
        {
            Caption = 'Attachment Document No.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = false;
            InitValue = '';
            TableRelation = Item."No.";
        }
    }

    keys
    {
        key(PK; "Attach. Doc. No.")
        {
            Clustered = true;
        }
        key(Key1; "Vendor No.", "ISO Certificate", Status, "Start Date")
        {
            Unique = true;
        }
        key(Key2; "Entry No.")
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    var
        IsoCertRec: Record "RV Vendor ISO Certificate Line";
        LastEntryNo: Integer;
    begin
        /* if (Rec."Vendor No." = '') or (Rec."ISO Certificate" = '') or (Rec."Start Date" = 0D) then begin
            Error('[Vendor No.],[ISO Certificat],[Start Date] must all have value.');
        end; */

        ValidateCombination();

        if "Attach. Doc. No." = '' then begin
            LastEntryNo := 0;
            IsoCertRec.Reset();
            IsoCertRec.SetCurrentKey("Entry No.");
            IsoCertRec.SetAscending("Entry No.", true);
            if IsoCertRec.FindLast() then begin
                LastEntryNo := IsoCertRec."Entry No." + 1;
            end else
                LastEntryNo := 1;

            Rec."Entry No." := LastEntryNo;

            if Rec."Attach. Doc. No." = '' then begin
                Rec."Attach. Doc. No." := CopyStr(Format(Rec."Entry No."), 1, MaxStrLen(Rec."Attach. Doc. No."));
            end;
        end;
    end;

    trigger OnModify()
    begin
        /* if (Rec."Vendor No." = '') or (Rec."ISO Certificate" = '') or (Rec."Start Date" = 0D) then begin
            Error('[Vendor No.],[ISO Certificat],[Start Date] must have value.');
        end; 

        if (Rec."Vendor No." <> xRec."Vendor No.") or (Rec."ISO Certificate" <> xRec."ISO Certificate") or
            (Rec.Status <> xRec.Status) or (Rec."Start Date" <> xRec."Start Date") then
            ValidateCombination();*/
    end;

    procedure ValidateCombination()
    var
        IsoCertRec: Record "RV Vendor ISO Certificate Line";
    begin
        if (Rec."Vendor No." <> '') and (Rec."ISO Certificate" <> '') and (Rec."Start Date" <> 0D) then begin
            IsoCertRec.Reset();
            IsoCertRec.SetRange("Vendor No.", "Vendor No.");
            IsoCertRec.SetRange("ISO Certificate", "ISO Certificate");
            //IsoCertRec.SetRange(Status, Status);
            IsoCertRec.SetRange("Start Date", "Start Date");
            IsoCertRec.SetRange("End Date", "End Date");
            IsoCertRec.SetRange("Item No.", Rec."Item No.");
            if not IsoCertRec.IsEmpty() then
                Error('There are duplicate record for combination %1, %2, %3, %4, %5', "Vendor No.", Format("ISO Certificate"), "Item No.", "Start Date", "End Date");//, Format(Status)
        end;
    end;


    /// <summary>
    /// Optional migration procedure.
    /// Call once from an install/upgrade codeunit to backfill "Attach. Doc. No."
    /// for any existing rows that predate this table extension.
    /// </summary>
    procedure MigrateAttachDocNo()
    var
        IsoCertRec: Record "RV Vendor ISO Certificate Line";
    begin
        IsoCertRec.SetRange("Attach. Doc. No.", '');
        if IsoCertRec.FindSet(true) then
            repeat
                IsoCertRec."Attach. Doc. No." :=
                    CopyStr(Format(IsoCertRec."Entry No."), 1, MaxStrLen(IsoCertRec."Attach. Doc. No."));
                IsoCertRec.Modify(false);
            until IsoCertRec.Next() = 0;
    end;
}
