/// <summary>
/// Page RV Charge Calculation Subform (ID 50902)
/// FDD009 2026/05/01: New. (Shawn)
/// </summary>
page 50902 "RV Charge Calculation Subform"
{
    ApplicationArea = All;
    Caption = 'Charge Calculation Subform';
    PageType = ListPart;
    SourceTable = "RV Charge Calc. Line";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ChargeCalcHeader: Record "RV Charge Calc. Header";
                        SalesLineView: Record "Sales line";
                        SalesLineLookup: Record "Sales line";
                        pagSalesLine: Page "Sales Lines";

                        ChargeTypeBlankErr: Label 'Charge Type is blank!';

                    begin

                        ChargeCalcHeader.Get(Rec."Document No.");

                        if ChargeCalcHeader."Charge Type" = Enum::"RV Charge Type"::" " then
                            Error(ChargeTypeBlankErr);

                        Clear(pagSalesLine);
                        SalesLineView.Reset();
                        SalesLineView.SetRange("Document Type", Enum::"Sales Document Type"::Order);
                        SalesLineView.SetRange(Type, Enum::"Sales Line Type"::Item);
                        SalesLineView.SetRange("RV_Charge Type", ChargeCalcHeader."Charge Type");

                        if Page.RunModal(Page::"Sales Lines", SalesLineView) = Action::LookupOK then begin

                            Rec."Sales Order No." := SalesLineView."Document No.";
                            Rec."Sales Order Line No." := SalesLineView."Line No.";
                        end;

                        CurrPage.Update();
                    end;

                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Sales Quantity"; Rec."Sales Quantity")
                {
                }
                field("Sales Unit of Measure Code"; Rec."Sales Unit of Measure Code")
                {
                }
                field("Quantity (KG)"; Rec."Quantity (KG)")
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
                field("99-OTHERS"; Rec."99-OTHERS")
                {
                }
                field(FREIGHT; Rec.FREIGHT)
                {
                }
                field("Total Charge (KG)"; Rec."Total Charge (KG)")
                {
                }
                field("HTP Adjustment Price"; Rec."HTP Adjustment Price")
                {
                }
                field("Unit Charge (KG)"; Rec."Unit Charge (KG)")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Order Unit Price"; Rec."Order Unit Price")
                {
                }
                field("Order Unit Price (KG)"; Rec."Order Unit Price (KG)")
                {
                }
                field("Invoice Unit Price (KG)"; Rec."Invoice Unit Price (KG)")
                {
                }
                field("Final Charge (KG)"; Rec."Final Charge (KG)")
                {
                }
            }
        }
    }

    actions
    {

        area(processing)
        {
            action("Calculate Charge")
            {
                Caption = 'Calculate Charge';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                var
                    ChargeCalcMgt: Codeunit "RV Charge Calc. Mgt";
                    ChargeCalcOkMsg: Label 'Charge Calculation completed.';
                begin

                    //Message('Under Construction.');
                    ChargeCalcMgt.SetDocNo(Rec."Document No.");
                    ChargeCalcMgt.CalcCharge();

                    CurrPage.Update();

                    Message(ChargeCalcOkMsg);
                end;
            }
        }
    }
}
