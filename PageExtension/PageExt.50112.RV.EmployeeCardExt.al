/// <summary>
/// pageextension Employee Card Ext (ID 50112) extends "Employee Card" page
/// FDD017 2026/04/14: New. (Liuyang)
/// </summary>
pageextension 50112 "RV Employee Card Ext" extends "Employee Card"
{
    layout
    {
        addafter("Manager Role")
        {
            field("RV_Expat Employee"; Rec."RV_Expat Employee")
            {
                Description = 'FDD017';
                ApplicationArea = All;
            }
        }

        addafter("Social Security No.")
        {
            field("RV_ID No./Passport No."; Rec."RV_ID No./Passport No.")
            {
                Description = 'FDD017';
                ApplicationArea = All;
                Importance = Promoted;
                MaskType = Concealed;
            }

            field("RV_Biller Code"; Rec."RV_Biller Code")
            {
                Description = 'FDD017';
                ApplicationArea = All;
                Importance = Promoted;
            }
        }

        addbefore("Bank Account No.")
        {
            field("RV_Bank Account Code"; Rec."RV_Bank Account Code")
            {
                Description = 'FDD017';
                ApplicationArea = All;
            }
        }
    }
}
