/// <summary>
/// Codeunit RV DocAttachmentSubscriber (ID 50500)
/// FDD014 2026/02/23: New. (Mike)
/// </summary>

codeunit 50500 "RV DocAttachmentSubscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterGetRefTable, '', false, false)]
    local procedure GetRefTableCollectiveInvoice(var RecRef: RecordRef; DocumentAttachment: Record "Document Attachment")
    var
        QCHeader: Record "RV QC Header";
        NCHeader: Record "RV NC Header";
        QCType: Enum "RV QC Type";
    begin
        case DocumentAttachment."Table ID" of
            Database::"RV QC Header":
                begin
                    RecRef.Open(Database::"RV QC Header");
                    if QCHeader.Get(DocumentAttachment."No.", DocumentAttachment."Line No.") then
                        RecRef.GetTable(QCHeader);
                end;
            Database::"RV NC Header":
                begin
                    RecRef.Open(Database::"RV NC Header");
                    QCType := Enum::"RV QC Type".FromInteger(DocumentAttachment."Line No.");
                    if NCHeader.Get(DocumentAttachment."No.", QCType) then
                        RecRef.GetTable(NCHeader);
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
            Database::"RV NC Header":
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
            Database::"RV NC Header":
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

    [EventSubscriber(ObjectType::Table, Database::"RV NC Header", OnAfterDeleteEvent, '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteNCHeader(var Rec: Record "RV NC Header"; RunTrigger: Boolean)
    var
        DocAttachmentMgt: Codeunit "Document Attachment Mgmt";
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Rec);
        DocAttachmentMgt.DeleteAttachedDocuments(RecordRef);
    end;

}
