codeunit 50107 "RV WhsePostEventHandler"
{
    SingleInstance = true;  // 跨事件共享状态 base on web session

    var
        IsFromWhseShipmentPost: Boolean;

    procedure SetFromWhseShipment()
    begin
        IsFromWhseShipmentPost := true;
    end;

    procedure ClearMarker()
    begin
        IsFromWhseShipmentPost := false;
    end;

    procedure IsFromWhseShipment(): Boolean
    begin
        exit(IsFromWhseShipmentPost);
    end;
}
