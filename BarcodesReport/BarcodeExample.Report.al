report 50150 "Barcode Example"
{
    Caption = 'BarcodeReport';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'BarcodeReport';
    DefaultLayout = RDLC;
    RDLCLayout = './BarcodeExample.rdl';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(recTmpBlob1_Blob; recTmpBlob1.Blob)
            {
            }
            column(txcEAN13; txcEAN13)
            {
            }
            column(recTmpBlob2_Blob; recTmpBlob2.Blob)
            {
            }
            column(txcCode128; txcCode128)
            {
            }
            column(recTmpBlob3_Blob; recTmpBlob3.Blob)
            {
            }
            column(txcCode39; txcCode39)
            {
            }
            column(recTmpBlob4_Blob; recTmpBlob4.Blob)
            {
            }
            column(txcEAN8; txcEAN8)
            {
            }
            column(EAN13Caption; EAN13CaptionLbl)
            {
            }
            column(CODE128Caption; CODE128CaptionLbl)
            {
            }
            column(CODE39Caption; CODE39CaptionLbl)
            {
            }
            column(EAN8Caption; EAN8CaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                cduBarcodeMgt.EncodeEAN13(txcEAN13, 1, false, recTmpBlob1);
                cduBarcodeMgt.EncodeCode128(txcCode128, 1, false, recTmpBlob2);
                cduBarcodeMgt.EncodeCode39(txcCode39, 1, false, false, recTmpBlob3);
                cduBarcodeMgt.EncodeEAN8(txcEAN8, 1, true, recTmpBlob4);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        cduBarcodeMgt: Codeunit "Barcode Mgt.";
        recTmpBlob1: Record TempBlob temporary;
        recTmpBlob2: Record TempBlob temporary;
        recTmpBlob3: Record TempBlob temporary;
        recTmpBlob4: Record TempBlob temporary;
        txcEAN13: Label '007567816412';
        txcCode128: Label '(00)387123456700010276';
        txcCode39: Label 'CODE 39';
        txcEAN8: Label '5512345';
        EAN13CaptionLbl: Label 'EAN13';
        CODE128CaptionLbl: Label 'CODE128';
        CODE39CaptionLbl: Label 'CODE39';
        EAN8CaptionLbl: Label 'EAN8';
}

