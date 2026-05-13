/// <summary>
/// PageExtension RV Sales Invoice (ID 50211) extends "Sales Invoice"
/// FDD021 2026/05/11: New. (Bobby.ji)
/// </summary>
pageextension 50211 "RV Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(Control34)//FDD021
        {
            group(FDD021)
            {
                ShowCaption = false;
                field("Country of Origin"; Rec."RV_Country of Origin")
                {
                    Caption = 'Country of Origin';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field("Feeder Vessel"; Rec."RV_Feeder Vessel")
                {
                    Caption = 'Feeder Vessel';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field(VIA; Rec."RV_VIA")
                {
                    Caption = 'VIA';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field("Mother Vessel"; Rec."RV_Mother Vessel")
                {
                    Caption = 'Mother Vessel';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field(Destination; Rec."RV_Destination")
                {
                    Caption = 'Destination';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field(ETD; Rec."RV_ETD")
                {
                    Caption = 'ETD';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }
                field(ETA; Rec."RV_ETA")
                {
                    Caption = 'ETA';
                    ApplicationArea = All;
                    Description = 'FDD021';
                }

            }
        }
    }

}
