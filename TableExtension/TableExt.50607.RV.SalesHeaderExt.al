/// <summary>
/// TableExtension RV Sales Header (ID 50607) extends Sales Header table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50607 "RV_Sales Header" extends "Sales Header"
{
    fields
    {
        field(50600; "RV_ECR Required"; Boolean)
        {
            Caption = 'ECR Required';
            DataClassification = ToBeClassified;
        }

        field(50601; "RV_ECR Date"; Date)
        {
            Caption = 'ECR Date';
            DataClassification = ToBeClassified;
        }

        field(50602; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            DataClassification = ToBeClassified;
        }
    }
}
