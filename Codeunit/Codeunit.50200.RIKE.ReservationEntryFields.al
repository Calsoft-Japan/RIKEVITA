/// <summary>
/// Codeunit RIKE Reservation Entry Addtion Fields (ID 50200)
/// FDD001 2026/03/12: New. (Bobby.ji)
/// </summary>
codeunit 50200 "RIKE Reservation Entry Fields"
{
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterMoveFields, '', false, false)]
    local procedure "Item Tracking Lines_OnAfterMoveFields"(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    var
        Item: Record Item;
    begin
        ReservEntry."RV_Manufacture Date" := TrkgSpec."RV_Manufacture Date";
        Item.Get(TrkgSpec."Item No.");
        if Item."RV_Expiration Base Date (RM)" = Item."RV_Expiration Base Date (RM)"::"Manufacture Date" then begin
            ReservEntry."Expiration Date" := CalcDate(Item."Expiration Calculation", ReservEntry."RV_Manufacture Date");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", OnAfterCopyTrackingFromTrackingSpec, '', false, false)]
    local procedure "Reservation Entry_OnAfterCopyTrackingFromTrackingSpec"(var ReservationEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        ReservationEntry."RV_Manufacture Date" := TrackingSpecification."RV_Manufacture Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterCreateReservEntryFor, '', false, false)]
    local procedure "Create Reserv. Entry_OnAfterCreateReservEntryFor"(var ReservationEntry: Record "Reservation Entry"; Sign: Integer; ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; QuantityBase: Decimal; ForReservEntry: Record "Reservation Entry")
    var
        Item: Record Item;
    begin
        ReservationEntry."RV_Manufacture Date" := ForReservEntry."RV_Manufacture Date";
        if ReservationEntry."Item No." <> '' then begin
            Item.Get(ReservationEntry."Item No.");
            if Item."RV_Expiration Base Date (RM)" = Item."RV_Expiration Base Date (RM)"::"Manufacture Date" then begin
                ReservationEntry."Expiration Date" := CalcDate(Item."Expiration Calculation", ReservationEntry."RV_Manufacture Date");
            end;
        end;
    end;

}
