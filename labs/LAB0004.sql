SELECT * FROM AdventureWorksLT.SalesLT.SalesOrderHeader
--Задание #1
--1.
SELECT a.CompanyName, b.SalesOrderID, b.TotalDue FROM SalesLT.Customer AS a JOIN SalesLT.SalesOrderHeader AS b ON (a.CustomerID = b.CustomerID)
--2

/*
SELECT CustomerID, AddressLine1 +ISNULL(AddressLine2,'') AS Address, City, StateProvince, PostalCode, CountryRegion FROM SalesLT.Address AS a INNER JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office';
*/
--Задача#2
--1
SELECT k.CompanyName, k.FirstName, k.LastName, q.SalesOrderID, q.TotalDue FROM SalesLT.SalesOrderHeader /*SalesLT.Customer*/ AS q
RIGHT JOIN SalesLT.Customer /*SalesLT.SalesOrderHeader*/ AS k ON q.CustomerID = k.CustomerID ORDER by q.SalesOrderID DESC
--2
SELECT k.CompanyName, k.FirstName, k.LastName, k.Phone FROM SalesLT.Customer AS k LEFT JOIN SalesLT.CustomerAddress AS kq ON k.CustomerID = kq.CustomerID
WHERE kq.AddressID IS NULL
--3
SELECT k.CustomerID, q.ProductID FROM SalesLT.Customer AS k FULL JOIN SalesLT.SalesOrderHeader AS l ON k.CustomerID = l.CustomerID FULL JOIN SalesLT.SalesOrderDetail AS m
ON m.SalesOrderID = l.SalesOrderID FULL JOIN SalesLT.Product AS q ON q.ProductID = m.ProductID WHERE l.SalesOrderID IS NULL ORDER BY ProductID, CustomerID