/// <summary>
/// Table RV Salesforce Order Buffer (ID 50611).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
table 50611 "RV Salesforce Order Buffer"
{
    Caption = 'Salesforce Order Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            autoIncrement = true;
        }
        field(2; "Interface Date and Time"; DateTime)
        {
            Caption = 'Interface Date and Time';
            DataClassification = ToBeClassified;
        }
        field(3; "Action Type"; Enum "RV Salesforce Action Type")
        {
            Caption = 'Action Type';
            DataClassification = ToBeClassified;
        }
        field(4; "PCN No."; Code[80])
        {
            Caption = 'PCN No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Bill Invoice to(Code)"; Code[20])
        {
            Caption = 'Bill Invoice to(Code)';
            DataClassification = ToBeClassified;
        }
        field(7; "Bill Invoice to"; Text[100])
        {
            Caption = 'Bill Invoice to';
            DataClassification = ToBeClassified;
        }
        field(8; "Sales Company"; Text[100])
        {
            Caption = 'Sales Company';
            DataClassification = ToBeClassified;
        }
        field(9; "End Customer / Ship to(Code)"; Code[20])
        {
            Caption = 'End Customer / Ship to(Code)';
            DataClassification = ToBeClassified;
        }
        field(10; "End Customer / Ship to"; Text[100])
        {
            Caption = 'End Customer / Ship to';
            DataClassification = ToBeClassified;
        }
        field(11; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = ToBeClassified;
        }
        field(12; Customer; Text[100])
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(13; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
        field(14; "ETA(Request)"; Date)
        {
            Caption = 'ETA(Request)';
            DataClassification = ToBeClassified;
        }
        field(15; "ETD(Request)"; Date)
        {
            Caption = 'ETD(Request)';
            DataClassification = ToBeClassified;
        }
        field(16; "Trade Term(Incoterms)"; Text[100])
        {
            Caption = 'Trade Term(Incoterms)';
            DataClassification = ToBeClassified;
        }
        field(17; Incoterms; Code[10])
        {
            Caption = 'Incoterms';
            DataClassification = ToBeClassified;
        }
        field(18; Transportation; Text[100])
        {
            Caption = 'Transportation';
            DataClassification = ToBeClassified;
        }
        field(19; "Product Code1"; Code[20])
        {
            Caption = 'Product Code1';
            DataClassification = ToBeClassified;
        }
        field(20; "Product Name1"; Text[100])
        {
            Caption = 'Product Name1';
            DataClassification = ToBeClassified;
        }
        field(21; "Qty1(kg)"; Decimal)
        {
            Caption = 'Qty1(kg)';
            DataClassification = ToBeClassified;
        }
        field(22; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
        }
        field(23; "Unit Price1(per kg)"; Decimal)
        {
            Caption = 'Unit Price1(per kg)';
            DataClassification = ToBeClassified;
        }
        field(24; Remarks; Blob)
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(25; "Destination(Shipment to)"; Text[100])
        {
            Caption = 'Destination(Shipment to)';
            DataClassification = ToBeClassified;
        }
        field(26; "Destination(Pick List)"; Text[100])
        {
            Caption = 'Destination(Pick List)';
            DataClassification = ToBeClassified;
        }
        field(27; "Payment Terms(Payment Condit.)"; Text[100])
        {
            Caption = 'Payment Terms (Payment Conditions)';
            DataClassification = ToBeClassified;
        }
        field(28; "Price Type"; Text[100])
        {
            Caption = 'Price Type';
            DataClassification = ToBeClassified;
        }
        field(29; Palletize; Boolean)
        {
            Caption = 'Palletize';
            DataClassification = ToBeClassified;
        }
        field(30; SST; Integer)
        {
            Caption = 'SST';
            DataClassification = ToBeClassified;
        }
        field(31; "Port of Loading"; Text[100])
        {
            Caption = 'Port of Loading';
            DataClassification = ToBeClassified;
        }
        field(32; "Shipment(Request)"; Text[100])
        {
            Caption = 'Shipment(Request)';
            DataClassification = ToBeClassified;
        }
        field(33; "Consignee(Code)"; Code[20])
        {
            Caption = 'Consignee(Code)';
            DataClassification = ToBeClassified;
        }
        field(34; Consignee; Text[100])
        {
            Caption = 'Consignee';
            DataClassification = ToBeClassified;
        }
        field(35; "EndUser(Code)"; Code[10])
        {
            Caption = 'EndUser(Code)';
            DataClassification = ToBeClassified;
        }
        field(36; EndUser; Text[100])
        {
            Caption = 'EndUser';
            DataClassification = ToBeClassified;
        }
        field(37; "Request Documents"; Text[1000])
        {
            Caption = 'Request Documents';
            DataClassification = ToBeClassified;
        }
        field(38; "Sales Contact Note"; Blob)
        {
            Caption = 'Sales Contact Note';
            DataClassification = ToBeClassified;
        }
        field(39; Destination; Text[100])
        {
            Caption = 'Destination';
            DataClassification = ToBeClassified;
        }
        field(40; "Sales Rep"; Text[80])
        {
            Caption = 'Sales Rep';
            DataClassification = ToBeClassified;
        }
        field(41; "Sales Rep(TEXT)"; Text[80])
        {
            Caption = 'Sales Rep(TEXT)';
            DataClassification = ToBeClassified;
        }
        field(42; "Order PIC"; Text[80])
        {
            Caption = 'Order PIC';
            DataClassification = ToBeClassified;
        }
        field(43; "Order PIC(TEXT)"; Text[80])
        {
            Caption = 'Order PIC(TEXT)';
            DataClassification = ToBeClassified;
        }
        field(44; "CR No."; Code[20])
        {
            Caption = 'CR No.';
            DataClassification = ToBeClassified;
        }
        field(45; "After ETD(Request)"; Date)
        {
            Caption = 'After ETD(Request)';
            DataClassification = ToBeClassified;
        }
        field(46; "After ETA(Request)"; Date)
        {
            Caption = 'After ETA(Request)';
            DataClassification = ToBeClassified;
        }
        field(47; "After Customer(Code)"; Code[20])
        {
            Caption = 'After Customer(Code)';
            DataClassification = ToBeClassified;
        }
        field(48; "After Customer"; Text[100])
        {
            Caption = 'After Customer';
            DataClassification = ToBeClassified;
        }
        field(49; "After Consignee(Code)"; Code[20])
        {
            Caption = 'After Consignee(Code)';
            DataClassification = ToBeClassified;
        }
        field(50; "After Consignee"; Text[100])
        {
            Caption = 'After Consignee';
            DataClassification = ToBeClassified;
        }
        field(51; "After Enduser(Code)"; Code[20])
        {
            Caption = 'After Enduser(Code)';
            DataClassification = ToBeClassified;
        }
        field(52; "After Enduser"; Text[100])
        {
            Caption = 'After Enduser';
            DataClassification = ToBeClassified;
        }
        field(53; "After Product Name1(Code)"; Code[20])
        {
            Caption = 'After Product Name1(Code)';
            DataClassification = ToBeClassified;
        }
        field(54; "After Product Name1"; Text[100])
        {
            Caption = 'After Product Name1';
            DataClassification = ToBeClassified;
        }
        field(55; "After Destination(Shipment to)"; Text[100])
        {
            Caption = 'After Destination(Shipment to)';
            DataClassification = ToBeClassified;
        }
        field(56; "After Destination"; Text[100])
        {
            Caption = 'After Destination';
            DataClassification = ToBeClassified;
        }
        field(57; "After Port of Loading"; Text[100])
        {
            Caption = 'After Port of Loading';
            DataClassification = ToBeClassified;
        }
        field(58; "After Destination(Pick List)"; Text[100])
        {
            Caption = 'After Destination(Pick List)';
            DataClassification = ToBeClassified;
        }
        field(59; "After Currency Code"; Code[10])
        {
            Caption = 'After Currency Code';
            DataClassification = ToBeClassified;
        }
        field(60; "After Unit Price1"; Decimal)
        {
            Caption = 'After Unit Price1';
            DataClassification = ToBeClassified;
        }
        field(61; "After Qty1(kg)"; Decimal)
        {
            Caption = 'After Qty1(kg)';
            DataClassification = ToBeClassified;
        }
        field(62; "After Transportation"; Text[100])
        {
            Caption = 'After Transportation';
            DataClassification = ToBeClassified;
        }
        field(63; "After Incoterms"; Code[10])
        {
            Caption = 'After Incoterms';
            DataClassification = ToBeClassified;
        }
        field(64; "After Trade Term(Incoterms)"; Text[100])
        {
            Caption = 'After Trade Term(Incoterms)';
            DataClassification = ToBeClassified;
        }
        field(65; "After Request Documents"; Text[1000])
        {
            Caption = 'After Request Documents';
            DataClassification = ToBeClassified;
        }
        field(66; "After Remarks"; Blob)
        {
            Caption = 'After Remarks';
            DataClassification = ToBeClassified;
        }
        field(67; "After Shipment(Request)"; Text[100])
        {
            Caption = 'After Shipment(Request)';
            DataClassification = ToBeClassified;
        }
        field(68; "After Sales Rep"; Text[80])
        {
            Caption = 'After Sales Rep';
            DataClassification = ToBeClassified;
        }
        field(69; "After Sales Rep(TEXT)"; Text[80])
        {
            Caption = 'After Sales Rep(TEXT)';
            DataClassification = ToBeClassified;
        }
        field(70; "After Order PIC"; Text[80])
        {
            Caption = 'After Order PIC';
            DataClassification = ToBeClassified;
        }
        field(71; "After Order PIC(TEXT)"; Text[80])
        {
            Caption = 'After Order PIC(TEXT)';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Updates current sales header remarks with the provided description.
    /// </summary>
    /// <param name="NewRemarks">New remarks.</param>
    procedure SetRemarks(NewRemarks: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Remarks);
        Rec.Remarks.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewRemarks);
    end;

    procedure SetAfterRemarks(NewRemarks: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."After Remarks");
        Rec."After Remarks".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewRemarks);
    end;

    procedure SetSalesContactNote(NewRemarks: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Sales Contact Note");
        Rec."Sales Contact Note".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewRemarks);
    end;


    /// <summary>
    /// Retrieves work description from the sales header.
    /// </summary>
    /// <returns>Work description.</returns>
    procedure GetRemarks() Remarks: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Clear(Remarks);
        CalcFields(Rec.Remarks);
        Rec.Remarks.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName(Remarks)));
    end;

    procedure GetAfterRemarks() Remarks: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Clear(Remarks);
        CalcFields(Rec."After Remarks");
        Rec."After Remarks".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("After Remarks")));
    end;

    procedure GetSalesContactNote() SalesContactNote: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Clear(SalesContactNote);
        CalcFields(Rec."Sales Contact Note");
        Rec."Sales Contact Note".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("Sales Contact Note")));
    end;
}
