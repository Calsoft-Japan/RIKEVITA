/// <summary>
/// Codeunit RV DocAttachmentSubscriber (ID 50500)
/// FDD014 2026/02/23: New. (Mike)
/// </summary>

codeunit 50500 "RV DocAttachmentSubscriber"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", OnBeforeDrillDown, '', false, false)]
    local procedure AttachQCHeader(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        QCHeader: Record "RV QC Header";
    begin
        case DocumentAttachment."Table ID" of
            Database::"RV QC Header":
                begin
                    RecRef.Open(Database::"RV QC Header");
                    if QCHeader.Get(DocumentAttachment."No.", DocumentAttachment."Line No.") then
                        RecRef.GetTable(QCHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasNumberFieldPrimaryKey, '', false, false)]
    local procedure QCNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        case TableNo of
            Database::"RV QC Header":
                begin
                    FieldNo := 1;
                    Result := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasLineNumberPrimaryKey, '', false, false)]
    local procedure QCNumberFieldRevisionKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        case TableNo of
            Database::"RV QC Header":
                begin
                    FieldNo := 2;
                    Result := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"RV QC Header", OnAfterDeleteEvent, '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteQCHeader(var Rec: Record "RV QC Header"; RunTrigger: Boolean)
    var
        DocAttachmentMgt: Codeunit "Document Attachment Mgmt";
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Rec);
        DocAttachmentMgt.DeleteAttachedDocuments(RecordRef);
    end;

}

