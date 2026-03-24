/// <summary>
/// Page RV_HS Code Management (ID 50101).
/// FDD030 2026/03/09: New. (Liuyang)
/// </summary>
page 50101 "RV_HS Code Management"
{
    ApplicationArea = All;
    Caption = 'HS Code Management';
    PageType = List;
    SourceTable = "RV_HS Code Management";
    UsageCategory = Lists;
    DeleteAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(Description2; Rec.Description2)
                {
                    ToolTip = 'Specifies the value of the Description2 field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Prev. HS Code"; Rec."Prev. HS Code")
                {
                    ToolTip = 'Specifies the value of the Prev. HS Code field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Latest HS Code"; Rec."Latest HS Code")
                {
                    ToolTip = 'Specifies the value of the Latest HS Code field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("State Custom Ref"; Rec."State Custom Ref")
                {
                    ToolTip = 'Specifies the value of the State Custom Ref field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("HQ Custom Ref"; Rec."HQ Custom Ref")
                {
                    ToolTip = 'Specifies the value of the HQ Custom Ref field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("HQ Code Expiry Date"; Rec."HQ Code Expiry Date")
                {
                    ToolTip = 'Specifies the value of the HQ Code Expiry Date field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SeqNo; Rec.SeqNo)
                {
                    ToolTip = 'Specifies the value of the SeqNo field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("FTA Schema"; Rec."FTA Schema")
                {
                    ToolTip = 'Specifies the value of the FTA Schema field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Application ID"; Rec."Application ID")
                {
                    ToolTip = 'Specifies the value of the Application ID field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ToolTip = 'Specifies the value of the Approval Date field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Expired App ID"; Rec."Expired App ID")
                {
                    ToolTip = 'Specifies the value of the Expired App ID field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Expired Date"; Rec."Expired Date")
                {
                    ToolTip = 'Specifies the value of the Expired Date field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Origin Criteria"; Rec."Origin Criteria")
                {
                    ToolTip = 'Specifies the value of the Origin Criteria field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Origin Criterial %"; Rec."Origin Criterial %")
                {
                    ToolTip = 'Specifies the value of the Origin Criterial % field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(Link; Rec.Link)
                {
                    ToolTip = 'Specifies the value of the Link field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Entry No." := Rec.GetNextEntryNo();
    end;

    trigger OnAfterGetRecord()
    var
        RVSteup: Record "RIKEVITA Setup";
    begin
        StyleExpr := 'Standard';
        RVSteup.Reset();
        RVSteup.FindFirst();
        if Rec."Expired Date" <= CalcDate(RVSteup."Notification Calculation", Today()) then
            StyleExpr := 'Unfavorable';
    end;

    var
        StyleExpr: Text[100];
}
