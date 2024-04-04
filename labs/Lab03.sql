--Задание #1
--SELECT a.CompanyName, b.SalesOrderID, b.TotalDue FROM SalesLT.Customer AS a JOIN SalesLT.SalesOrderHeader AS b ON (a.CustomerID = b.CustomerID)
SELECT k.CustomerID, q.ProductID FROM SalesLT.Customer AS k FULL JOIN SalesLT.SalesOrderHeader AS l ON k.CustomerID = l.CustomerID FULL JOIN SalesLT.SalesOrderDetail AS m
ON m.SalesOrderID = l.SalesOrderID FULL JOIN SalesLT.Product AS q ON q.ProductID = m.ProductID WHERE l.SalesOrderID IS NULL ORDER BY ProductID, CustomerID