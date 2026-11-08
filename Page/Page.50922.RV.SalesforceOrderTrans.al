/// <summary>
/// Page RV Salesforce Order Trans. (ID 50922).
/// FDD006 2026/11/07: New. (Shawn)
/// </summary>
page 50922 "RV Salesforce Order Trans."
{
    ApplicationArea = All;
    Caption = 'Salesforce Order Transaction';
    PageType = List;
    SourceTable = "RV Salesforce Order Trans.";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Staging Entry No."; Rec."Staging Entry No.")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Action Type"; Rec."Action Type")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("CR No."; Rec."CR No.")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Customer Name"; Rec."Ship-to Customer Name")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("ETA"; Rec."ETA")
                {
                }
                field("ETD"; Rec."ETD")
                {
                }
                field("RVM PIC"; Rec."RVM PIC")
                {
                }
                field("Salesforce Remarks"; Rec."Salesforce Remarks")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Quantity"; Rec."Quantity")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Status"; Rec."Status")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }

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
                Image = NewSparkle;

                trigger OnAction()
                var
                    SFMgt: Codeunit "RV Salesforce Order Mgt";
                    ProcessQst: Label 'Are you sure to process all data to Sales Order?';
                    ProcessOkMsg: Label 'Process finished.';
                begin

                    if not Confirm(ProcessQst) then
                        exit;

                    SFMgt.Carryout();

                    Message(ProcessOkMsg);

                end;
            }
        }

        area(Promoted)
        {
            actionref("CarryOut_Promoted"; "Carry Out")
            {
            }
        }

    }
}
