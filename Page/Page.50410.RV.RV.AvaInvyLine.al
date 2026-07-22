page 50410 "RV.Available Invy. Lines"
{
    ApplicationArea = All;
    Caption = 'Available Invy. Lines';
    PageType = ListPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    modifyAllowed = false;
    LinksAllowed = true;
    SourceTable = "RV.Available Invy. Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ToolTip = 'Specifies the value of the Item Description 2 field.', Comment = '%';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ToolTip = 'Specifies the value of the Item Type field.', Comment = '%';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Item Category Code field.', Comment = '%';
                }
                field(Allergen; Rec.Allergen)
                {
                    ToolTip = 'Specifies the value of the Allergen field.', Comment = '%';
                }
                field(RSPO; Rec.RSPO)
                {
                    ToolTip = 'Specifies the value of the RSPO field.', Comment = '%';
                }
                field(Segment; Rec.Segment)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }

                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }

                field("Sub Lot No."; Rec."Sub Lot No.")
                {
                    ToolTip = 'Specifies the value of the Sub Lot No. field.', Comment = '%';
                }

                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.', Comment = '%';
                }
                field("Base Unit Invy. Qty."; Rec."Base Unit Invy. Qty.")
                {
                    ToolTip = 'Specifies the value of the Base Unit Invy. Qty. field.', Comment = '%';
                }
                field("KG Unit of Measure"; Rec."KG Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the KG Unit of Measure field.', Comment = '%';
                }
                field("KG Unit Invy. Qty."; Rec."KG Unit Invy. Qty.")
                {
                    ToolTip = 'Specifies the value of the KG Unit Invy. Qty. field.', Comment = '%';
                }
                field("Mfg. Date"; Rec."Mfg. Date")
                {
                    ToolTip = 'Specifies the value of the Mfg. Date field.', Comment = '%';
                }

                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field(Classification; Rec.Classification)
                {
                    ToolTip = 'Specifies the value of the Classification field.', Comment = '%';
                }
                field("Unit Cost 1"; Rec."Unit Cost 1")
                {
                    ToolTip = 'Specifies the value of the Unit Cost 1 field.', Comment = '%';
                }
                field("Cost Amount 1"; Rec."Cost Amount 1")
                {
                    ToolTip = 'Specifies the value of the Cost Amount 1 field.', Comment = '%';
                }
                field("Unit Cost 2"; Rec."Unit Cost 2")
                {
                    ToolTip = 'Specifies the value of the Unit Cost 2 field.', Comment = '%';
                }
                field("Cost Amount 2"; Rec."Cost Amount 2")
                {
                    ToolTip = 'Specifies the value of the Cost Amount 2 field.', Comment = '%';
                }
                field("Unit Cost 3"; Rec."Unit Cost 3")
                {
                    ToolTip = 'Specifies the value of the Unit Cost 3 field.', Comment = '%';
                }
                field("Cost Amount 3"; Rec."Cost Amount 3")
                {
                    ToolTip = 'Specifies the value of the Cost Amount 3 field.', Comment = '%';
                }

                field("Roll Unit Cost"; Rec."Roll Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Roll Unit Cost field.', Comment = '%';
                }
                field("Roll Cost Amount"; Rec."Roll Cost Amount")
                {
                    ToolTip = 'Specifies the value of the Roll Cost Amount field.', Comment = '%';
                }
                field("Derive Unit of Measure"; Rec."Derive Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Derive Unit of Measure field.', Comment = '%';
                }
                field("Direct Dep. Exp."; Rec."Direct Dep. Exp.")
                {
                    ToolTip = 'Specifies the value of the Direct Dep. Exp. field.', Comment = '%';
                }
                field("Direct Dep. Exp. Amt."; Rec."Direct Dep. Exp. Amt.")
                {
                    ToolTip = 'Specifies the value of the Direct Dep. Exp. Amt. field.', Comment = '%';
                }
                field("Direct Fixed Cost"; Rec."Direct Fixed Cost")
                {
                    ToolTip = 'Specifies the value of the Direct Fixed Cost field.', Comment = '%';
                }
                field("Direct Fixed Cost Amt."; Rec."Direct Fixed Cost Amt.")
                {
                    ToolTip = 'Specifies the value of the Direct Fixed Cost Amt. field.', Comment = '%';
                }
                field("Direct Labor Cost"; Rec."Direct Labor Cost")
                {
                    ToolTip = 'Specifies the value of the Direct Labor Cost field.', Comment = '%';
                }
                field("Direct Labor Cost Amt."; Rec."Direct Labor Cost Amt.")
                {
                    ToolTip = 'Specifies the value of the Direct Labor Cost Amt. field.', Comment = '%';
                }
                field("Electricity Fee"; Rec."Electricity Fee")
                {
                    ToolTip = 'Specifies the value of the Electricity Fee field.', Comment = '%';
                }
                field("Electricity Fee Amt."; Rec."Electricity Fee Amt.")
                {
                    ToolTip = 'Specifies the value of the Electricity Fee Amt. field.', Comment = '%';
                }

                field("Raw Material Cost"; Rec."Raw Material Cost")
                {
                    ToolTip = 'Specifies the value of the Raw Material Cost field.', Comment = '%';
                }
                field("Raw Material Cost Amt."; Rec."Raw Material Cost Amt.")
                {
                    ToolTip = 'Specifies the value of the Raw Material Cost Amt. field.', Comment = '%';
                }
                field("Package Material Cost"; Rec."Package Material Cost")
                {
                    ToolTip = 'Specifies the value of the Package Material Cost field.', Comment = '%';
                }
                field("Package Material Cost Amt."; Rec."Package Material Cost Amt.")
                {
                    ToolTip = 'Specifies the value of the Package Material Cost Amt. field.', Comment = '%';
                }
                field("Gas Fee"; Rec."Gas Fee")
                {
                    ToolTip = 'Specifies the value of the Gas Fee field.', Comment = '%';
                }
                field("Gas Fee Amt."; Rec."Gas Fee Amt.")
                {
                    ToolTip = 'Specifies the value of the Gas Fee Amt. field.', Comment = '%';
                }
                field("Indirect Cost"; Rec."Indirect Cost")
                {
                    ToolTip = 'Specifies the value of the Indirect Cost field.', Comment = '%';
                }
                field("Indirect Cost Amt."; Rec."Indirect Cost Amt.")
                {
                    ToolTip = 'Specifies the value of the Indirect Cost Amt. field.', Comment = '%';
                }
                field(Water; Rec.Water)
                {
                    ToolTip = 'Specifies the value of the Water field.', Comment = '%';
                }
                field("Water Amt."; Rec."Water Amt.")
                {
                    ToolTip = 'Specifies the value of the Water Amt. field.', Comment = '%';
                }
            }
        }
    }
}
