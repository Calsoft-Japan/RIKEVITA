/// <summary>
/// PageExtension RV_Item Card (ID 50200) extends "Item Card"
/// FDD001 2026/03/12: New. (Bobby.ji)
/// PageExtension RV Item Card (ID 50606) extends "Item Card" Merge from 50606 to 50200, FDD014 2026/02/23: New. (Bobby.ji)
/// FDD014 2026/02/23: New. (Stephen)
/// FDD020 2026/04/08：New.（Bobby.ji）
/// FDD006 2026/07/17: Add fields (Stephen)
/// </summary>
pageextension 50200 "RV Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field(RV_Grade; Rec.RV_Grade)
            {
                Caption = 'Grade';
                ApplicationArea = all;
            }
        }
        addafter("Expiration Calculation")
        {
            field("Expiration Base Date (RM)"; Rec."RV_Expiration Base Date (RM)")
            {
                Caption = 'Expiration Base Date (RM)';
                ApplicationArea = all;
            }
        }
        addafter("Item Category Code")
        {
            field("RV_ECR Required"; Rec."RV_ECR Required")
            {
                ApplicationArea = all;
                description = 'FDD006';
            }
            field("RV_ECR Ageing Period"; Rec."RV_ECR Ageing Period")
            {
                ApplicationArea = all;
                description = 'FDD001';
            }
            field(RV_RSPO; Rec.RV_RSPO)
            {
                Caption = 'RSPO';
                ApplicationArea = all;
            }
            field("RSPO Type"; Rec."RV_RSPO Type")
            {
                Caption = 'RSPO Type';
                ApplicationArea = all;
            }
            field("Print RSPO No."; Rec."RV_Print RSPO No.")
            {
                Caption = 'Print RSPO No.';
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        modify(BOMStructure)
        {
            Description = 'FDD014';
            trigger OnBeforeAction()
            var
                RVBOMCheck: Codeunit "RV Check BOM Access ";
                Item: Record Item;
            begin
                if Rec."Production BOM No." <> '' then
                    RVBOMCheck.CheckBOMAccess(Rec."Production BOM No.")
                else
                    if Item.Get(Rec."No.") then
                        RVBOMCheck.CheckBOMAccess(Item."Production BOM No.");
            end;
        }
    }
}
