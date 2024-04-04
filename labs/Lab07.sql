--Задача 1
--1
-- Получение описаний моделей продуктово(тображение)
SELECT A.ProductID, A.Name AS ProductName, B.Name AS ProductModel, B.Summary FROM SalesLT.Product AS A
INNER JOIN SalesLT.vProductModelCatalogDescription AS B ON A.ProductModelID = B.ProductModelID
ORDER BY ProductID;

--2
-- Создайте таблицу различных цветов (табличная переменная)
--
 DECLARE @Colors AS TABLE (Color varchar(15));  


 INSERT INTO @Colors  
 SELECT DISTINCT Color FROM SalesLT.Product;  
--
 SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product  
 WHERE Color IN (SELECT Color FROM @Colors); 


--3 (временная таблица)
 CREATE TABLE #tmp(ProductName varchar(50), Size varchar(50));
 INSERT INTO #tmp
 SELECT DISTINCT Name As ProductName, Size FROM SalesLT.Product;
 SELECT Name AS ProductName, Size FROM SalesLT.Product
 WHERE Size IN (SELECT Size FROM #tmp)
 ORDER BY Size DESC;
 DROP TABLE #tmp;

--4 (табличная функция)
SELECT * FROM SalesLT.ProductCategory
SELECT * FROM SalesLT.Product
SELECT A.ParentProductCategoryName AS ParentCategory, A.ProductCategoryName AS Category, B.ProductID, B.Name AS ProductName
FROM SalesLT.Product AS B
JOIN dbo.ufnGetAllCategories() AS A
ON B.ProductCategoryID = A.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;

--Задача 2
--1
-- Получить доход от продаж по компаниям и контактам (используя производную таблицу)
SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM (
               SELECT CONCAT (A.CompanyName, CONCAT('  ('  +  A.FirstName + ' ', A.LastName  +  ') ') ),  B.TotalDue
               FROM SalesLT.SalesOrderHeader AS B
               JOIN SalesLT.Customer AS A
               ON B.CustomerID = A.CustomerID) AS 
			   CustomerSales (CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;

--2
-- Получить доход от продаж по компаниям и контактам (используя CTE)
WITH CTE_CustomerSales(CompanyContact, SalesAmount)  
AS  
 (
   SELECT CONCAT (A.CompanyName, CONCAT(' (' + A.FirstName + ' ', A.LastName + ')')), B.TotalDue  
   FROM SalesLT.SalesOrderHeader AS B  
   JOIN SalesLT.Customer AS A  
   ON B.CustomerID = A.CustomerID
)  
SELECT CompanyContact, SUM(SalesAmount) AS Revenue  
FROM CTE_CustomerSales  
GROUP BY CompanyContact  
ORDER BY CompanyContact;  

