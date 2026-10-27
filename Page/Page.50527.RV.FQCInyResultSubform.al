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
                    trigger OnValidate()
                    var
                        NCHeader: Record "RV NC Header";
                        RIKEVITASetup: Record "RV RIKEVITA Setup";
                    begin
                        if NCHeader.Get(Rec."QC No.", Rec."QC Type") then begin
                            RIKEVITASetup.Get();
                            Rec."UOM" := NCHeader."Unit of Measure";
                            case rec."Inventory Type" of
                                rec."Inventory Type"::BLCK,
                                rec."Inventory Type"::DISP,
                                rec."Inventory Type"::DMGE:
                                    begin
                                        Rec."Transfer-to Location" := NCHeader."NC Location Code";
                                        Rec."Transfer-to Bin" := RIKEVITASetup."NC Bin Code";
                                    end;
                                rec."Inventory Type"::STCK:
                                    begin
                                        Rec."Transfer-to Location" := NCHeader."Location Code";
                                        Rec."Transfer-to Bin" := NCHeader."Storage Bin Code";
                                    end;
                            end;
                        end;
                    end;
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
                field("NC Location Code"; Rec."Transfer-to Location")
                {
                    ApplicationArea = All;
                }
                field("NC Bin Code"; Rec."Transfer-to Bin")
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
        RIKEVITASetup: Record "RV RIKEVITA Setup";
    begin
        if NCHeader.Get(Rec."QC No.", Rec."QC Type") then begin
            RIKEVITASetup.Get();
            Rec."UOM" := NCHeader."Unit of Measure";
            case rec."Inventory Type" of
                rec."Inventory Type"::BLCK,
                rec."Inventory Type"::DISP,
                rec."Inventory Type"::DMGE:
                    begin
                        Rec."Transfer-to Location" := NCHeader."NC Location Code";
                        Rec."Transfer-to Bin" := RIKEVITASetup."NC Bin Code";
                    end;
                rec."Inventory Type"::STCK:
                    begin
                        Rec."Transfer-to Location" := NCHeader."Location Code";
                        Rec."Transfer-to Bin" := NCHeader."Storage Bin Code";
                    end;
            end;
        end;
    end;

}