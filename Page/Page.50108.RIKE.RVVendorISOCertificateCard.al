/// <summary>
/// Page RV_Vendor ISO Certificate Card (ID 50108).
/// FDD013 2026/03/19: New (Liuyang)
/// Card view for creating and editing a single Vendor ISO Certificate record.
/// Mirrors all expiry and styling logic from the List page.
/// Supports document attachment and remarks.
/// </summary>
page 50108 "RV_Vendor ISO Certificate Card"
{
    Caption = 'Vendor ISO Certificate Card';
    PageType = Card;
    SourceTable = "RV_Vendor ISO Certificate List";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number. The Vendor Name is auto-populated on validation.';

                    trigger OnValidate()
                    begin
                        LookupVendorName();
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name, automatically filled from the Vendor No.';
                }
                field("ISO Certificate"; Rec."ISO Certificate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ISO certificate code. Must be defined in ISO Certificate Code setup.';

                    trigger OnValidate()
                    begin
                        ResolveIsoCertDescription();
                    end;
                }
                field(IsoCertDescription; IsoCertDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Certificate Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the ISO certificate, auto-populated from the ISO Certificate Code table.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = ExpiredStyleExpr;
                    ToolTip = 'Specifies the certificate status. Automatically set to Expired when End Date is earlier than today.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    StyleExpr = ExpiredStyleExpr;
                    ToolTip = 'Specifies the certificate start date.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    StyleExpr = ExpiredStyleExpr;
                    ToolTip = 'Specifies the certificate end date. When earlier than today, Status is automatically set to Expired and displayed in bold red.';
                }
            }
            group(NotesGroup)
            {
                Caption = 'Remarks';

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies remarks or additional information regarding this ISO certificate.';
                }
            }
        }
        area(FactBoxes)
        {
            part(AttachmentFactBox; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                // Links attachment records to the Vendor ISO Certificate table (ID 50103)
                // using Vendor No. as the document identifier.
                SubPageLink = "Table ID" = const(50103),
                              "No." = field("Vendor No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add or view document attachments for this certificate record (e.g. scanned copy of the actual ISO certificate).';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Attachments_Promoted; Attachments) { }
        }
    }

    // ── Triggers ──────────────────────────────────────────────────────────

    trigger OnAfterGetRecord()
    begin
        // Resolve ISO Certificate description from the setup table.
        ResolveIsoCertDescription();

        // Auto-detect expiry and persist Status = Expired when required.
        CheckAndSetExpiredStatus();

        // Set bold red style for expired records.
        SetExpiredStyle();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Reset style and description for blank new record.
        ExpiredStyleExpr := 'Standard';
        IsoCertDescription := '';
    end;

    // ── Variables ─────────────────────────────────────────────────────────

    var
        // Drives the StyleExpr on Status, Start Date, End Date fields.
        // 'Unfavorable' renders as bold red in BC standard web client.
        ExpiredStyleExpr: Text;

        // Cached ISO Certificate description for the current record.
        IsoCertDescription: Text[100];

    // ── Local Procedures ──────────────────────────────────────────────────

    /// <summary>
    /// Looks up Vendor Name from the Vendor table for the current Rec."Vendor No."
    /// and updates Rec."Vendor Name". Called from Vendor No. field OnValidate.
    /// </summary>
    local procedure LookupVendorName()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Vendor No.") then
            Rec."Vendor Name" := Vendor.Name
        else
            Rec."Vendor Name" := '';
    end;

    /// <summary>
    /// Resolves the description from RV_ISO Certificate Code for the current record
    /// and stores it in the page variable IsoCertDescription.
    /// </summary>
    local procedure ResolveIsoCertDescription()
    var
        IsoCertCode: Record "RV_ISO Certificate Code";
    begin
        if IsoCertCode.Get(Rec."ISO Certificate") then
            IsoCertDescription := IsoCertCode.Description
        else
            IsoCertDescription := '';
    end;

    /// <summary>
    /// Checks whether the certificate has expired and persists Status = Expired
    /// when End Date less than Today. Implements FDD requirement:
    ///   "Expired must be automatically changed by the system when End Date less than current date."
    /// </summary>
    local procedure CheckAndSetExpiredStatus()
    begin
        if (Rec."End Date" <> 0D) and
           (Rec."End Date" < Today) and
           (Rec.Status <> Rec.Status::Expired)
        then begin
            Rec.Status := Rec.Status::Expired;
            Rec.Modify();
        end;
    end;

    /// <summary>
    /// Sets ExpiredStyleExpr based on current Status.
    /// 'Unfavorable' renders as bold red; 'Standard' is the default display.
    /// </summary>
    local procedure SetExpiredStyle()
    begin
        if Rec.Status = Rec.Status::Expired then
            ExpiredStyleExpr := 'Unfavorable'
        else
            ExpiredStyleExpr := 'Standard';
    end;
}
