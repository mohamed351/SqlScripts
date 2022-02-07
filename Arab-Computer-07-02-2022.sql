USE [acsNet_data]
GO

/****** Object:  View [dbo].[EInvoice]    Script Date: 07/02/2022 10:37:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[EInvoice]
AS
    SELECT dbo.INVOICES.InvoiceNo AS InternalID, dbo.INVOICES.AccName AS ReceiverName, dbo.Clients.RegTaxNo AS ReceiverID, dbo.Clients.RgstrTyp AS ReceiverType, 'I' AS DocumentType, dbo.INVOICE_DTL.ITEMNAME AS Description,
        dbo.INVOICES.InvoiceDate AS DateTimeIssued, dbo.INVOICE_DTL.Qty AS quantity, dbo.Currencies.crrNAMEE AS currencySold, ROUND(dbo.INVOICE_DTL.LstPrice, 2) AS amountEGP,
        (SELECT MAX(ItemCode) AS Expr1
        FROM dbo.Stores AS st
        WHERE (ItemID = dbo.INVOICE_DTL.ITEMID)) AS ItemCode , dbo.DetectCodeEGSorGS1((SELECT MAX(ItemCode) AS Expr1
        FROM dbo.Stores AS st
        WHERE (ItemID = dbo.INVOICE_DTL.ITEMID))) AS ItemType,
        'EA' AS UnitTypes, ROUND(dbo.INVOICE_DTL.LstPrice, 2) AS AmountSold,
        CASE WHEN CURRID = 1 THEN 1 ELSE invoices.rate END AS currencyExchangeRate,
        dbo.INVOICES.DiscountPerc * 100 AS DiscountRate, ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty * dbo.INVOICES.DiscountPerc, 2) AS DiscountValue,
        ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty, 2) AS Invoice_Line_SalesTotal, ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty, 2) 
                         - ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty * ISNULL(dbo.INVOICES.DiscountPerc, 0), 2) AS Invoice_Line_NetTotal, dbo.INVOICE_DTL.SlsTx AS TaxRate,
        CASE WHEN SlsTx > 0 THEN 
						 (dbo.INVOICE_DTL.SlsTx /100) * ( ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty, 2) 
                         - ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty * ISNULL(dbo.INVOICES.DiscountPerc, 0), 2))
						  ELSE 0 
						  END AS TaxAmount,
        ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty, 2) 
                         - ROUND(dbo.INVOICE_DTL.LstPrice * dbo.INVOICE_DTL.Qty * ISNULL(dbo.INVOICES.DiscountPerc, 0), 2) + CASE WHEN SlsTx > 0 
						 THEN ROUND(dbo.INVOICE_DTL.Qty * (dbo.INVOICE_DTL.Price - dbo.INVOICE_DTL.LstPrice), 
                         2) 
						 ELSE
						  0 END AS Total,
        NULL as City,
        NULL as Country
    FROM dbo.INVOICES LEFT OUTER JOIN
        dbo.Clients ON dbo.INVOICES.ACCID = dbo.Clients.AccID LEFT OUTER JOIN
        dbo.Currencies ON dbo.INVOICES.CURRID = dbo.Currencies.crrID LEFT OUTER JOIN
        dbo.INVOICE_DTL ON dbo.INVOICES.PrmKy = dbo.INVOICE_DTL.INVOICENO
    WHERE        (dbo.INVOICE_DTL.Qty > 0) AND (dbo.INVOICES.InvPro = 1) and dbo.INVOICE_DTL.LstPrice !=0
GO


ALTER proc [dbo].[RefreshDocument]
    @InvoiceID nvarchar(max)
as
select *
from EInvoice
where InternalID = @InvoiceID
GO

ALTER proc [dbo].[sp_EInvoice_Details]
    @DateFrom as Date,
    @DateTo as Date
as
select *
from [EInvoice]
where DateTimeIssued between @DateFrom and @DateTo
GO




