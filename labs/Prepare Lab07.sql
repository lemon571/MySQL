SELECT * FROM SalesLT.Product
SELECT * FROM SalesLT.ProductDescription
SELECT * FROM SalesLT.ProductModel
SELECT * FROM SalesLT.ProductModelProductDescription

SELECT A.ProductID, A.Name AS ProductName, B.Name AS ProductModel, B.Summary FROM SalesLT.Product AS A
JOIN SalesLT.vProductModelCatalogDescription AS B ON A.ProductModelID = B.ProductModelID
ORDER BY ProductID;

--DECLARE @Colors AS TABLE (Color varchar(15));
--/////
--INSERT INTO @Colors
--SELECT DISTINCT Color FROM SalesLT.Product;

--DECLARE @LastName NVARCHAR(30), @FirstName NVARCHAR(20), @StateProvince NCHAR(2);

SELECT * FROM @Colors;
SELECT * FROM SalesLT.Product
DECLARE @Colors AS TABLE (Color nvarchar(15));
INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;
SELECT ProductID, Name, Color FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @Colors);

--
 DECLARE @Colors AS TABLE (Color varchar(15));  


 INSERT INTO @Colors  
 SELECT DISTINCT Color FROM SalesLT.Product;  
--
 SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product  
 WHERE Color IN (SELECT Color FROM @Colors); 

-- SELECT Size, Name AS ProductName
 --INTO #tmpProducts
 --FROM SalesLT.Product
 --WHERE Size IN (SELECT Size FROM #tmpProducts);
 
 SELECT * FROM SalesLT.Product
 ORDER BY Size DESC;
 CREATE TABLE #tmpProducts(Name varchar(50), Size nvarchar(50));
 INSERT INTO #tmpProducts(Name, Size) 
 SELECT Name, Size FROM SalesLT.Product
 WHERE Size IN (SELECT SIZE FROM #tmpProducts);
 DROP TABLE #tmpProducts
  --SELECT * FROM #tmpProducts
  --ORDER BY Size DESC;

    WHERE Size IN (SELECT SIZE FROM #tmpProducts);
	ORDER BY Size DESC;

  WHERE Size IN  #tmpProducts;

  WHERE Size IN (SELECT SIZE FROM #tmpProducts);
  --ORDER BY Size DESC;
 WHERE Size IN  #tmpProducts;
 DROP TABLE #tmpProducts
 SELECT * FROM #tmpProducts

 CREATE TABLE #tmp(ProductName varchar(50), Size varchar(50));
 INSERT INTO #tmp
 SELECT DISTINCT Name As ProductName, Size FROM SalesLT.Product;
 SELECT Name AS ProductName, Size FROM SalesLT.Product
 WHERE Size IN (SELECT Size FROM #tmp)
 ORDER BY Size DESC;
 DROP TABLE #tmp;

SELECT * FROM SalesLT.ProductCategory
SELECT * FROM SalesLT.Product
SELECT A.ParentProductCategoryName AS ParentCategory, A.ProductCategoryName AS Category, B.ProductID, B.Name AS ProductName
FROM SalesLT.Product AS B
JOIN dbo.ufnGetAllCategories() AS A
ON B.ProductCategoryID = B.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;


SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM 
     (SELECT CONCAT (A.CompanyName, CONCAT('  ('  +  A.FirstName + ' ', A.LastName  +  ') ') ),  B.TotalDue
    FROM SalesLT.SalesOrderHeader AS B
     JOIN SalesLT.Customer AS A
     ON B.CustomerID = A.CustomerID) AS CustomerSales (CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;

WITH CustomerSales(CompanyContact, SalesAmount)  
AS  
 (
   SELECT CONCAT (A.CompanyName, CONCAT(' (' + A.FirstName + ' ', A.LastName + ')')), B.TotalDue  
   FROM SalesLT.SalesOrderHeader AS B  
   JOIN SalesLT.Customer AS A  
   ON B.CustomerID = A.CustomerID
)  
SELECT CompanyContact, SUM(SalesAmount) AS Revenue  
FROM CustomerSales  
GROUP BY CompanyContact  
ORDER BY CompanyContact;  