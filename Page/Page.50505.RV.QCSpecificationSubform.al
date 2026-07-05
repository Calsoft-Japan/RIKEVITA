/// <summary>
/// PAge RV QC Specification Subform (ID 50505)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50505 "RV QC Specification Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "RV QC Specification Line";

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("QC Specification Name"; Rec."QC Specification Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    Visible = false;
                    Editable = false;
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Value Table Name"; Rec."Value Table Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Value Table Type"; Rec."Value Table Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SpecificationValueSetting)
            {
                ApplicationArea = All;
                Caption = 'Specification Value Setting';
                Image = JobLines;
                trigger OnAction()
                var
                    SpecValueSetting: Record "RV Specification Value Setting";
                    SpecValueSettingPage: Page "RV Specification Value Setting";
                begin
                    Rec.TestField("QC Parameter Name");
                    Rec.TestField("Value Table Name");
                    // Check if the value is NOT one of the allowed values
                    if not (Rec."Value Table Type" in [Rec."Value Table Type"::List,
                                            Rec."Value Table Type"::Single,
                                            Rec."Value Table Type"::Table]) then
                        Error('The selected "Value Table Type" : Range is not allowed. Only List, Single, or Table are permitted.');

                    if Rec."Value Table Type" <> Rec."Value Table Type"::Range then begin
                        SpecValueSetting.SetRange("QC Specification Name", Rec."QC Specification Name");
                        SpecValueSetting.SetRange("QC Parameter Name", Rec."QC Parameter Name");
                        SpecValueSetting.SetRange("Value Table Name", Rec."Value Table Name");
                        SpecValueSetting.SetRange("Value Table Type", Rec."Value Table Type");
                        SpecValueSettingPage.SetTableView(SpecValueSetting);
                        SpecValueSettingPage.Run();
                    end;
                end;
            }
        }
    }
}