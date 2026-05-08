/// <summary>
/// Table RV Sales ECR Status Info. (ID 50607).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50607 "RV Sales ECR Status Info."
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(4; "SO Line No."; Integer)
        {
            Caption = 'SO Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Prod. Order No."; Text[250])
        {
            Caption = 'Prod. Order No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(8; "Shipment Method"; Code[10])
        {
            Caption = 'Shipment Method';
            DataClassification = ToBeClassified;
        }
        field(9; "Ship-to Country"; Code[20])
        {
            Caption = 'Ship-to Country';
            DataClassification = ToBeClassified;
        }
        field(10; "Sailing Category"; Code[20])
        {
            Caption = 'Sailing Category';
            DataClassification = ToBeClassified;
            TableRelation = "RV Sailing Category".Code;
        }
        field(11; "ECR Required"; Boolean)
        {
            Caption = 'ECR Required';
            DataClassification = ToBeClassified;
        }
        field(12; "Bypass ECR"; Boolean)
        {
            Caption = 'Bypass ECR';
            DataClassification = ToBeClassified;
        }
        field(13; "Prod. Due Date"; Date)
        {
            Caption = 'Prod. Due Date';
            DataClassification = ToBeClassified;
        }
        field(14; "Reservation Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Reservation Quantity';
            DataClassification = ToBeClassified;
        }
        field(15; "Order Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Order Quantity';
            DataClassification = ToBeClassified;
        }
        field(16; "Original ECR Date"; Date)
        {
            Caption = 'Original ECR Date';
            DataClassification = ToBeClassified;
        }
        field(17; "Latest ECR Date"; Date)
        {
            Caption = 'Latest ECR Date';
            DataClassification = ToBeClassified;
        }
        field(18; Delayed; Boolean)
        {
            Caption = 'Delayed';
            DataClassification = ToBeClassified;
        }
        field(19; "ECR Status"; Enum "RV ECR Status")
        {
            Caption = 'ECR Status';
            DataClassification = ToBeClassified;
        }
        field(20; "ECR Change Remark Code"; Code[10])
        {
            Caption = 'ECR Change Remark Code';
            DataClassification = ToBeClassified;
            TableRelation = "RV Standard Remark".Code where("Remark Type" = const(ECR));

            trigger OnValidate()
            var
                StandardRemark: Record "RV Standard Remark";
            begin
                if Rec."ECR Change Remark Code" = '' then
                    Rec."ECR Change Remark" := ''
                else
                    if Rec."ECR Change Remark Code" <> xRec."ECR Change Remark Code" then begin
                        StandardRemark.Get(Rec."ECR Change Remark Code", StandardRemark."Remark Type"::ECR);
                        Rec."ECR Change Remark" := StandardRemark.Remark
                    end;
            end;
        }
        field(21; "ECR Change Remark"; Text[150])
        {
            Caption = 'ECR Change Remark';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Sales Order No.", "SO Line No.")
        {
            Clustered = true;
        }
    }
}
