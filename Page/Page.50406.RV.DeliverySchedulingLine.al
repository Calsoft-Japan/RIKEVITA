namespace RIKEVITA.RIKEVITA;

page 50406 "RV Delivery Scheduling Lines"
{
    ApplicationArea = All;
    Caption = 'Delivery Scheduling Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    modifyAllowed = false;
    LinksAllowed = true;
    PageType = ListPart;
    SourceTable = "RM Delivery Scheduling Line";

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field(VendorNo; Rec.VendorNo)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Description"; Rec."Vendor Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Site"; Rec."Site")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Site field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Date1 Quantity"; Rec."Date1 Quantity")
                {
                    CaptionClass = '3,' + DayCaption[1];
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Date1  field.', Comment = '%';
                }
                field("Date2 Quantity"; Rec."Date2 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[2];
                    ToolTip = 'Specifies the value of the Date2 field.', Comment = '%';
                }
                field("Date3 Quantity"; Rec."Date3 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[3];
                    ToolTip = 'Specifies the value of the Date3 field.', Comment = '%';
                }
                field("Date4 Quantity"; Rec."Date4 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[4];
                    ToolTip = 'Specifies the value of the Date4 field.', Comment = '%';
                }
                field("Date5 Quantity"; Rec."Date5 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[5];
                    ToolTip = 'Specifies the value of the Date5 field.', Comment = '%';
                }
                field("Date6 Quantity"; Rec."Date6 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[6];
                    ToolTip = 'Specifies the value of the Date6 field.', Comment = '%';
                }
                field("Date7 Quantity"; Rec."Date7 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[7];
                    ToolTip = 'Specifies the value of the Date7 field.', Comment = '%';
                }
                field("Date8 Quantity"; Rec."Date8 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[8];
                    ToolTip = 'Specifies the value of the Date8 field.', Comment = '%';
                }
                field("Date9 Quantity"; Rec."Date9 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[9];
                    ToolTip = 'Specifies the value of the Date9 field.', Comment = '%';
                }
                field("Date10 Quantity"; Rec."Date10 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[10];
                    ToolTip = 'Specifies the value of the Date10 field.', Comment = '%';
                }
                field("Date11 Quantity"; Rec."Date11 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[11];
                    ToolTip = 'Specifies the value of the Date11 field.', Comment = '%';
                }
                field("Date12 Quantity"; Rec."Date12 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[12];
                    ToolTip = 'Specifies the value of the Date12 field.', Comment = '%';
                }
                field("Date13 Quantity"; Rec."Date13 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[13];
                    ToolTip = 'Specifies the value of the Date13 field.', Comment = '%';
                }
                field("Date14 Quantity"; Rec."Date14 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[14];
                    ToolTip = 'Specifies the value of the Date14 field.', Comment = '%';
                }
                field("Date15 Quantity"; Rec."Date15 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[15];
                    ToolTip = 'Specifies the value of the Date15 field.', Comment = '%';
                }
                field("Date16 Quantity"; Rec."Date16 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[16];
                    ToolTip = 'Specifies the value of the Date16 field.', Comment = '%';
                }
                field("Date17 Quantity"; Rec."Date17 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[17];
                    ToolTip = 'Specifies the value of the Date17 field.', Comment = '%';
                }
                field("Date18 Quantity"; Rec."Date18 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[18];
                    ToolTip = 'Specifies the value of the Date18 field.', Comment = '%';
                }
                field("Date19 Quantity"; Rec."Date19 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[19];
                    ToolTip = 'Specifies the value of the Date19 field.', Comment = '%';
                }
                field("Date20 Quantity"; Rec."Date20 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[20];
                    ToolTip = 'Specifies the value of the Date20 field.', Comment = '%';
                }
                field("Date21 Quantity"; Rec."Date21 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[21];
                    ToolTip = 'Specifies the value of the Date21 field.', Comment = '%';
                }
                field("Date22 Quantity"; Rec."Date22 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[22];
                    ToolTip = 'Specifies the value of the Date22 field.', Comment = '%';
                }
                field("Date23 Quantity"; Rec."Date23 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[23];
                    ToolTip = 'Specifies the value of the Date23 field.', Comment = '%';
                }
                field("Date24 Quantity"; Rec."Date24 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[24];
                    ToolTip = 'Specifies the value of the Date24 field.', Comment = '%';
                }
                field("Date25 Quantity"; Rec."Date25 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[25];
                    ToolTip = 'Specifies the value of the Date25 field.', Comment = '%';
                }
                field("Date26 Quantity"; Rec."Date26 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[26];
                    ToolTip = 'Specifies the value of the Date26 field.', Comment = '%';
                }
                field("Date27 Quantity"; Rec."Date27 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[27];
                    ToolTip = 'Specifies the value of the Date27 field.', Comment = '%';
                }
                field("Date28 Quantity"; Rec."Date28 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[28];
                    ToolTip = 'Specifies the value of the Date28 field.', Comment = '%';
                }
                field("Date29 Quantity"; Rec."Date29 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[29];
                    ToolTip = 'Specifies the value of the Date29 field.', Comment = '%';
                }
                field("Date30 Quantity"; Rec."Date30 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[30];
                    ToolTip = 'Specifies the value of the Date30 field.', Comment = '%';
                }
                field("Date31 Quantity"; Rec."Date31 Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '3,' + DayCaption[31];
                    ToolTip = 'Specifies the value of the Date31 field.', Comment = '%';
                }

            }
        }
    }
    trigger OnOpenPage()
    var

    begin
        //SetDayCaption(Rec."Starting Date");

    end;

    procedure SetDayCaption(StartingDate: Date)
    var
        I: Integer;
        FirstDay: Integer;
    begin
        FirstDay := Date2DMY(StartingDate, 3);
        for I := 1 to 31 do begin
            DayCaption[I] := FORMAT(StartingDate, 0, '<Month,2>/<Day,2>');
            StartingDate := CalcDate('1D', StartingDate);
        end;
    end;

    var
        DayCaption: array[31] of Text[30];
}
