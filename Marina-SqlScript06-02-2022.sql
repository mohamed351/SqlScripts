--Old Version My Edit
ALTER VIEW [dbo].[EInvoice_v1]
AS
SELECT        TOP (100) PERCENT dbo.RcDlInv1.INVSR AS InternalID, dbo.Clients.ClientNm AS ReceiverName, dbo.Clients.TxCrdNo AS ReceiverID, 
                         CASE WHEN RgstrTyp = 1 THEN 'B' ELSE CASE WHEN RgstrTyp = 5 THEN 'P' ELSE CASE WHEN RgstrTyp = 7 THEN 'F' END END END AS ReceiverType, 'I' AS DocumentType, 
                         CASE WHEN rcvdlvtrf.NoStax = 1 THEN dbo.RcvDlvTrf.ItmNm + ' укнь о.у' ELSE dbo.RcvDlvTrf.ItmNm END AS Description, dbo.RcDlInv1.INVDT AS DateTimeIssued, CASE WHEN qty = 0 OR
                         qty IS NULL THEN 1 ELSE qty END AS quantity, CASE WHEN (RcDlInv2.CCODE) = 'LE' THEN 'EGP' ELSE RcDlInv2.ccode END AS currencySold, dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
                         qty IS NULL THEN 1 ELSE qty END) AS amountEGP, 'EG-202446077-'+ CAST( CASE WHEN rcvdlvtrf.NoStax = 1 THEN AccIDNoTax ELSE accid END as nvarchar(50)) AS ItemCode, 'EGS' AS ItemType, 'EA' AS UnitTypes, dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
                         qty IS NULL THEN 1 ELSE qty END) AS AmountSold, 1 AS currencyExchangeRate, dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
                         qty IS NULL THEN 1 ELSE qty END) AS amountEGP2, ROUND(CASE WHEN discount = 0 THEN 0 ELSE 100 * (dbo.RcDlInv1.Discount / (dbo.RcDlInv1.TTLAMT - dbo.RcDlInv1.SlsTx + ISNULL(dbo.RcDlInv1.Discount, 0))) END, 7) 
                         AS DiscountRate, CASE WHEN rcdlinv2.actamt =
                             (SELECT        MAX(actamt)
                                FROM            rcdlinv2 r21
                                WHERE        r21.inv1ky = rcdlinv2.inv1ky) THEN discount ELSE 0 END AS DiscountValue, ROUND(dbo.RcDlInv2.ACTAMT, 2) AS Invoice_Line_SalesTotal, dbo.RcDlInv2.ACTAMT - CASE WHEN rcdlinv2.actamt =
                             (SELECT        MAX(actamt)
                                FROM            rcdlinv2 r21
                                WHERE        r21.inv1ky = rcdlinv2.inv1ky) THEN discount ELSE 0 END AS Invoice_Line_NetTotal, CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND 
                         rcdlinv1.slstx > 0 THEN dbo.RcvDlvTrfMn.SlsTxAmt * 100 ELSE 0 END AS TaxRate, ROUND(CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND rcdlinv1.slstx > 0 THEN slstxamt * RcDlInv2.ActAmt ELSE 0 END, 2) AS TaxAmount, 
                         dbo.RcDlInv2.ACTAMT - CASE WHEN rcdlinv2.actamt =
                             (SELECT        MAX(actamt)
                                FROM            rcdlinv2 r21
                                WHERE        r21.inv1ky = rcdlinv2.inv1ky) THEN discount ELSE 0 END + ROUND(CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND rcdlinv1.slstx > 0 THEN slstxamt * RcDlInv2.ActAmt ELSE 0 END, 2) AS Total, '-' AS City, 
                         Clients.ClientCntry AS Country, Clients.ClientAdrs as ReciverAddress, dbo.RcDlInv2.Inv1Ky, dbo.RcDlInv1.INVDGT, dbo.RcDlInv1.Inv1Ky AS Ky
FROM            dbo.RcDlInv1 LEFT OUTER JOIN
                         dbo.RcvDlvTrfMn ON dbo.RcDlInv1.TrfKy = dbo.RcvDlvTrfMn.ID LEFT OUTER JOIN
                         dbo.Clients ON dbo.RcDlInv1.InvClnt = dbo.Clients.ClientId LEFT OUTER JOIN
                         dbo.RcvDlvTrf RIGHT OUTER JOIN
                         dbo.RcDlInv2 ON dbo.RcvDlvTrf.ID = dbo.RcDlInv2.[KEY] ON dbo.RcDlInv1.Inv1Ky = dbo.RcDlInv2.Inv1Ky
WHERE        (dbo.RcDlInv1.INVDGT <> 5) AND (dbo.RcDlInv1.INVDGT <> 11) AND (dbo.RcDlInv1.INVDGT <> 10) AND (dbo.RcDlInv1.INVDGT <> 23) AND (dbo.RcDlInv1.INVDGT <> 8) AND (dbo.RcDlInv2.Inv1Ky IS NOT NULL) AND 
                         (CASE WHEN (RcDlInv2.CCODE) = 'LE' THEN 'EGP' ELSE RcDlInv2.ccode END = 'EGP') AND (dbo.RcDlInv1.INVSR > 0) AND (YEAR(dbo.RcDlInv1.INVDT) > 2020)
ORDER BY dbo.RcDlInv2.Inv1Ky




GO
-- New Version Eng/Salwa


SELECT TOP (100) PERCENT dbo.RcDlInv1.INVSR AS InternalID, dbo.Clients.ClientNm AS ReceiverName, dbo.Clients.ClientAdrs AS ReciverAddress, dbo.Clients.ClientCntry AS Country, '' AS City, dbo.Clients.TxCrdNo AS ReceiverID,
CASE WHEN RgstrTyp = 1 THEN 'B' ELSE CASE WHEN RgstrTyp = 5 THEN 'P' ELSE CASE WHEN RgstrTyp = 7 THEN 'F' END END END AS ReceiverType, 'I' AS DocumentType,
CASE WHEN rcvdlvtrf.NoStax = 1 THEN dbo.RcvDlvTrf.ItmNm + ' укнь о.у' ELSE dbo.RcvDlvTrf.ItmNm END AS Description, dbo.RcDlInv1.INVDT AS DateTimeIssued, CASE WHEN qty = 0 OR
qty IS NULL THEN 1 ELSE qty END AS quantity, CASE WHEN (RcDlInv2.CCODE) = 'LE' THEN 'EGP' ELSE RcDlInv2.ccode END AS currencySold, dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
qty IS NULL THEN 1 ELSE qty END) AS amountEGP, 'EG-202446077-' + LTRIM(STR(CASE WHEN rcvdlvtrf.NoStax = 1 THEN AccIDNoTax ELSE accid END)) AS ItemCode, 'EGS' AS ItemType, 'EA' AS UnitTypes,
dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
qty IS NULL THEN 1 ELSE qty END) AS AmountSold, 1 AS currencyExchangeRate, dbo.RcDlInv2.ACTAMT / (CASE WHEN qty = 0 OR
qty IS NULL THEN 1 ELSE qty END) AS amountEGP2, dbo.RcDlInv1.Discount AS DiscountRate, ROUND(CASE WHEN isnull(RcDlInv1.Discount, 0) > 0 THEN RcDlInv1.Discount * RcDlInv2.ActAmt ELSE 0 END, 2)
AS DiscountValue, ROUND(dbo.RcDlInv2.ACTAMT, 2) AS Invoice_Line_SalesTotal, dbo.RcDlInv2.ACTAMT - ROUND(CASE WHEN isnull(RcDlInv1.Discount, 0) > 0 THEN RcDlInv1.Discount * RcDlInv2.ActAmt ELSE 0 END, 2)
AS Invoice_Line_NetTotal, CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND rcdlinv1.slstx > 0 THEN dbo.RcvDlvTrfMn.SlsTxAmt * 100 ELSE 0 END AS TaxRate, ROUND(CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND
rcdlinv1.slstx > 0 THEN slstxamt * RcDlInv2.ActAmt ELSE 0 END, 2) AS TaxAmount, dbo.RcDlInv2.ACTAMT - ROUND(CASE WHEN isnull(RcDlInv1.Discount, 0) > 0 THEN RcDlInv1.Discount * RcDlInv2.ActAmt ELSE 0 END, 2)
+ ROUND(CASE WHEN isnull(RcDlInv2.NOSTax, 0) = 0 AND rcdlinv1.slstx > 0 THEN slstxamt * RcDlInv2.ActAmt ELSE 0 END, 2) AS Total, dbo.RcDlInv2.Inv1Ky, dbo.RcDlInv1.INVDGT, dbo.RcDlInv1.Inv1Ky AS Ky,
dbo.TaxCatgry.CatName AS Tax_Type, dbo.TaxSubCat.SubCatName AS Tax_Sub_Type
FROM dbo.TaxCatgry RIGHT OUTER JOIN
dbo.TaxSubCat ON dbo.TaxCatgry.TaxCat_ID = dbo.TaxSubCat.TaxCat_ID RIGHT OUTER JOIN
dbo.RcDlInv1 ON dbo.TaxSubCat.TaxSubCat_ID = dbo.RcDlInv1.TaxSubCat_ID LEFT OUTER JOIN
dbo.RcvDlvTrfMn ON dbo.RcDlInv1.TrfKy = dbo.RcvDlvTrfMn.ID LEFT OUTER JOIN
dbo.Clients ON dbo.RcDlInv1.InvClnt = dbo.Clients.ClientId LEFT OUTER JOIN
dbo.RcvDlvTrf RIGHT OUTER JOIN
dbo.RcDlInv2 ON dbo.RcvDlvTrf.ID = dbo.RcDlInv2.[KEY] ON dbo.RcDlInv1.Inv1Ky = dbo.RcDlInv2.Inv1Ky
WHERE (dbo.RcDlInv1.INVDGT <> 5) AND (dbo.RcDlInv1.INVDGT <> 11) AND (dbo.RcDlInv1.INVDGT <> 10) AND (dbo.RcDlInv1.INVDGT <> 23) AND (dbo.RcDlInv1.INVDGT <> 8) AND (dbo.RcDlInv2.Inv1Ky IS NOT NULL) AND
(CASE WHEN (RcDlInv2.CCODE) = 'LE' THEN 'EGP' ELSE RcDlInv2.ccode END = 'EGP') AND (dbo.RcDlInv1.INVSR > 0) AND (YEAR(dbo.RcDlInv1.INVDT) > 2020)
ORDER BY dbo.RcDlInv2.Inv1Ky