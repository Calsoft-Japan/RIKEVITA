/// <summary>
/// CodeUnit RV Doc. Attachment Custom Rec (ID 50103).
/// FDD013 2026/03/25: New (Liuyang)
/// </summary>
codeunit 50103 "RV Doc. Attachment Custom Rec"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasNumberFieldPrimaryKey, '', false, false)]
    local procedure "Document Attachment Mgmt_OnAfterTableHasNumberFieldPrimaryKey"(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        if TableNo = Database::"RV Vendor ISO Certificate Line" then begin
            FieldNo := 9;//field(9; "Attach. Doc. No."; Code[20])
            Result := true;
        end;
    end;



    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterSetDocumentAttachmentFiltersForRecRefInternal, '', false, false)]
    local procedure "Document Attachment Mgmt_OnAfterSetDocumentAttachmentFiltersForRecRefInternal"(var DocumentAttachment: Record "Document Attachment"; RecordRef: RecordRef; GetRelatedAttachments: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        FieldNo: Integer;
    begin
        if RecordRef.Number() = Database::"RV Vendor ISO Certificate Line" then begin
            FieldNo := 9;//field(9; "Attach. Doc. No."; Code[20])

            FieldRef := RecordRef.Field(FieldNo);
            RecNo := FieldRef.Value();
            DocumentAttachment.SetRange("No.", RecNo);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnAfterInitFieldsFromRecRef, '', false, false)]
    local procedure "Document Attachment_OnAfterInitFieldsFromRecRef"(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        FieldNo: Integer;
    begin
        if RecRef.Number() = Database::"RV Vendor ISO Certificate Line" then begin
            FieldNo := 9;//field(9; "Attach. Doc. No."; Code[20])

            FieldRef := RecRef.Field(FieldNo);
            RecNo := FieldRef.Value();
            DocumentAttachment.SetRange("No.", RecNo);
        end;
    end; */


}
