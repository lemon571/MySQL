--Задача 1
--1 (множество группирововк с комбинациями)
 SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--2
SELECT a.CountryRegion, a.StateProvince,
IIF(GROUPING_ID (a.CountryRegion) = 1 AND GROUPING_ID (a.StateProvince) = 1, 'Total', IIF ( GROUPING_ID (a.StateProvince) = 1, a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal')) AS Level,
SUM(soh.TotalDue) AS Revenue FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--3
SELECT a.CountryRegion, a.StateProvince, a.City,  
     CHOOSE (1 + GROUPING_ID (a.CountryRegion) + GROUPING_ID ( a.StateProvince) + GROUPING_ID ( a.City), a.City + ' Subtotal', a.StateProvince + ' Subtotal', a.CountryRegion + ' Subtotal', 'Total') AS Level,  
     SUM (soh.TotalDue) AS Revenue  
     FROM SalesLT.Address AS a  
     JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID  
     JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID  
     JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID  
     GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)  
ORDER BY a.CountryRegion, a.StateProvince, a.City;  

--Задача 2 (представление)
--1
 SELECT * FROM  
 (SELECT A.ParentProductCategoryName, B.CompanyName, C.LineTotal  
  FROM SalesLT.SalesOrderDetail AS C  
  JOIN SalesLT.SalesOrderHeader AS D ON C.SalesOrderID = D.SalesOrderID  
  JOIN SalesLT.Customer AS B ON D.CustomerID = B.CustomerID  
  JOIN SalesLT.Product AS E ON C.ProductID = E.ProductID  
  JOIN SalesLT.vGetAllCategories AS A ON E.ProductcategoryID = A.ProductCategoryID) AS catsales  
  PIVOT 
  (
    SUM(LineTotal) FOR ParentProductCategoryName IN ([Accessories], [Bikes], [Clothing], [Components])
   ) AS pivotedsales  
 ORDER BY CompanyName;  