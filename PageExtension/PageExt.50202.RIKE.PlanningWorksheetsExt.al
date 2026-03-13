/// <summary>
/// PageExtension Rv_Planning Worksheet (ID 50202) extends "Planning Worksheet"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
pageextension 50202 "RV_Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        addafter("Description")
        {
            field("Expiration Calculation"; Rec."RV_Expiration Calculation")
            {
                Caption = 'Expiration Calculation';
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."No." <> '' then begin
                        if Item.Get(Rec."No.") then
                            Rec."RV_Expiration Calculation" := Item."Expiration Calculation";

                    end;
                end;
            }
        }
    }
}
