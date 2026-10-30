/// <summary>
/// Table RV QA Shipment Lot No.(ID 50509)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50509 "RV QA Shipment Lot No."
{
    Caption = 'QA Shipment Lot No.';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "COA No."; Code[20])
        {
            Caption = 'COA No.';
            TableRelation = "RV QA Header";
            NotBlank = true;
        }
        field(2; "COA Lot Line No."; Integer)
        {
            Caption = 'COA Lot Line No.';
        }
        field(3; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(4; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }

        field(5; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = "Unit of Measure";
        }
        field(6; "Container No."; Text[100])
        {
            Caption = 'Container No.';
        }
        field(7; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(8; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }

        field(9; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(10; "QA Status"; Enum "RV QA Status")
        {
            Caption = 'QA Status';
        }
        field(16; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Qty. per UOM"; Decimal)
        {
            Caption = 'Qty. per UOM';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Comment"; Text[80])
        {
            Caption = 'Comment';
        }
        field(19; "Container Quantity"; Decimal)
        {
            Caption = 'Container Quantity';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("RV QA Shipment Lot No.".Quantity where("COA No." = field("COA No."), "Container No." = field("Container No.")));
            Editable = false;
        }
        field(20; "Container Qty. (Base)"; Decimal)
        {
            Caption = 'Container Qty. (Base)';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("RV QA Shipment Lot No."."Qty. (Base)" where("COA No." = field("COA No."), "Container No." = field("Container No.")));
            Editable = false;
        }
        field(21; "Expire Date for COA Report"; Date)
        {
            Caption = 'Expire Date for COA Report';
        }
    }
    keys
    {
        key(PK; "COA No.", "COA Lot Line No.")
        {
            Clustered = true;
        }
        key(key2; "COA No.", "Container No.", "Lot No.")
        {
        }
    }

    var

    trigger OnInsert()
    var
        QAHeader: Record "RV QA Header";
    begin
        if QAHeader.Get("COA No.") then
            "QA Status" := QAHeader."QA Status";
    end;

    procedure SetQAEnable(var UpdateQALineEnable: Boolean; var QACheckEnable: Boolean;
                        var QAApproveEnable: Boolean; var QARejectEnable: Boolean; var QAReverseEnable: Boolean;
                        var SubCOACardEditable: Boolean;
                        var SubExterQCResultEditable: Boolean;
                         var SubInyResultEditable: Boolean)
    var
        QAHeader: Record "RV QA Header";
    begin

        if QAHeader.Get("COA No.") then;
        CASE QAHeader."QA Status" OF
            (QAHeader."QA Status"::Analyzing):
                begin
                    UpdateQALineEnable := true;
                    QACheckEnable := true;
                    QAApproveEnable := false;
                    QARejectEnable := false;
                    QAReverseEnable := false;


                    SubCOACardEditable := true;

                    SubExterQCResultEditable := true;
                    SubInyResultEditable := true;
                end;
            (QAHeader."QA Status"::Checked):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := true;
                    QARejectEnable := true;
                    QAReverseEnable := false;

                    SubCOACardEditable := true;

                    SubExterQCResultEditable := true;
                    SubInyResultEditable := true;
                end;
            (QAHeader."QA Status"::Approved):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;
                    QAReverseEnable := true;

                    SubCOACardEditable := false;

                    SubExterQCResultEditable := false;
                    SubInyResultEditable := false;
                end;
            (QAHeader."QA Status"::Rejected):
                begin
                    UpdateQALineEnable := false;
                    QACheckEnable := false;
                    QAApproveEnable := false;
                    QARejectEnable := false;
                    QAReverseEnable := true;

                    SubCOACardEditable := false;

                    SubExterQCResultEditable := false;
                    SubInyResultEditable := false;
                end;
        END;

    end;
}