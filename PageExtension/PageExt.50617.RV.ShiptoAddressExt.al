/// <summary>
/// PageExtension RV Ship-to Address (ID 50617) extends "Ship-to Address"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50617 "RV_Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("RV_Shipment Type"; Rec."RV_Shipment Type")
            {
                ApplicationArea = All;
            }
            field("RV_Bypass ECR"; Rec."RV_Bypass ECR")
            {
                ApplicationArea = All;
            }
            field("RV_Sailing Category"; Rec."RV_Sailing Category")
            {
                ApplicationArea = All;
            }
            field("RV_Sailing Period"; Rec."RV_Sailing Period")
            {
                ApplicationArea = All;
            }
        }
    }
}
