/// <summary>
/// Report RV Create NC Header from QC (ID 50501)
/// FDD039 2026/10/19: New. (Mike)
/// </summary>
report 50501 "RV Create NC Header from QC"
{
    ApplicationArea = All;
    Caption = 'Create NC Header from QC';
    UsageCategory = Tasks;
    ProcessingOnly = true;



    /*
    dataset
    {
        dataitem(RunOnce; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                QCHeader: Record "RV QC Header";
                NCHeader: Record "RV NC Header";
            begin
                QCHeader.SetRange("QC No.", SelectedQCNo);
                if not QCHeader.FindFirst() then
                    Error('QC No. %1 does not exist.', SelectedQCNo);

                if QCHeader.Next() <> 0 then
                    Error('QC No. %1 is not unique. Select a QC No. that identifies one QC Header.', SelectedQCNo);

                if QCHeader."QC Status" <> QCHeader."QC Status"::Rejected then
                    Error('QC No. %1 must have the Rejected status before an NC Header can be created.', SelectedQCNo);

                QCHeader.CreateNCHeaderRecord(NCHeader);
            end;
        }
    }
    */

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(SelectedQCNo; SelectedQCNo)
                    {
                        ApplicationArea = All;
                        Caption = 'QC No.';
                        NotBlank = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            QCHeader: Record "RV QC Header";
                            QCHeaderLookup: Page "RV QC Header Lookup";
                        begin
                            //QCHeader.SetRange("QC Status", QCHeader."QC Status"::Rejected);
                            Clear(QCHeaderLookup);
                            QCHeaderLookup.SetTableView(QCHeader);
                            QCHeaderLookup.LookupMode(true);
                            if QCHeaderLookup.RunModal() = Action::LookupOK then begin
                                QCHeaderLookup.GetRecord(QCHeader);
                                SelectedQCNo := QCHeader."QC No.";
                                SelectedRVQCType := QCHeader."QC Type";
                                Text := SelectedQCNo;
                                exit(true);
                            end;

                            exit(false);
                        end;

                        trigger OnValidate()
                        var
                            QCHeader: Record "RV QC Header";
                        begin
                            if SelectedQCNo <> '' then begin

                                QCHeader.SetRange("QC No.", SelectedQCNo);
                                if not QCHeader.FindFirst() then
                                    Error('QC No. %1 does not exist.', SelectedQCNo);

                                if QCHeader.Next() <> 0 then
                                    Error('QC No. %1 is not unique. Select a QC No. that identifies one QC Header.', SelectedQCNo);

                                if QCHeader."QC Status" <> QCHeader."QC Status"::Rejected then
                                    Error('QC No. %1 must have the Rejected status before an NC Header can be created.', SelectedQCNo);

                                SelectedRVQCType := QCHeader."QC Type";
                            end;
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        QCHeader: Record "RV QC Header";
        NCHeader: Record "RV NC Header";
    begin
        QCHeader.SetRange("QC No.", SelectedQCNo);
        QCHeader.SetRange("QC Type", SelectedRVQCType);
        if not QCHeader.FindFirst() then
            Error('QC No. %1 does not exist.', SelectedQCNo);
        QCHeader.CreateNCHeaderRecord(NCHeader);
    end;

    var
        SelectedQCNo: Code[20];
        SelectedRVQCType: Enum "RV QC Type";
}
