/// <summary>
/// Page RV MPS Rescheduling Worksheet(ID 50604)
/// FDD011 2026/02/23: New. (stephen)
/// </summary>
page 50604 "RV MPS Rescheduling Worksheet"
{
    ApplicationArea = All;
    Caption = 'MPS Rescheduling Worksheet';
    PageType = Worksheet;
    SourceTable = "RV MPS Rescheduling Line";
    UsageCategory = Tasks;
    AutoSplitKey = true;
    DelayedInsert = true;
    SaveValues = true;

    layout
    {
        area(Content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    MPSReschedulingMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    MPSReschedulingMgt.CheckName(CurrentJnlBatchName, Rec);
                end;

            }
            repeater(General)
            {
                field("Production No."; Rec."Production No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Quantity"; Rec."Quantity")
                {
                }
                field("Routing No."; Rec."Routing No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("New Starting Date"; Rec."New Starting Date")
                {
                }
                field("New Ending Date"; Rec."New Ending Date")
                {
                }
                field("Work Center No. 1"; Rec."Work Center No. 1")
                {
                }
                field("Work Center No. 2"; Rec."Work Center No. 2")
                {
                }
                field("Work Center No. 3"; Rec."Work Center No. 3")
                {
                }
                field("New Work Center No. 1"; Rec."New Work Center No. 1")
                {
                }
                field("New Work Center No. 2"; Rec."New Work Center No. 2")
                {
                }
                field("New Work Center No. 3"; Rec."New Work Center No. 3")
                {
                }
                field("Planning Status"; Rec."Planning Status")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CollectMPSData)
            {
                ApplicationArea = All;
                Caption = 'Collect MPS Data';
                Image = CollectedTax;

                trigger OnAction()
                var
                    CollectMPSDataReport: Report "RV Collect MPS Data";
                begin
                    CollectMPSDataReport.SetBatchName(CurrentJnlBatchName);
                    CollectMPSDataReport.Run();
                end;
            }
            action(ExportMPSData)
            {
                ApplicationArea = All;
                Caption = 'Export MPS Data';
                Image = ExportToExcel;

                trigger OnAction()
                begin
                    ExportToExcel();
                end;
            }
            action(ImportMPSData)
            {
                ApplicationArea = All;
                Caption = 'Import MPS Data';
                Image = ImportExcel;

                trigger OnAction()
                begin
                    ImportFromExcel();
                end;
            }
            action(ApplyReschedulingData)
            {
                ApplicationArea = All;
                Caption = 'Apply Rescheduling Data';
                Image = Apply;

                trigger OnAction()
                begin
                    UpdateMOData();
                end;
            }
        }
        area(Promoted)
        {
            actionref(CollectMPSData_Promoted; CollectMPSData) { }
            actionref(ExportMPSData_Promoted; ExportMPSData) { }
            actionref(ImportMPSData_Promoted; ImportMPSData) { }
            actionref(ApplyReschedulingData_Promoted; ApplyReschedulingData) { }
        }
    }

    trigger OnOpenPage()
    begin
        OpenedFromBatch := (Rec."Batch Name" <> '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Batch Name";
            MPSReschedulingMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        MPSReschedulingMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        CurrentJnlBatchName: Code[10];
        MPSReschedulingMgt: Codeunit "RV MPS Rescheduling Management";
        OpenedFromBatch: Boolean;
        TempExcelBuffer: Record "Excel Buffer" temporary;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        MPSReschedulingMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    procedure ExportToExcel()
    var
        SheetName: label 'MPS Rescheduling Data';
        FileName: Label 'MPS Rescheduling Data_%1_%2';
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
    begin
        MPSReschedulingLine.CopyFilters(Rec);
        if MPSReschedulingLine.FindSet() then begin
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Batch Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("batch Line No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('GUID', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Production No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Item No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Quantity"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Starting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Ending Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Due Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Routing No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Work Center No. 1"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Work Center No. 2"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Work Center No. 3"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("New Starting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("New Ending Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("New Work Center No. 1"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("New Work Center No. 2"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("New Work Center No. 3"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(MPSReschedulingLine.FieldCaption("Planning Status"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Batch Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."batch Line No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(MPSReschedulingLine.SystemId, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Production No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Starting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Ending Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Due Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Routing No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Work Center No. 1", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Work Center No. 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Work Center No. 3", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."New Starting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."New Ending Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."New Work Center No. 1", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."New Work Center No. 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."New Work Center No. 3", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MPSReschedulingLine."Planning Status", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until MPSReschedulingLine.Next() = 0;
            TempExcelBuffer.CreateNewBook(SheetName);
            TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
            TempExcelBuffer.CloseBook();
            TempExcelBuffer.SetFriendlyFilename(StrSubstNo(FileName, CompanyName, UserId));
            TempExcelBuffer.OpenExcel();
        end;
    end;

    procedure ImportFromExcel()
    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        FileMgt: Codeunit "File Management";
        Instr: InStream;
        FromFileName: Text;
        FileName: Text;
        SheetName: Text;
        MaxRowNo: Integer;
        ExcelValue: Text;
        RowNo: Integer;
        ImportGUID: Guid;
        ImportBatchName: Text;
        ImportBatchLineNo: Integer;
        ImportQty: Decimal;
        ImportDate: Date;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        NoFindMsg: Label 'No data was found by data filter “Batch No.” %1 and “Batch Line No.” %2.';
        NonEditMsg: Label 'Some non-editable data was different from the imported line got by data filter “Batch No.” %1 and “Batch Line No.” %2.';
        InvalidStartDateMsg: Label 'The line''s "Starting Date" is later than "Ending Date" got by "Batch No." %1 and "Batch Line No." %2.';
        InvalidEndDateMsg: Label 'The line''s "Ending Date" is later than "Due Date" got by "Batch No." %1 and "Batch Line No." %2.';
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFileName, Instr);
        if FromFileName <> '' then begin
            FileName := FileMgt.GetFileName(FromFileName);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(Instr);
        end else
            Error(NoFileFoundMsg);

        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(Instr, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            Evaluate(ImportGUID, GetValueAtCell(RowNo, 3));

            if MPSReschedulingLine.GetBySystemId(ImportGUID) then begin
                ImportBatchName := GetValueAtCell(RowNo, 1);
                Evaluate(ImportBatchLineNo, GetValueAtCell(RowNo, 2));
                if MPSReschedulingLine."Production No." <> GetValueAtCell(RowNo, 4) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                if MPSReschedulingLine."Item No." <> GetValueAtCell(RowNo, 5) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                Evaluate(ImportQty, GetValueAtCell(RowNo, 6));
                if MPSReschedulingLine.Quantity <> ImportQty then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                Evaluate(ImportDate, GetValueAtCell(RowNo, 7));
                if MPSReschedulingLine."Starting Date" <> ImportDate then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                Evaluate(ImportDate, GetValueAtCell(RowNo, 8));
                if MPSReschedulingLine."Ending Date" <> ImportDate then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                Evaluate(ImportDate, GetValueAtCell(RowNo, 9));
                if MPSReschedulingLine."Due Date" <> ImportDate then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                if MPSReschedulingLine."Routing No." <> GetValueAtCell(RowNo, 10) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                if MPSReschedulingLine."Work Center No. 1" <> GetValueAtCell(RowNo, 11) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                if MPSReschedulingLine."Work Center No. 2" <> GetValueAtCell(RowNo, 12) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                if MPSReschedulingLine."Work Center No. 3" <> GetValueAtCell(RowNo, 13) then
                    Error(NonEditMsg, ImportBatchName, ImportBatchLineNo);
                Evaluate(MPSReschedulingLine."New Starting Date", GetValueAtCell(RowNo, 14));
                Evaluate(MPSReschedulingLine."New Ending Date", GetValueAtCell(RowNo, 15));
                if MPSReschedulingLine."New Starting Date" > MPSReschedulingLine."New Ending Date" then
                    Error(InvalidStartDateMsg, ImportBatchName, ImportBatchLineNo);
                if DT2Date(MPSReschedulingLine."New Ending Date") > MPSReschedulingLine."Due Date" then
                    Error(InvalidEndDateMsg, ImportBatchName, ImportBatchLineNo);
                MPSReschedulingLine."New Work Center No. 1" := GetValueAtCell(RowNo, 16);
                MPSReschedulingLine."New Work Center No. 2" := GetValueAtCell(RowNo, 17);
                MPSReschedulingLine."New Work Center No. 3" := GetValueAtCell(RowNo, 18);
                Evaluate(MPSReschedulingLine."Planning Status", GetValueAtCell(RowNo, 19));
                MPSReschedulingLine.Modify();
            end else
                Error(NoFindMsg, GetValueAtCell(RowNo, 1), GetValueAtCell(RowNo, 2));
        end;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure UpdateMOData()
    var
        MPSReschedulingLine: Record "RV MPS Rescheduling Line";
        MPSReschedulingUpdateBatch: Codeunit "RV MPS Reschedul Update Batch";
    begin
        MPSReschedulingLine.Reset();
        MPSReschedulingLine.CopyFilters(Rec);
        if MPSReschedulingLine.FindSet() then
            repeat
                if not MPSReschedulingUpdateBatch.Run(MPSReschedulingLine) then begin
                    MPSReschedulingLine.Status := MPSReschedulingLine.Status::Error;
                    MPSReschedulingLine."Error Message" := getLastErrorText();
                    MPSReschedulingLine.Modify();
                end;
            until MPSReschedulingLine.Next() = 0;
    end;
}
