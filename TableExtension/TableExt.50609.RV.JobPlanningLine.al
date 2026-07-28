tableextension 50609 "RV Job Planning Line" extends "Job Planning Line"
{
    fields
    {
        field(50600; "RV_Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'RV_Global Dimension 1 Code';
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
            fieldclass = FlowField;
            calcformula = lookup("Job task"."Global Dimension 1 Code" where("Job No." = field("Job No."),
                                                                            "Job Task No." = field("Job Task No.")));
        }
        field(50601; "RV_Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'RV_Global Dimension 2 Code';
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
            fieldclass = FlowField;
            calcformula = lookup("Job task"."Global Dimension 2 Code" where("Job No." = field("Job No."),
                                                                            "Job Task No." = field("Job Task No.")));
        }
    }
}
