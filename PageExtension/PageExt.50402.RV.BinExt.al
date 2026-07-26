
pageextension 50402 "RV Bins" extends Bins
{
    layout
    {
        addafter(Description)
        {
            field(RV_ETA; Rec."RV_Invy. Status")
            {
                ApplicationArea = All;
                Description = 'Inventory Status';
            }
        }
    }
}
