SELECT *FROM  SalesLT.Product
SELECT *FROM SalesLT.SalesOrderDetail

SELECT ProductID, Name, ListPrice from SalesLT.Product
WHERE ListPrice >
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;


SELECT ProductID, Name, ListPrice FROM SalesLT.Product
WHERE ProductID IN
(SELECT ProductID from SalesLT.SalesOrderDetail
 WHERE UnitPrice < 100.00)
AND ListPrice >= 100.00
ORDER BY ProductID;


SELECT ProductID, Name, StandardCost, ListPrice,
    (SELECT AVG(UnitPrice)
     FROM SalesLT.SalesOrderDetail AS Pr
     WHERE Prod.ProductID = Pr.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS Prod
ORDER BY Prod.ProductID;



SELECT ProductID, Name, StandardCost, ListPrice,
(SELECT AVG(UnitPrice)
 FROM SalesLT.SalesOrderDetail AS Pr
 WHERE Prod.ProductID = Pr.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS Prod
WHERE StandardCost >
(SELECT AVG(UnitPrice)
 FROM SalesLT.SalesOrderDetail AS Pr
 WHERE Prod.ProductID = Pr.ProductID)
ORDER BY Prod.ProductID;

SELECT * FROM SalesLT.SalesOrderHeader

SELECT A.SalesOrderID, A.CustomerID, B.FirstName, B.LastName, A.TotalDue
FROM SalesLT.SalesOrderHeader AS A
CROSS APPLY dbo.ufnGetCustomerInformation(A.CustomerID) AS B
ORDER BY A.SalesOrderID;

SELECT * FROM SalesLT.CustomerAddress

SELECT C.CustomerID, B.FirstName, B.LastName, A.AddressLine1, A.City
FROM SalesLT.Address AS A
JOIN SalesLT.CustomerAddress AS C
ON A.AddressID = C.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(C.CustomerID) AS B
ORDER BY C.CustomerID;