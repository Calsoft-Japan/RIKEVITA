/// <summary>
/// PageExtension RV Sales Lines Ext (ID 50118) extends "Sales Lines" Page
/// FDD005 2026/07/06: New. (Liuyang)
/// </summary>
pageextension 50118 "RV Sales Lines Ext" extends "Sales Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                Visible = ShowExtDoc;
            }
        }
    }

    var
        ShowExtDoc: Boolean;


    procedure showExtDocNo()
    begin
        ShowExtDoc := true;
    end;
}
