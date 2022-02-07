

use [MarinaAgencyDB]
-- New Version Eng/Salwa


CREATE TABLE [dbo].[TaxSubCat](
[TaxSubCat_ID] [int] IDENTITY(1,1) NOT NULL,
[SubCatName] [nvarchar](200) NULL,
[TaxCat_ID] [int] NULL,
[Rate] [float] NULL,
[Description] [nvarchar](500) NULL,
[IsDefault] [bit] NULL,
CONSTRAINT [PK_TaxSubCat] PRIMARY KEY CLUSTERED
(
[TaxSubCat_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
go
CREATE TABLE [dbo].[TaxCatgry](
[TaxCat_ID] [int] NOT NULL,
[CatName] [nvarchar](200) NULL,
CONSTRAINT [PK_TaxCatgry] PRIMARY KEY CLUSTERED
(
[TaxCat_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
Alter table RcDlInv1 
add TaxSubCat_ID int 
Go
Alter table Invoices
add IsTaxPostd bit
go
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

Go 
Insert into TaxCatgry values (1, '14-V9'),
(2,'V001') 
, (3, 'V003') 
, (4,'V003'),
(5,'V005'), 
(6, 'V006'),
(7,'V008')
Go 
select * from TaxSubCat
Insert into TaxSubCat values 
('V009', 1, 14, 'Value added tax	',1) , 
('V001', 2,0, 'Export', 0), 
('V002', 3,0, 'Export to free areas and other areas', 0), 
( 'V003',4,0,'Exempted good or service',0),
( 'V005',5,0,'Exemptions for diplomats, consulates and embassies.	e',0),
( 'V006',6, 0, 'Defence and National security Exemptions', 0),
('V008',7, 0, 'Special Exemptios and other reasons', 0)

