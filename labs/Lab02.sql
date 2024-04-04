SELECT * FROM AdventureWorksLT.SalesLT.Product


--Задача #1
--SELECT Distinct City, StateProvince From AdventureWorksLT.SalesLT.Address ORDER BY City
--SELECT Distinct Name, Weight From AdventureWorksLT.SalesLT.Product ORDER BY Weight
--Select top 10 PERCENT Name, Weight From AdventureWorksLT.SalesLT.Product ORDER BY Weight DESC
--Select Name, Weight From AdventureWorksLT.SalesLT.Product ORDER BY Weight DESC OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY;

--Задача #2
--SELECT Name, Color, Size FROM AdventureWorksLT.SalesLT.Product WHERE ProductModelID=1;
--SELECT Name, ProductNumber, Color, Size FROM AdventureWorksLT.SalesLT.Product WHERE Color IN ('Black', 'Red', 'White') AND Size IN('M', 'S')
Select ProductNumber, Name, ListPrice FROM AdventureWorksLT.SalesLT.Product WHERE ProductNumber LIKE 'BK_[^R]%-[0-9][0-9]'