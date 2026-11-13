/// <summary>
/// PageExtension RV_WarehouseShipment (ID 50909) extends "Warehouse Shipment"
/// FDD0XX 2026/11/13: New. (Shawn) 
/// </summary>
pageextension 50909 "RV WarehouseShipment Ext" extends "Warehouse Shipment"
{
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
                //WSItemReclassJnlMgt: Codeunit "RV WS Item Reclass. Jnl. Mgt.";
                begin

                    Message('Under Construction!');
                    exit;

                    //WSItemReclassJnlMgt.CreateFromWarehouseShipment(Rec);
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
