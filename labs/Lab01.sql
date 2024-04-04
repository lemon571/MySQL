SELECT * FROM SalesLT.Customer
SELECT Title, FirstName, MiddleName, LastName, Suffix FROM SalesLT.Customer
SELECT [SalesPerson], CONCAT (Title, FirstName) As CustomerName, Phone FROM AdventureWorksLT.SalesLT.Customer

--2
SELECT CONCAT (CustomerID, ': ', CompanyName) As CustomerCompany FROM AdventureWorksLT.SalesLT.Customer
SELECT CONCAT(SalesOrderID, ' (', RevisionNumber, ') ') As OrderRevision, CONVERT(nvarchar(30),getdate(), 102) as OrderDate FROM SalesLT.SalesOrderHeader

--3
SELECT CONCAT(FirstName,' ', MiddleName,' ',LastName) As CustomerName FROM AdventureWorksLT.SalesLT.Customer
SELECT CustomerID, ISNULL(EmailAddress, '-') As PrimaryContact FROM AdventureWorksLT.SalesLT.Customer
SELECT SalesOrderID ,
CASE
WHEN ShipDate IS NULL THEN 'AwaitingShipment'
ELSE 'Shipped'
END AS ShippingStatus 
FROM  SalesLT.SalesOrderHeader;

SELECT *
FROM SalesLT.SalesOrderHeader