/// <summary>
/// TableExtension RV Sales Header (ID 50210) extends Sales Header table
/// FDD021 2026/05/06: New. (Bobby.ji)
/// </summary>
tableextension 50210 "RV Sales Header Ext" extends "Sales Header"
{
    fields
    {

        field(50202; "RV_Country of Origin"; Text[50])
        {
            Caption = 'RV Country of Origin';
            Description = 'FDD021';
            TableRelation = "Country/Region";
        }
        field(50203; "RV_VIA"; Text[50])
        {
            Caption = 'RV VIA';
            Description = 'FDD021';
        }
        field(50204; "RV_Destination"; Text[50])
        {
            Caption = 'RV Destination';
            Description = 'FDD021';
        }
        field(50205; "RV_Feeder Vessel"; Text[50])
        {
            Caption = 'RV Feeder Vessel';
            Description = 'FDD021';
        }
        field(50206; "RV_Mother Vessel"; Text[50])
        {
            Caption = 'RV Mother Vessel';
            Description = 'FDD021';
        }
        field(50207; "RV_SAILING ON OR ABOUT"; Date)
        {
            Caption = 'RV SAILING ON OR ABOUT';
            Description = 'FDD021';
        }
    }
}
