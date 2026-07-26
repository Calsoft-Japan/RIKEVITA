pageextension 50401 "RV Location Card" extends "Location Card"
{
    layout
    {
        addafter(Name)
        {
            field(RV_ETA; Rec."RV_Invy. Status")
            {
                ApplicationArea = All;
                Description = 'Inventory Status';
            }
        }
    }
}
