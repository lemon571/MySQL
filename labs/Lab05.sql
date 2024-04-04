--Задача 1
--1
SELECT *FROM SalesLT.Product
SELECT ProductId, UPPER(Name) As ProductName, ROUND(Weight, 0) As ApprowWeight FROM SalesLT.Product;
--2
SELECT ProductId, Name As ProductName, ROUND(Weight, 0) As ApprowWeight, DATEPART(yyyy, SellStartDate) As SellStartYear, 
DATENAME(mm, SellStartDate)As SellStartMonth FROM SalesLT.Product;
--3
SELECT ProductId, Name As ProductName, ROUND(Weight, 0) As ApprowWeight, DATEPART(yyyy, SellStartDate) As SellStartYear, 
DATENAME(mm, SellStartDate)As SellStartMonth, 
LEFT(ProductNumber,2) As ProductType FROM SalesLT.Product;
--4
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight,
YEAR(SellStartDate) as SellStartYear, DATENAME(m, SellStartDate) As SellStartMonth,
LEFT(ProductNumber, 2) AS ProductType FROM SalesLT.Product WHERE ISNUMERIC(Size)=1;

--Задача 2
--1
SELECT *FROM SalesLT.SalesOrderHeader
SELECT *FROM SalesLT.Customer

SELECT CompanyName, TotalDue AS Revenue, RANK() OVER (ORDER BY TotalDue DESC) AS RankByRevenue
FROM SalesLT.SalesOrderHeader AS Conn
JOIN SalesLT.Customer AS Con
ON Conn.CustomerID = Con.CustomerID;

--Задача 3
--1
SELECT *FROM SalesLT.SalesOrderDetail
SELECT *FROM SalesLT.Product

SELECT Name,SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS A
JOIN SalesLT.Product AS B ON A.ProductID=B.ProductID
GROUP BY B.Name
ORDER BY TotalRevenue DESC;

--2
SELECT Name,SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS A
JOIN SalesLT.Product AS B ON A.ProductID=B.ProductID
WHERE B.ListPrice > 1000
GROUP BY B.Name
ORDER BY TotalRevenue DESC;


--3
SELECT Name,SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS A
JOIN SalesLT.Product AS B ON A.ProductID = B.ProductID
WHERE B.ListPrice > 1000
GROUP BY B.Name
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC;