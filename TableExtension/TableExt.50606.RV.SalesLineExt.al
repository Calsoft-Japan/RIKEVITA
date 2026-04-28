/// <summary>
/// TableExtension RV Sales Line (ID 50606) extends Sales Line table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50606 "RV Sales Line" extends "Sales Line"
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
        field(50603; "RV_isNotNew"; Boolean)
        {
            Caption = 'Is New';
            DataClassification = ToBeClassified;
        }
    }
}
