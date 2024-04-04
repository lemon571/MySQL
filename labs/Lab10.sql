--Задача 1
--1
--Вставить заголовок заказа
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
DECLARE @OrderID int;
SET @OrderID = NEXT VALUE FOR SalesLT.SalesOrderNumber;
INSERT INTO SalesLT.SalesOrderHeader (SalesOrderID, OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderID, @OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');
PRINT @OrderID;

SELECT * FROM SalesLT.SalesOrderHeader;
--2
--Дообавление деталей к заказу
DECLARE @OrderDate1 datetime = GETDATE();
DECLARE @DueDate1 datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID1 int = 1;
INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate1, @DueDate1, @CustomerID1, 'CARGO TRANSPORT 5');
DECLARE @OrderID1 int = SCOPE_IDENTITY();


DECLARE @SalesOrderID1 int; --=1; - вторая проверка
DECLARE @ProductID1 int = 760;
DECLARE @Quantity1 int = 1;
DECLARE @UnitPrice1 money = 782.99;

IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID1)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
	VALUES (@OrderID1, @Quantity1, @ProductID1, @UnitPrice1)
END
ELSE
BEGIN
	PRINT 'Заказ не существует'
END

--Задача 2
--1
--Новые цены на велосипеды
DECLARE @MiddleMarketPrice money = 2000;
DECLARE @MaximumСustomer money = 5000;
DECLARE @MaxPrice money;
DECLARE @MiddlePrice money;

SELECT @MiddlePrice =  AVG(ListPrice), 
       @MaxPrice = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

WHILE @MiddlePrice < @MiddleMarketPrice
BEGIN
   UPDATE SalesLT.Product
   SET ListPrice = ListPrice * 1.1
   WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');
	  
	SELECT @MiddlePrice =  AVG(ListPrice), 
	       @MaxPrice = MAX(ListPrice)
	FROM SalesLT.Product
	WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

   IF @MaxPrice >= @MaximumСustomer
      BREAK
   ELSE
      CONTINUE
END
PRINT 'Новая максимальная цена велосипеда ' + CONVERT(varchar, @MaxPrice);
PRINT 'Новая средняя цена на велосипед ' + CONVERT(varchar, @MiddlePrice);