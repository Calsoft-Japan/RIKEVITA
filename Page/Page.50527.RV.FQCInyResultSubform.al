/// <summary>
/// PAge RV FQC Iny. Result Subform Subform (ID 50527)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50527 "RV FQC Iny. Result Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Iny. Result Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {

                field("QC No."; Rec."QC No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("QC Type"; Rec."QC Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Inventory Type"; Rec."Inventory Type")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
                field("UOM"; Rec."UOM")
                {
                    ApplicationArea = All;
                }
                field("Classification"; Rec."Classification")
                {
                    ApplicationArea = All;
                }
                field("NC Location Code"; Rec."NC Location Code")
                {
                    ApplicationArea = All;
                }
                field("NC Bin Code"; Rec."NC Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NCHeader: Record "RV NC Header";
    begin
        if NCHeader.Get(Rec."QC No.", Rec."QC Type") then begin
            Rec."NC Location Code" := NCHeader."NC Location Code";
            Rec."UOM" := NCHeader."Unit of Measure";
        end;
    end;

}