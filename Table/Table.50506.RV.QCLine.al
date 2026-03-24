/// <summary>
/// Table RV QC Line (ID 50506)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
table 50506 "RV QC Line"
{
    Caption = 'QC Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "QC No."; Code[20])
        {
            Caption = 'QC No.';
            TableRelation = "RV QC Header"."QC No." where("QC Type" = field("QC Type"));
            NotBlank = true;
        }
        field(2; "QC Type"; Enum "RV QC Type")
        {
            Caption = 'QC Type';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "QC Parameter Name"; Code[20])
        {
            Caption = 'QC Parameter Name';
            TableRelation = "RV QC Parameter";
        }
        field(5; "QC Result"; Code[10])
        {
            Caption = 'QC Result';
        }
        field(6; "Check Status"; Enum "RV Check Status")
        {
            Caption = 'Check Status';
        }
        field(10; "Value Table Type"; Enum "RV Value Table Type")
        {
            Caption = 'Value Table Type';
        }
    }
    keys
    {
        key(PK; "QC No.", "QC Type", "Line No.")
        {
            Clustered = true;
        }
    }

    var
}