tableextension 50404 "RV Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        field(50400; "RV_Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(50401; "RV_Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
    }
}
