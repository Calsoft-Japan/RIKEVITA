/// <summary>
/// PageExtension RV_WarehouseShipment (ID 50909) extends "Warehouse Shipment"
/// FDD0XX 2026/11/13: New. (Shawn) 
/// </summary>
pageextension 50909 "RV WarehouseShipment Ext" extends "Warehouse Shipment"
{

    layout
    {
        addlast(General)
        {
            field("RV_Item Reclass. Jnl. Created"; Rec."RV_Item Reclass. Jnl. Created")
            {
                ApplicationArea = All;
                Description = 'FDD102';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(CreateItemReclassJournal)
            {
                ApplicationArea = All;
                Caption = 'Create Item Reclass. Journal';
                Image = InventoryJournal;
                ToolTip = 'Create an item reclassification journal for this warehouse shipment.';

                trigger OnAction()
                var
                    WSItemReclassJnlMgt: Codeunit "RV WS Item Reclass. Jnl. Mgt.";
                begin
                    if Rec."RV_Item Reclass. Jnl. Created" then begin
                        if not Confirm('Item reclassification journals have already been created.\Do you want to create them again?') then
                            exit;
                    end else begin
                        if not Confirm('Item reclassification journals will be created.\Choose ''Yes'' to continue.') then
                            exit;
                    end;

                    WSItemReclassJnlMgt.CreateFromWarehouseShipment(Rec);

                    Rec."RV_Item Reclass. Jnl. Created" := true;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
        }
        addlast("Category_Process")
        {
            actionref("CreateItemReclassJournal_Promoted"; "CreateItemReclassJournal")
            {
            }
        }
    }
}
