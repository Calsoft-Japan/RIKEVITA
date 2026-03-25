/// <summary>
/// Codeunit RIKE Reservation Entry Addtion Fields (ID 50200)
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
codeunit 50200 "RV Reservation Entry Fields"
{

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterSetQtyToHandleAndInvoiceOnBeforeReservEntryModify, '', false, false)]
    local procedure "Item Tracking Lines_OnAfterSetQtyToHandleAndInvoiceOnBeforeReservEntryModify"(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification"; var TotalTrackingSpecification: Record "Tracking Specification"; var ModifyLine: Boolean)

    var
        Item: Record Item;
    begin
        ReservEntry."RV Container No." := TrackingSpecification."RV Container No.";//FDD008
        ReservEntry."RV Manufacture Date" := TrackingSpecification."RV Manufacture Date";
        Item.Get(TrackingSpecification."Item No.");
        if Item."RV Expiration Base Date (RM)" = Item."RV Expiration Base Date (RM)"::"Manufacture Date" then begin
            ReservEntry."Expiration Date" := CalcDate(Item."Expiration Calculation", ReservEntry."RV Manufacture Date");
        end;
        ModifyLine := true;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", OnAfterCopyTrackingFromTrackingSpec, '', false, false)]
    local procedure "Reservation Entry_OnAfterCopyTrackingFromTrackingSpec"(var ReservationEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        ReservationEntry."RV Container No." := TrackingSpecification."RV Container No.";//FDD008
        ReservationEntry."RV Manufacture Date" := TrackingSpecification."RV Manufacture Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterCreateReservEntryFor, '', false, false)]
    local procedure "Create Reserv. Entry_OnAfterCreateReservEntryFor"(var ReservationEntry: Record "Reservation Entry"; Sign: Integer; ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; QuantityBase: Decimal; ForReservEntry: Record "Reservation Entry")
    var
        Item: Record Item;
    begin
        ReservationEntry."RV Container No." := ForReservEntry."RV Container No.";//FDD008
        ReservationEntry."RV Manufacture Date" := ForReservEntry."RV Manufacture Date";
        if ReservationEntry."Item No." <> '' then begin
            Item.Get(ReservationEntry."Item No.");
            if Item."RV Expiration Base Date (RM)" = Item."RV Expiration Base Date (RM)"::"Manufacture Date" then begin
                ReservationEntry."Expiration Date" := CalcDate(Item."Expiration Calculation", ReservationEntry."RV Manufacture Date");
            end;
        end;
    end;



}
