/// <summary>
/// PAge RV.QC Remark Input (ID 50528)
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
page 50528 "RV QC Remark Input"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Remark Input';
    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field("Remark Text"; RemarkText[1])
                {
                    ApplicationArea = all;
                    MultiLine = true;
                    CaptionClass = RemarkText[2];
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
        end;
    end;

    procedure GetParameter(): array[2] of Text
    var
    begin
        EXIT(RemarkText);
    end;

    procedure SetParameter(NewRemarkText: array[2] of Text)
    var
    begin
        CopyArray(RemarkText, NewRemarkText, 1, 2);
    end;




    var
        RemarkText: array[2] of Text;

}