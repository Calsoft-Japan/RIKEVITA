/// <summary>
/// TableExtension RIKE Posted Whse. Shipment Line (ID 50501) extends Posted Whse. Shipment Line table
/// FDD039 2026/10/21: New. (mike)
/// </summary>
tableextension 50501 "RV Posted Whse. Shipment Line" extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(50501; "RV_QA Status"; boolean)
        {
            Caption = 'QA Status';
            Description = 'FDD039';
            DataClassification = ToBeClassified;
        }
    }
}
