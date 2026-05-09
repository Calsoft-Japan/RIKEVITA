
/// <summary>
/// Page RV Charge Calculations (ID 50901)
/// FDD009 2026/05/01: New. (Shawn)
/// </summary>
page 50901 "RV Charge Calculation"
{
    ApplicationArea = All;
    Caption = 'Charge Calculation';
    PageType = Document;
    SourceTable = "RV Charge Calc. Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    trigger OnAssistEdit()
                    var
                        NoSeries: Codeunit "No. Series";
                        RIKEVITASetup: Record "RV RIKEVITA Setup";
                    begin
                        RIKEVITASetup.Get();
                        RIKEVITASetup.TestField("No. Series for Chg. Calc.");
                        if (Rec."No." = '') then begin
                            if NoSeries.LookupRelatedNoSeries(RIKEVITASetup."No. Series for Chg. Calc.", Rec."No.") then begin
                                Rec."No." := NoSeries.GetNextNo(RIKEVITASetup."No. Series for Chg. Calc.");
                            end;
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    trigger OnValidate()
                    begin

                        IsChargeLinesEditable := Rec.ChargeLinesEditable();
                        CurrPage.Update();
                    end;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                }
                field("Calculated By"; Rec."Calculated By")
                {
                }
                field(Status; Rec.Status)
                {
                    trigger OnValidate()
                    begin

                        IsCarryOutEnable := Rec.CarryOutEnable();
                        CurrPage.Update();
                    end;
                }
            }


            group(Charges)
            {
                Caption = 'Charges';
                field("HTP Adjustment Price"; Rec."HTP Adjustment Price")
                {
                }
                field("01-COO"; Rec."01-COO")
                {
                }
                field("02-FORWARDING"; Rec."02-FORWARDING")
                {
                }
                field("03-FUMIGATION"; Rec."03-FUMIGATION")
                {
                }
                field("04-HEALTH"; Rec."04-HEALTH")
                {
                }
                field("05-PALLETIZING"; Rec."05-PALLETIZING")
                {
                }
                field("06-PHYTO"; Rec."06-PHYTO")
                {
                }
                field("07-STUFFING"; Rec."07-STUFFING")
                {
                }
                field("08-TRANSPORT"; Rec."08-TRANSPORT")
                {
                }
                field("09-REACH"; Rec."09-REACH")
                {
                }
                field("10-Label"; Rec."10-Label")
                {
                }
                field("11-OF"; Rec."11-OF")
                {
                }
                field("99-OTHERS"; Rec."99-OTHERS")
                {
                }
                field(FREIGHT; Rec.FREIGHT)
                {
                }
            }

            group(Total)
            {
                Caption = 'Total';
                Editable = false;
                Enabled = false;
                field("Total Part Cost"; Rec."Total Cost")
                {
                }
                field("Total Part HTP Adjustment Price"; Rec."HTP Adjustment Price")
                {
                }
                field("Total Part FREIGHT"; Rec.FREIGHT)
                {
                }
                field("Total Part Quantity (KG)"; Rec."Total Quantity (KG)")
                {
                }
            }

            part(ChargeLines; "RV Charge Calculation Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Editable = IsChargeLinesEditable;
                Enabled = IsChargeLinesEditable;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {

        area(processing)
        {
            action("Carry Out")
            {
                Caption = 'Carry Out';
                ApplicationArea = All;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = IsCarryOutEnable;

                trigger OnAction()
                var

                    ChargeCalcMgt: Codeunit "RV Charge Calc. Mgt";

                    CarryOutNodataErr: Label 'Calculate charge first before Carry out.';
                    CarryOutQst: Label 'This calculation will be carried out to Sales Orders.';
                    CarryOutOkMsg: Label 'Carry out completed.';
                begin

                    Rec.TestField(Status, Enum::"RV Charge Calc. Status"::WIP);

                    Rec.CalcFields("Total Quantity (KG)");
                    if Rec."Total Quantity (KG)" = 0 then begin
                        Error(CarryOutNodataErr);
                    end;

                    if not Confirm(CarryOutQst) then
                        exit;

                    ChargeCalcMgt.SetDocNo(Rec."No.");
                    ChargeCalcMgt.CarryOutCharge();

                    Message(CarryOutOkMsg);

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if GuiAllowed() then begin
            IsChargeLinesEditable := Rec.ChargeLinesEditable();
            IsCarryOutEnable := Rec.CarryOutEnable();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        if GuiAllowed() then begin
            IsChargeLinesEditable := Rec.ChargeLinesEditable();
            IsCarryOutEnable := Rec.CarryOutEnable();
        end;
    end;

    var
        IsChargeLinesEditable: Boolean;
        IsCarryOutEnable: Boolean;
}
