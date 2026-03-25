/// <summary>
/// Page RV_Vendor ISO Certificate List (ID 50107).
/// FDD013 2026/03/19: New (Liuyang)
/// Lists all Vendor ISO Certificates. When opened from Vendor Card or
/// Vendor List, the page is automatically filtered by Vendor No.
/// Expired rows (End Date less than Today) are automatically detected and shown
/// in bold red font (Status field, Start Date, End Date).
/// Supports document attachment and remarks.
/// </summary>
page 50107 "RV Vendor ISO Certificate List"
{
    Caption = 'Vendor ISO Certificate List';
    PageType = List;
    SourceTable = "RV Vendor ISO Certificate List";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "RV Vendor ISO Certificate Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number.';

                    trigger OnValidate()
                    begin
                        LookupVendorName();
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name, auto-populated from the Vendor No.';
                }
                field("ISO Certificate"; Rec."ISO Certificate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ISO certificate code. Must be defined in ISO Certificate Code setup.';
                }
                field(IsoCertDescription; IsoCertDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Certificate Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the ISO certificate, populated from the ISO Certificate Code table.';
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
                    ToolTip = 'Specifies the certificate end date. When this date is earlier than today, status is automatically set to Expired and displayed in bold red.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks or additional information regarding the certificate.';
                }
            }
        }
        area(FactBoxes)
        {
            part(AttachmentFactBox; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                // Links attachment records to this Vendor ISO Certificate table (ID 50103)
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
            action(NewRecord)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                ToolTip = 'Create a new vendor ISO certificate record.';

                trigger OnAction()
                begin
                    Rec.Init();
                    // If page was opened with a Vendor No. filter, pre-fill the field
                    // so the new record belongs to the same vendor.
                    if VendorNoFilter <> '' then begin
                        Rec."Vendor No." := VendorNoFilter;
                        LookupVendorNameForRec(Rec);
                    end;
                    CurrPage.Update(false);
                end;
            }
            action(DeleteRecord)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the selected vendor ISO certificate record.';

                trigger OnAction()
                begin
                    if Confirm(DeleteConfirmQst, false, Rec."ISO Certificate") then
                        Rec.Delete(true);
                end;
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add or view document attachments for this certificate record.';

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
            actionref(NewRecord_Promoted; NewRecord) { }
            actionref(DeleteRecord_Promoted; DeleteRecord) { }
            actionref(Attachments_Promoted; Attachments) { }
        }
    }

    // ── Triggers ──────────────────────────────────────────────────────────

    trigger OnOpenPage()
    begin
        // Capture any active Vendor No. filter so the New action can pre-fill it.
        VendorNoFilter := Rec.GetFilter("Vendor No.");
    end;

    trigger OnAfterGetRecord()
    begin
        // Resolve ISO Certificate description from the setup table.
        ResolveIsoCertDescription();

        // Auto-detect expiry: if End Date is set and is earlier than today,
        // force Status to Expired and persist the change.
        CheckAndSetExpiredStatus();

        // Set the style expression for bold red rendering when Expired.
        SetExpiredStyle();
    end;

    // ── Variables ─────────────────────────────────────────────────────────

    var
        // Drives the StyleExpr on Status, Start Date, End Date columns.
        // Value 'Unfavorable' renders as bold red in BC standard UI.
        ExpiredStyleExpr: Text;

        // Cached ISO Certificate description for the current row.
        IsoCertDescription: Text[100];

        // Stores the active Vendor No. filter when page is opened from Vendor Card/List.
        VendorNoFilter: Code[20];

        DeleteConfirmQst: Label 'Are you sure you want to delete the ISO certificate record for %1?', Comment = '%1 = ISO Certificate Code';

    // ── Local Procedures ──────────────────────────────────────────────────

    /// <summary>
    /// Looks up the Vendor Name from the Vendor table for the current Rec."Vendor No."
    /// and updates Rec."Vendor Name". Called from the Vendor No. field OnValidate.
    /// </summary>
    local procedure LookupVendorName()
    begin
        LookupVendorNameForRec(Rec);
    end;

    /// <summary>
    /// Looks up the Vendor Name for a given Sales Line record and sets Vendor Name.
    /// Separated from LookupVendorName so it can be called with any record instance
    /// (e.g. from the New action when pre-filling a new row).
    /// </summary>
    local procedure LookupVendorNameForRec(var VendorIsoCert: Record "RV Vendor ISO Certificate List")
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorIsoCert."Vendor No.") then
            VendorIsoCert."Vendor Name" := Vendor.Name
        else
            VendorIsoCert."Vendor Name" := '';
    end;

    /// <summary>
    /// Resolves the description from RV_ISO Certificate Code for the current row
    /// and stores it in the page variable IsoCertDescription.
    /// </summary>
    local procedure ResolveIsoCertDescription()
    var
        IsoCertCode: Record "RV ISO Certificate Code";
    begin
        if IsoCertCode.Get(Rec."ISO Certificate") then
            IsoCertDescription := IsoCertCode.Description
        else
            IsoCertDescription := '';
    end;

    /// <summary>
    /// Checks whether the certificate has expired (End Date is set and is earlier
    /// than today). If so, sets Status to Expired and modifies the record to persist
    /// the change. This implements the FDD requirement:
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
    /// 'Unfavorable' renders as bold red in the BC standard web client.
    /// All other statuses use 'Standard' (normal font).
    /// </summary>
    local procedure SetExpiredStyle()
    begin
        if Rec.Status = Rec.Status::Expired then
            ExpiredStyleExpr := 'Unfavorable'
        else
            ExpiredStyleExpr := 'Standard';
    end;
}
