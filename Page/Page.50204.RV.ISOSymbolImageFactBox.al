/// <summary>
/// Page ISO Symbol Setting (ID 50203).
/// FDD019 2026/04/20: New. (Bobby.ji)
/// </summary>
page 50204 "ISO Symbol Image FactBox"
{
    PageType = CardPart;
    SourceTable = "RV Item Symbol Setting";
    Caption = 'Image';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(ImageGroup)
            {
                field(ItemSymbolImage; Rec."Item Symbol Image")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
        }

    }
    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                begin
                    UploadPicture();
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec."Item Symbol Image");
                    Rec.Modify(true);
                end;
            }
        }
    }
    var
        DeleteImageQst: Label 'Are you sure you want to delete the Image?';

    local procedure UploadPicture()
    var
        FileMgt: Codeunit "File Management";
        InStr: InStream;
        FileName: Text;
        ClientFileName: Text;
    begin
        if UploadIntoStream('Select Picture', '', 'Image Files (*.jpg)|*.jpg|*.png|*.png', ClientFileName, InStr) then begin
            if ClientFileName <> '' then
                FileName := FileMgt.GetFileName(ClientFileName);
            Clear(Rec."Item Symbol Image");
            Rec."Item Symbol Image".ImportStream(InStr, FileName);
            if not Rec.Modify(true) then
                Rec.Insert(true);
        end;
    end;


}

